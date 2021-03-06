//
//  RegisterViewController.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 15/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "RegisterViewController.h"
#import "User.h"
#import "SceneDelegate.h"
#import "UIAlertController+Utils.h"
#import "UIImage+Utils.h"
#import <ChameleonFramework/Chameleon.h>

@interface RegisterViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextView *userDescription;
@property (weak, nonatomic) IBOutlet UIView *scrollView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.scrollView setBackgroundColor:[UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.scrollView.frame andColors:@[[UIColor flatMintColor], [UIColor flatWhiteColor]]]];
    self.username.delegate = self;
    self.password.delegate = self;
    
    UITapGestureRecognizer *tapPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto)];
    [self.userImage addGestureRecognizer:tapPhoto];
    [self.userImage setUserInteractionEnabled:YES];
}

#pragma mark - Taking Picture

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
    self.userImage.image = [UIImage resizeImage:originalImage withSize:(CGSizeMake(325, 325))];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Cancel

- (IBAction)cancel:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginView = [storyBoard instantiateViewControllerWithIdentifier:@"loginView"];
    sceneDelegate.window.rootViewController = loginView;
}

#pragma mark - Signing Up

- (IBAction)signUp:(id)sender {
    if([self isEmpty:self.username.text password:self.password.text])
        return;
    
    [User signUpUser:self.userImage.image username:self.username.text password:self.password.text description:self.userDescription.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            UIAlertController *alert = [UIAlertController sendError:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

#pragma mark - Error && Checkers

- (BOOL)isEmpty:(NSString *)username password:(NSString *)password {
    if([username isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController sendError:@"Username is empty"];
        [self presentViewController:alert animated:YES completion:nil];
        return YES;
    } else if([password isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController sendError:@"Password is empty"];
        [self presentViewController:alert animated:YES completion:nil];
    }
    return NO;
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
