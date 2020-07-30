//
//  MessageViewController.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 16/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "Message.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UIImage+Utils.h"

@interface MessageViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *messages;
@property (weak, nonatomic) IBOutlet UITextField *messageText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.messageText.delegate = self;
    
    [self.navigationController.toolbar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    self.title = self.chat.userA.username;
    [self.activityIndicator startAnimating];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fetchMessages) userInfo:nil repeats:YES];
    [self fetchMessages];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.toolbar setHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark - Fetch Messages

- (void)fetchMessages {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query includeKey:@"sender"];
    [query whereKey:@"chat" equalTo:self.chat];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable messages, NSError * _Nullable error) {
        if(error){
            NSLog(@"error loading messages: %@", error.localizedDescription);
        } else if(messages){
            self.messages = messages;
            [self.tableView reloadData];
            NSUInteger rows = [self tableView:self.tableView numberOfRowsInSection:0];
            NSUInteger items = (rows > 0)? rows-1: 0;
            NSIndexPath *index = [NSIndexPath indexPathForItem:items inSection:0];
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        [self.activityIndicator stopAnimating];
    }];
}

#pragma mark - Table View Data Source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MessageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    [cell setCell:self.messages[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

#pragma mark - Create Message

- (IBAction)sendMessage:(id)sender {
    if([self.messageText.text isEqualToString:@""]) {
        [Message createMessage:self.messageText.text inChat:self.chat];
        self.messageText.text = @"";
    }
}

#pragma mark - Keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Empty Table Data Source

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage iconMessage];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"There are no messages to show";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Be the first one to send a message!";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
