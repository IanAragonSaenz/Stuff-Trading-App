//
//  ChatViewController.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 16/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatCell.h"
#import <Parse/Parse.h>
#import "User.h"
#import "MessageViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UIImage+Utils.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSArray *chats;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    
    [self.activityIndicator startAnimating];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fetchChats) userInfo:nil repeats:YES];
}

#pragma mark - Fetch Chats

- (void)fetchChats {
    User *user = [User currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userA = %@ OR userB = %@", user, user];
    PFQuery *query = [PFQuery queryWithClassName:@"Chat" predicate:predicate];
    [query includeKeys:@[@"userA", @"userB"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable chats, NSError * _Nullable error) {
        if(error) {
            NSLog(@"error loading chats: %@", error.localizedDescription);
        } else {
            self.chats = chats;
            [self.tableView reloadData];
        }
        [self.activityIndicator stopAnimating];
    }];
}

#pragma mark - Table View Data Source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    [cell setCell:self.chats[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chats.count;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"messageSegue" sender:self.chats[indexPath.row]];
}

#pragma mark - Empty Table Data Source

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage iconChat];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"There are no chats to show";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Message someone or get someone to message you for a chat to show";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"messageSegue"]) {
        MessageViewController *messageView = [segue destinationViewController];
        messageView.chat = sender;
    }
}


@end
