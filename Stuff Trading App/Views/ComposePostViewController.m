//
//  ComposePostViewController.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 13/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "ComposePostViewController.h"
#import "SceneDelegate.h"
#import "Post.h"
#import <Parse/Parse.h>

@interface ComposePostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextView *titleText;
@property (weak, nonatomic) IBOutlet UITextView *desc;

@end

@implementation ComposePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto)];
    [self.postImage addGestureRecognizer:tapPhoto];
    [self.postImage setUserInteractionEnabled:YES];
    
    self.titleText.delegate = self;
    self.desc.delegate = self;
    
    self.titleText.text = @"Type your title here...";
    self.titleText.textColor = UIColor.lightGrayColor;
    self.desc.text = @"Type your description here...";
    self.desc.textColor = UIColor.lightGrayColor;
}

#pragma mark - Photo

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
            [self sendError:@"Camera source not found"];
            return;
        }
        [self presentViewController:imagePC animated:YES completion:nil];
    }];
    [alert addAction:photoLibrary];
    
    [self presentViewController:imagePC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    self.postImage.image = [self resizeImage:originalImage withSize:CGSizeMake(325, 325)];
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

#pragma mark - Buttons

- (IBAction)post:(id)sender {
    [Post postTradeImage:self.postImage.image withTitle:self.titleText.text withDescription:self.desc.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"Post succeded");
        } else {
            NSLog(@"post failed: %@", error.localizedDescription);
        }
    }];
    [self cancel:nil];
}

- (IBAction)cancel:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *login = [storyBoard instantiateViewControllerWithIdentifier:@"tabBar"];
    sceneDelegate.window.rootViewController = login;
}

#pragma mark - Buttons

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if(textView.textColor == UIColor.lightGrayColor){
        textView.text = nil;
        textView.textColor = UIColor.blackColor;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if([self.titleText.text isEqualToString:@""]){
        self.titleText.text = @"Type your title here...";
        self.titleText.textColor = UIColor.lightGrayColor;
    }
    if([self.desc.text isEqualToString:@""]){
        self.desc.text = @"Type your description here...";
        self.desc.textColor = UIColor.lightGrayColor;
    }
}

#pragma mark - Error

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
