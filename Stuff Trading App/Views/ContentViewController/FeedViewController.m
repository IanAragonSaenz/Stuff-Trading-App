//
//  FeedViewController.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 13/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "FeedViewController.h"
#import "PostCell.h"
#import "SceneDelegate.h"
#import <Parse/Parse.h>
#import "User.h"
#import "DetailPostViewController.h"
#import "UIAlertController+Utils.h"
#import "SectionCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *sectionsTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) NSArray *filteredPosts;
@property (strong, nonatomic) UIRefreshControl *refresh;
@property (assign, nonatomic) BOOL isLoadingMoreData;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSMutableArray *selectedSections;
@property (nonatomic) int countSelectedSections;
@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.sectionsTableView.delegate = self;
    self.sectionsTableView.dataSource = self;
    self.posts = [NSArray array];
    self.countSelectedSections = 0;
    
    [self.sectionsTableView setHidden:YES];
    
    self.searchBar = [UISearchBar new];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search here...";
    
    //creating view container and button
    UIView *buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    buttonContainer.backgroundColor = [UIColor clearColor];
    UIButton *filterButton = [UIButton new];
    [filterButton setBackgroundImage:[UIImage imageNamed:@"icon-dropdown"] forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(changeTableVisibility) forControlEvents:UIControlEventTouchUpInside];
    [filterButton setShowsTouchWhenHighlighted:YES];
    
    //adding search bar and button to container view
    [buttonContainer addSubview:filterButton];
    [buttonContainer addSubview:self.searchBar];
    //setting sizes
    [self.searchBar sizeToFit];
    [filterButton sizeToFit];
    [filterButton setFrame:CGRectMake(5, self.searchBar.frame.size.height/6, 32, 32)];
    [self.searchBar setFrame:CGRectMake(filterButton.frame.size.width + 5, 0, self.searchBar.frame.size.width -                                     (filterButton.frame.size.width + 5), self.searchBar.frame.size.height)];
    [buttonContainer setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.searchBar.frame.size.height)];
    self.tableView.tableHeaderView = buttonContainer;
    [self.sectionsTableView setFrame:CGRectMake(0, 120, 120, 250)];
    
    //fetching sections
    [Section fetchSections:^(NSArray * _Nonnull sections, NSError * _Nonnull error) {
        if(error) {
            NSLog(@"error fetching sections: %@", error.localizedDescription);
        } else {
            self.sections = sections;
            [self.sectionsTableView reloadData];
            self.selectedSections = [[NSMutableArray alloc] init];
            for (int i = 0; i < sections.count; i++) {
                [self.selectedSections addObject:@"empty"];
            }
        }
    }];
    
    //adding refresh and fetching posts
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refresh atIndex:0];
    [self fetchPosts];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navItem.title = @"Feed";
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navItem.leftBarButtonItem = logoutButton;
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    self.navItem.rightBarButtonItem = shareButton;
}

#pragma mark - Infinite Scrolling

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isLoadingMoreData) {
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isLoadingMoreData = YES;
            [self fetchPosts];
        }
    }
}

- (void)fetchPosts {
    [self.activityIndicator startAnimating];
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 10;
    BOOL isRefreshing = [self.refresh isRefreshing];
    if(!isRefreshing)
        query.skip = self.posts.count;
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"location"];
    if(self.countSelectedSections > 0) {
        [query whereKey:@"section" containedIn:self.selectedSections];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if(!error) {
            if(isRefreshing){
                self.posts = posts;
            } else {
                self.posts = [self.posts arrayByAddingObjectsFromArray:posts];
            }
            self.filteredPosts = self.posts;
            [self.tableView reloadData];
            if(self.searchBar.text != 0) {
                [self searchBar:self.searchBar textDidChange:self.searchBar.text];
            }
        } else {
            [UIAlertController sendError:error.localizedDescription onView:self];
        }
        [self.activityIndicator stopAnimating];
        self.isLoadingMoreData = false;
        [self.refresh endRefreshing];
    }];
}

#pragma mark - Table View Data Source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if([tableView isEqual:self.tableView]) {
        PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
        [cell setPost:self.filteredPosts[indexPath.row]];
        return cell;
    } else {
        SectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionCell"];
        [cell setCell:self.sections[indexPath.row]];
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([tableView isEqual:self.tableView])? self.filteredPosts.count: self.sections.count;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([tableView isEqual:self.tableView]) {
        [self performSegueWithIdentifier:@"detailSegue" sender:self.filteredPosts[indexPath.row]];
    } else {
        if([self.selectedSections[indexPath.row] isEqual:@"empty"]) {
            self.selectedSections[indexPath.row] = self.sections[indexPath.row];
            self.countSelectedSections++;
        } else {
            self.selectedSections[indexPath.row]  = @"empty";
            self.countSelectedSections--;
        }
        [self.refresh beginRefreshing];
        [self fetchPosts];
        NSLog(@"filters: %@", self.selectedSections);
    }
}

#pragma mark - Toggle Section Table Hidden

- (void)changeTableVisibility {
    if([self.sectionsTableView isHidden]) {
        [self.sectionsTableView setHidden:NO];
    } else {
        [self.sectionsTableView setHidden:YES];
    }
}

#pragma mark - Search Bar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        self.filteredPosts = [self.posts filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredPosts = self.posts;
    }
    [self.tableView reloadData];
}
    
#pragma mark - Logout

- (void)logout {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginView = [storyBoard instantiateViewControllerWithIdentifier:@"loginView"];
    sceneDelegate.window.rootViewController = loginView;
    
    if([FBSDKAccessToken currentAccessToken]) {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
    }
    [User logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        //needs to be open so that current user sets to nil
    }];
}

- (void)share {
    [self performSegueWithIdentifier:@"composePostSegue" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"detailSegue"]){
        DetailPostViewController *detailPostView = [segue destinationViewController];
        detailPostView.post = sender;
    }
}

@end
