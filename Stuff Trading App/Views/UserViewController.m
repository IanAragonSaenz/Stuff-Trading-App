//
//  UserViewController.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 14/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "UserViewController.h"
#import "ProfilePostCollectionCell.h"
#import "DetailPostViewController.h"
#import "Chat.h"
#import "MessageViewController.h"
#import "UIAlertController+Utils.h"
#import "UIImage+Utils.h"
#import "Constants.h"

@interface UserViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDescription;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIImageView *takePhotoImage;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //sets poster spacing
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    CGFloat posters = 2.0;
    CGFloat itemWidth = (self.view.frame.size.width - layout.minimumInteritemSpacing * (layout.minimumLineSpacing)) / posters;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    //sets users info
    if(!self.user){
        self.user = [User currentUser];
    }
    if([self.user.username isEqual:[User currentUser].username]){
        self.messageButton.userInteractionEnabled = NO;
        self.messageButton.hidden = YES;
        
        //sets taking picture in circle and adds tap gesture to it
        self.takePhotoImage.layer.cornerRadius = self.takePhotoImage.frame.size.width / 2;
        UITapGestureRecognizer *tapPic = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto)];
        [self.takePhotoImage addGestureRecognizer:tapPic];
        [self.takePhotoImage setUserInteractionEnabled:YES];
    } else {
        [self.takePhotoImage setHidden:YES];
        [self.takePhotoImage setUserInteractionEnabled:NO];
    }
    
    self.title = self.user.name;
    self.usernameLabel.text = self.user.name;
    self.userDescription.text = self.user.userDescription;
    [self.user.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(!error)
            self.userImage.image = [UIImage imageWithData:data];
    }];
    self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2;
    
    [self fetchposts];
}

#pragma mark - Fetching of Posts

- (void)fetchposts {
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([Post class])];
    [query includeKey:kAuthorKey];
    [query includeKey:kLocationKey];
    [query includeKey:kSectionKey];
    [query whereKey:kAuthorKey equalTo:self.user];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if(!error) {
            self.posts = posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"Error when loading current user posts: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - Collection View Data Source

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProfilePostCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ProfilePostCell" forIndexPath:indexPath];
    [cell setCell:self.posts[indexPath.item]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailPostViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"detailPostViewController"];
    detailView.post = self.posts[indexPath.item];
    [self.navigationController pushViewController:detailView animated:YES];
}

#pragma mark - Message

- (IBAction)messageUser:(id)sender {
    [Chat createChatWithUser:self.user withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            User *userA = [User currentUser];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userA = %@ AND userB = %@) OR (userA = %@ AND userB = %@)", userA, self.user, self.user, userA];
            PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([Chat class]) predicate:predicate];
            [query includeKey:kUserAKey];
            [query includeKey:kUserBKey];
            query.limit = 1;
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable chats, NSError * _Nullable error) {
                if(error) {
                    NSLog(@"Error loading chat: %@", error.localizedDescription);
                } else if(chats.count > 0) {
                    Chat *chat = chats[0];
                    [self performSegueWithIdentifier:@"messageSegue" sender:chat];
                } else {
                    [self messageUser:nil];
                }
            }];
        } else {
            NSLog(@"Error when finding chat: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - Take Photo

- (void)takePhoto {
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
    self.userImage.image = [UIImage resizeImage:originalImage withSize:CGSizeMake(325, 325)];
    [User setProfilePic:self.userImage.image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"messageSegue"]){
        MessageViewController *messageView = [segue destinationViewController];
        messageView.chat = sender;
    }
}


@end
