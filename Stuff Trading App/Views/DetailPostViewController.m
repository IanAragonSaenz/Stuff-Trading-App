//
//  DetailPostViewController.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 14/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "DetailPostViewController.h"
#import "UserViewController.h"

@interface DetailPostViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDescription;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;

@end

@implementation DetailPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.username.text = self.post.author.username;
    self.titleLabel.text = self.post.title;
    self.postDescription.text = self.post.desc;
    [self.post.author.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(!error)
            self.userImage.image = [UIImage imageWithData:data];
    }];
    [self.post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(!error)
            self.postImage.image = [UIImage imageWithData:data];
    }];
    
    UITapGestureRecognizer *tapUser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(segueUser)];
    [self.userImage addGestureRecognizer:tapUser];
    [self.userImage setUserInteractionEnabled:YES];
}

- (void)segueUser{
    [self performSegueWithIdentifier:@"userSegue" sender:self.post.author];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"userSegue"]) {
         UserViewController *userView = [segue destinationViewController];
         userView.user = sender;
     }
}


@end
