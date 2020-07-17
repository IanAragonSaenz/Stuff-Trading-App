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

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) UIRefreshControl *refresh;
@property (assign, nonatomic) BOOL isLoadingMoreData;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.posts = [NSArray array];
    
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refresh atIndex:0];
    [self fetchPosts];
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

- (void)fetchPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    query.limit = 10;
    BOOL isRefreshing = [self.refresh isRefreshing];
    if(!isRefreshing)
        query.skip = self.posts.count;
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if(!error) {
            if(isRefreshing)
                self.posts = posts;
            else
                self.posts = [self.posts arrayByAddingObjectsFromArray:posts];
            [self.tableView reloadData];
        } else {
            NSLog(@"error getting posts: %@", error.localizedDescription);
        }
    }];
    self.isLoadingMoreData = false;
    [self.refresh endRefreshing];
}

#pragma mark - Table View Data Source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    [cell setPost:self.posts[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detailSegue" sender:self.posts[indexPath.row]];
}

#pragma mark - Error

- (void)sendError:(NSString *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}
    
#pragma mark - Logout

- (IBAction)logout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginView = [storyBoard instantiateViewControllerWithIdentifier:@"loginView"];
    sceneDelegate.window.rootViewController = loginView;
    
    [User logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        //needs to be open so that current user sets to nil
    }];
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
