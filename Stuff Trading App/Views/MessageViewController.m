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
#import "UIAlertController+Utils.h"
#import "UIImage+Utils.h"

@interface MessageViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *messages;
@property (weak, nonatomic) IBOutlet UITextView *messageText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) UIImage *messageImage;

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
    self.messageImage = nil;
    
    [self.navigationController.toolbar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    self.title = self.chat.userA.username;
    [self.activityIndicator startAnimating];
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(fetchMessages) userInfo:nil repeats:YES];
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
            if(items) {
                NSIndexPath *index = [NSIndexPath indexPathForItem:items inSection:0];
                [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
        [self.activityIndicator stopAnimating];
    }];
}

#pragma mark - Table View Data Source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.row];
    MessageCell *cell;
    if(message.image) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"messagePhotoCell"];
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    }
    [cell setCell:self.messages[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

#pragma mark - Create Message

- (IBAction)sendMessage:(id)sender {
    if(![self.messageText.text isEqualToString:@""]) {
        [Message createMessage:self.messageText.text withImage:self.messageImage inChat:self.chat];
        self.messageText.text = @"";
    }
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

#pragma mark - Adding Photo

- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *imagePC = [UIImagePickerController new];
    imagePC.delegate = self;
    imagePC.allowsEditing = YES;
    UIAlertController *alert = [UIAlertController takePictureAlert:^(int finished, NSString *_Nullable error) {
        if(finished == 1) {
            imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else if(finished == 2) {
            imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else if(finished == 0) {
            UIAlertController *errorAlert = [UIAlertController sendError:error];
            [self presentViewController:errorAlert animated:YES completion:nil];
            return;
        }
        [self presentViewController:imagePC animated:YES completion:nil];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    self.messageImage = [UIImage resizeImage:originalImage withSize:CGSizeMake(325 , 325)];
    originalImage = [UIImage resizeImage:originalImage withSize:CGSizeMake(50, 50)];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = originalImage;
    NSAttributedString *attrString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [self.messageText.textStorage insertAttributedString:attrString atIndex:self.messageText.selectedRange.location];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    CGRect frame = textView.frame;
    frame.size.height = textView.contentSize.height;
    textView.frame = frame;
    /*
    frame = self.backgroundImage.frame;
    frame.size.height = textView.contentSize.height + 15;
    self.backgroundImage.frame = frame;
     */
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
