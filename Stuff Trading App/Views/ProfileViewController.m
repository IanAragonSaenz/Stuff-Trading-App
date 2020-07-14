//
//  ProfileViewController.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 14/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "ProfilePostCollectionCell.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userDescription;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    User *user = [User currentUser];
    self.username.text = user.username;
    self.userDescription.text = user.userDescription;
    [user.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(!error)
            self.profileImage.image = [UIImage imageWithData:data];
    }];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self fetchposts];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    
    CGFloat posters = 2.2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (layout.minimumLineSpacing)) / posters;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)fetchposts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:[User currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if(!error){
            self.posts = posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"Error when loading current user posts: %@", error.localizedDescription);
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProfilePostCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ProfilePostCell" forIndexPath:indexPath];
    [cell setCell:self.posts[indexPath.item]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
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
