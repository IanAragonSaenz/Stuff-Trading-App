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

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *chats;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fetchChats) userInfo:nil repeats:YES];
}

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
