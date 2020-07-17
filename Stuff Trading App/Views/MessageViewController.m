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

@interface MessageViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *messages;
@property (weak, nonatomic) IBOutlet UITextField *messageText;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.messageText.delegate = self;
    
    self.title = self.chat.userA.username;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fetchMessages) userInfo:nil repeats:YES];
    [self fetchMessages];
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
        }
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
    [Message createMessage:self.messageText.text inChat:self.chat];
}

#pragma mark - Keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
