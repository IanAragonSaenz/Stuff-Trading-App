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

@interface RegisterViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextView *userDescription;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto)];
    [self.userImage addGestureRecognizer:tapPhoto];
    [self.userImage setUserInteractionEnabled:YES];
}

#pragma mark - Taking Picture

- (void)takePhoto{
    UIImagePickerController *imagePC = [UIImagePickerController new];
    imagePC.delegate = self;
    imagePC.allowsEditing = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose Media" message:@"Choose camera vs photo library" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            [self sendError:@"Camera source not found"];
            return;
        }
        [self presentViewController:imagePC animated:YES completion:nil];
    }];
    [alert addAction:camera];
    
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else {
            [self sendError:@"Photo library source not found"];
            return;
        }
        [self presentViewController:imagePC animated:YES completion:nil];
    }];
    [alert addAction:photoLibrary];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    self.userImage.image = [self resizeImage:originalImage withSize:(CGSizeMake(325, 325))];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Sizing Image

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size{
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
            [self sendError:error.localizedDescription];
        } else {
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

#pragma mark - Error && Checkers

- (BOOL)isEmpty:(NSString *)username password:(NSString *)password{
    if([username isEqualToString:@""]){
        [self sendError:@"Username is empty"];
        return YES;
    } else if([password isEqualToString:@""]){
        [self sendError:@"Password is empty"];
        return YES;
    }
    return NO;
}

- (void)sendError:(NSString *)error{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
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