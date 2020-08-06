//
//  MessageViewController.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 16/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "MessageViewController.h"
#import "Message.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UIAlertController+Utils.h"
#import "UIImage+Utils.h"
#import "Constants.h"
#import <ChameleonFramework/Chameleon.h>
@import ParseLiveQuery;

@interface MessageViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *messages;
@property (weak, nonatomic) IBOutlet UITextView *messageText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIImage *messageImage;
@property (strong, nonatomic) PFLiveQueryClient *client;
@property (strong, nonatomic) PFLiveQuerySubscription *subscription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageTextHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *messageTextView;


@end

static const CGFloat kMessageTextOriginalHeight = 33.0;

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.client = [[PFLiveQueryClient alloc] initWithServer:[NSString stringWithFormat:@"wss://%@.back4app.io", kSubdomain] applicationId:kAppId clientKey:kClientId];
    self.messageText.delegate = self;
    self.messageImage = nil;
    self.messages = [NSArray array];
    [self.messageTextView setBackgroundColor:[UIColor flatWhiteColor]];
    
    if([self.chat.userA.username isEqual:[User currentUser].username]) {
        self.title = self.chat.userB.name;
    } else {
        self.title = self.chat.userA.name;
    }
    [self.navigationController.toolbar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    [self.activityIndicator startAnimating];
    
    [self fetchMessages];
    [self subscribeToMessages];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.toolbar setHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma mark - Fetch Messages

- (void)fetchMessages {
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([Message class])];
    [query includeKey:kSenderKey];
    [query whereKey:kChatKey equalTo:self.chat];
    [query orderByAscending:kCreatedAtKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable messages, NSError * _Nullable error) {
        if(error){
            NSLog(@"error loading messages: %@", error.localizedDescription);
        } else if(messages){
            self.messages = messages;
            [self.tableView reloadData];
            [self scrollToBottom];
        }
        [self.activityIndicator stopAnimating];
    }];
}

- (void)subscribeToMessages {
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([Message class])];
    [query includeKey:kSenderKey];
    [query whereKey:kChatKey equalTo:self.chat];
    [query orderByAscending:kCreatedAtKey];
    self.subscription = [self.client subscribeToQuery:query];
    self.subscription = [self.subscription addCreateHandler:^(PFQuery<PFObject *> * _Nonnull queried, PFObject * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Message *mess = (Message *)message;
            [mess.sender fetchIfNeeded];
            self.messages = [self.messages arrayByAddingObject:mess];
            [self.tableView reloadData];
            [self scrollToBottom];
        });
    }];
}

- (void)scrollToBottom {
    NSUInteger rows = [self tableView:self.tableView numberOfRowsInSection:0];
    NSUInteger items = (rows > 0)? rows-1: 0;
    if(items) {
        NSIndexPath *index = [NSIndexPath indexPathForItem:items inSection:0];
        [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
#pragma mark - Table View Data Source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.row];
    MessageCell *cell;
    if(message.image) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"messagePhotoCell"];
        cell.handleImageZoomInDelegate = self;
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
        self.messageTextHeightConstraint.constant = [self.messageText sizeThatFits:CGSizeMake(self.messageText.frame.size.width, kMessageTextOriginalHeight)].height;
        self.messageImage = nil;
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
            [self presentViewController:imagePC animated:YES completion:nil];
        } else if(finished == 2) {
            imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePC animated:YES completion:nil];
        } else if(finished == 0) {
            UIAlertController *errorAlert = [UIAlertController sendError:error];
            [self presentViewController:errorAlert animated:YES completion:nil];
            return;
        }
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
    [self.messageText resignFirstResponder];
    [self textViewDidChange:self.messageText];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.messageTextHeightConstraint.constant = [self.messageText sizeThatFits:CGSizeMake(self.messageText.frame.size.width, CGFLOAT_MAX)].height;
}

#pragma mark - HandleImageZoomIn Delegate

- (void)zoomIn:(UIImage *)image {
    if([self.view viewWithTag:100]) {
        [self deleteImageView];
    }
    UIImageView *zoomImage = [[UIImageView alloc] initWithImage:image];
    zoomImage.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.width);
    zoomImage.backgroundColor = [UIColor blackColor];
    zoomImage.tag = 100;
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [zoomImage addGestureRecognizer:pinch];
    
    UITapGestureRecognizer *cancelZoom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImageView)];
    [zoomImage addGestureRecognizer:cancelZoom];
    [zoomImage setUserInteractionEnabled:YES];
    
    [self.view addSubview:zoomImage];
    zoomImage.translatesAutoresizingMaskIntoConstraints = false;
    [zoomImage.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [zoomImage.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [zoomImage.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [zoomImage.heightAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.view layoutIfNeeded];
    
    UIView *dimView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    dimView.backgroundColor = [UIColor colorWithWhite:.1f alpha:.8f];
    dimView.tag = 101;
    [self.view addSubview:dimView];
    [self.view bringSubviewToFront:zoomImage];
}

- (void)pinchAction:(UIPinchGestureRecognizer *)pinch {
    UIImageView *zoomImage = [self.view viewWithTag:100];
    if(pinch.state == UIGestureRecognizerStateBegan || pinch.state == UIGestureRecognizerStateChanged) {
        UIView *view = pinch.view;
        CGPoint center = [pinch locationInView:view];
        center.x -= CGRectGetMidX(view.bounds);
        center.y -= CGRectGetMidY(view.bounds);
        
        CGAffineTransform transform = view.transform;
        transform = CGAffineTransformTranslate(transform, center.x, center.y);
        transform = CGAffineTransformScale(transform, pinch.scale, pinch.scale);
        transform = CGAffineTransformTranslate(transform, -center.x, -center.y);
        
        CGFloat currentScale = zoomImage.frame.size.width / zoomImage.bounds.size.width;
        CGFloat scale = currentScale * pinch.scale;
        
        if(scale < 1) {
            scale = 1;
            transform = CGAffineTransformMakeScale(scale, scale);
            zoomImage.transform = transform;
        } else {
            view.transform = transform;
        }
        pinch.scale = 1;
    } else if(pinch.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.3 animations:^{
            zoomImage.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)deleteImageView {
    UIImageView *zoomImage = [self.view viewWithTag:100];
    [zoomImage removeFromSuperview];
    UIView *dimView = [self.view viewWithTag:101];
    [dimView removeFromSuperview];
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
