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
#import "UIScrollView+EmptyDataSet.h"
#import "UIImage+Utils.h"
#import "Constants.h"

static const CGFloat kSectionTableViewWidthAnchor = 170.0;
static const CGFloat kSectionTableViewheightAnchor = 220.0;
static const CGFloat kSortButtonHeight = 20;

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *sectionsTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) UIRefreshControl *refresh;
@property (assign, nonatomic) BOOL isLoadingMoreData;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSMutableArray *selectedSections;
@property (assign, nonatomic) int countSelectedSections;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (assign, nonatomic) BOOL sectionRefresh;
@property (assign, nonatomic) BOOL useClosePosts;
@property (assign, nonatomic) BOOL textSearching;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.sectionsTableView.delegate = self;
    self.sectionsTableView.dataSource = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.posts = [NSArray array];
    self.countSelectedSections = 0;
    self.tableView.tableFooterView = [UIView new];
    self.sectionRefresh = NO;
    [self.sectionsTableView setHidden:YES];
    self.useClosePosts = NO;
    self.textSearching = NO;
    
    [self setHeaderView];
    [self setSectionTableViewConstraints];
    
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

#pragma mark - View Helpers

- (void)setHeaderView {
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search here...";
    [self.searchBar setShowsBookmarkButton:YES];
    [self.searchBar setImage:[UIImage iconDropdown] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    [self.searchBar sizeToFit];
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:self.searchBar];
    
    UIButton *sortButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kSortButtonHeight)];
    [sortButton setTitle:@"All Posts" forState:UIControlStateNormal];
    [sortButton setImage:[[UIImage iconDown] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    sortButton.tintColor = [UIColor blackColor];
    [sortButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sortButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [sortButton addTarget:self action:@selector(changeSort:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sortButton];
    
    sortButton.translatesAutoresizingMaskIntoConstraints = NO;
    [sortButton.topAnchor constraintEqualToAnchor:self.searchBar.bottomAnchor].active = YES;
    [sortButton.leadingAnchor constraintEqualToAnchor:headerView.leadingAnchor constant:5].active = YES;
    [self.view layoutIfNeeded];
    
    [headerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.searchBar.frame.size.height + sortButton.frame.size.height)];
    self.tableView.tableHeaderView = headerView;
}

- (void)setSectionTableViewConstraints {
    self.sectionsTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.sectionsTableView.topAnchor constraintEqualToAnchor:self.searchBar.bottomAnchor constant:0].active = YES;
    [self.sectionsTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
    [self.sectionsTableView.heightAnchor constraintEqualToConstant:kSectionTableViewheightAnchor].active = YES;
    [self.sectionsTableView.widthAnchor constraintEqualToConstant:kSectionTableViewWidthAnchor].active = YES;
    [self.view layoutIfNeeded];
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
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([Post class])];
    query.limit = 10;
    if(![self shouldSetPosts]) {
        query.skip = self.posts.count;
    }
    [query orderByDescending:kCreatedAtKey];
    [query includeKey:kAuthorKey];
    [query includeKey:kLocationKey];
    if(self.countSelectedSections > 0) {
        [query whereKey:kSectionKey containedIn:self.selectedSections];
    }
    if(self.useClosePosts) {
        PFQuery *locationQuery = [PFQuery queryWithClassName:NSStringFromClass([Location class])];
        [locationQuery whereKey:kCoordinateKey nearGeoPoint:[PFGeoPoint geoPointWithLocation:self.locationManager.location] withinKilometers:100.0];
        [query whereKey:kLocationKey matchesQuery:locationQuery];
    }
    if (self.textSearching) {
        [query whereKey:kTitleKey matchesRegex:self.searchBar.text modifiers:@"i"];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if(!error) {
            if([self shouldSetPosts]){
                self.posts = posts;
            } else {
                self.posts = [self.posts arrayByAddingObjectsFromArray:posts];
            }
            [self.tableView reloadData];
        } else {
            UIAlertController *alert = [UIAlertController sendError:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        }
        self.sectionRefresh = NO;
        [self.activityIndicator stopAnimating];
        self.isLoadingMoreData = false;
        [self.refresh endRefreshing];
    }];
}

- (BOOL)shouldSetPosts {
    if([self.refresh isRefreshing] || self.sectionRefresh || self.textSearching) {
        //if the user is refreshing or the user changed filters then replace the posts completely
        //or if the user is currently filtering throught titles
        return YES;
    } else {
        //if the user is just scrolling for more posts then add posts to array and use skip
        return NO;
    }
}

#pragma mark - Table View Data Source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if([tableView isEqual:self.tableView]) {
        PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
        [cell setPost:self.posts[indexPath.row]];
        return cell;
    } else {
        SectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionCell"];
        [cell setCell:self.sections[indexPath.row]];
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([tableView isEqual:self.tableView])? self.posts.count: self.sections.count;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([tableView isEqual:self.tableView]) {
        [self performSegueWithIdentifier:@"detailSegue" sender:self.posts
         [indexPath.row]];
    } else {
        if([self.selectedSections[indexPath.row] isEqual:@"empty"]) {
            self.selectedSections[indexPath.row] = self.sections[indexPath.row];
            self.countSelectedSections++;
        } else {
            self.selectedSections[indexPath.row]  = @"empty";
            self.countSelectedSections--;
        }
        self.sectionRefresh = YES;
        [self fetchPosts];
        NSLog(@"filters: %@", self.selectedSections);
    }
}

#pragma mark - Toggle Section Table Hidden

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    if([self.sectionsTableView isHidden]) {
        [self.sectionsTableView setHidden:NO];
    } else {
        [self.sectionsTableView setHidden:YES];
    }
}

#pragma mark - Search Bar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if(searchText.length != 0) {
        self.textSearching = YES;
    } else {
        self.textSearching = NO;
        //use section refresh just for it to correctly relaod posts and not just add to array
        self.sectionRefresh = YES;
    }
    [self performSelector:@selector(fetchPosts) withObject:nil afterDelay:0.5];
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

#pragma mark - Empty Table Data Source

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage iconBox];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"There are no posts to show";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Post something and let everyone see what you want to trade!";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};

    return [[NSAttributedString alloc] initWithString:@"Refresh" attributes:attributes];
}

#pragma mark - Empty Table Delegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    [self.refresh beginRefreshing];
    [self fetchPosts];
}

#pragma mark - Change Sorting

- (void)changeSort:(UIButton *)button {
    if(self.useClosePosts) {
        self.useClosePosts = NO;
        [button setTitle:@"All Posts" forState:UIControlStateNormal];
    } else {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestLocation];
        self.useClosePosts = YES;
        [button setTitle:@"Close Posts" forState:UIControlStateNormal];
    }
    self.sectionRefresh = YES;
    [self fetchPosts];
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager requestLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //need to be here for the delegate to work
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error with location manager: %@", error.localizedDescription);
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
