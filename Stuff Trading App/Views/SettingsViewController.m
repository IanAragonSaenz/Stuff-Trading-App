//
//  SettingsViewController.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 24/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "SettingsViewController.h"
#import "User.h"
#import "UIAlertController+Utils.h"

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
    
    UITapGestureRecognizer *tapPic = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto)];
    [self.userPic addGestureRecognizer:tapPic];
    [self.userPic setUserInteractionEnabled:YES];
}

#pragma mark - Take Photo

- (void)takePhoto {
    UIImagePickerController *imagePC = [UIImagePickerController new];
    imagePC.delegate = self;
    imagePC.allowsEditing = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose Media" message:@"Choose camera vs photo library" preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePC animated:YES completion:nil];
        } else {
            [UIAlertController sendError:@"Camera source not found" onView:self];
        }
    }];
    [alert addAction:camera];
    
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePC animated:YES completion:nil];
        } else {
            [UIAlertController sendError:@"Photo library source not found" onView:self];
        }
    }];
    [alert addAction:photoLibrary];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    self.userPic.image = [self resizeImage:originalImage withSize:CGSizeMake(325, 325)];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Sizing Image

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Set Photo

- (IBAction)setPicture:(id)sender {
    [User setProfilePic:self.userPic.image];
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
