//
//  SettingsViewController.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 24/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIAlertController+Utils.h"
#import "SceneDelegate.h"
#import "UserViewController.h"

@interface SettingsViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userPic;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    User *user = [User currentUser];
    [user.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error getting user picture data: %@", error.localizedDescription);
        } else {
            self.userPic.image = [UIImage imageWithData:data];
        }
    }];
    
    
}



#pragma mark - Set Photo

- (IBAction)setPicture:(id)sender {
    [User setProfilePic:self.userPic.image];
}

- (IBAction)onDone:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBar = [storyBoard instantiateViewControllerWithIdentifier:@"tabBar"];
    tabBar.selectedIndex = 1;
    sceneDelegate.window.rootViewController = tabBar;
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
