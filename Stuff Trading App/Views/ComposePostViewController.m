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
#import "UIAlertController+Utils.h"

@interface ComposePostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextView *titleText;
@property (weak, nonatomic) IBOutlet UITextView *desc;
@property (strong, nonatomic) MKPlacemark *location;
@property (weak, nonatomic) IBOutlet UILabel *locationName;
@property (weak, nonatomic) IBOutlet UILabel *locationSubtitle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *postSection;
@property (strong, nonatomic) NSArray *sections;

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
    
    [Section fetchSections:^(NSArray * _Nonnull sections, NSError * _Nonnull error) {
        if(error) {
            NSLog(@"error fetching sections: %@", error.localizedDescription);
        } else {
            self.sections = sections;
            [self.postSection removeAllSegments];
            for(int i = 0; i < self.sections.count; i++) {
                Section *section = self.sections[i];
                [self.postSection insertSegmentWithTitle:section.name atIndex:i animated:NO];
            }
            [self.postSection setApportionsSegmentWidthsByContent:YES];
            [self.postSection setSelectedSegmentIndex:0];
        }
    }];
}

#pragma mark - Photo

- (void)takePhoto{
    UIImagePickerController *imagePC = [UIImagePickerController new];
    imagePC.delegate = self;
    imagePC.allowsEditing = YES;
    [UIAlertController takePictureAlert:self withCompletion:^(int finished) {
        if(finished == 1) {
            imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else if(finished == 2) {
            imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else {
            return;
        }
        [self presentViewController:imagePC animated:YES completion:nil];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    self.postImage.image = [self resizeImage:originalImage withSize:CGSizeMake(325, 325)];
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

#pragma mark - Buttons

- (IBAction)post:(id)sender {
    [Post postTradeImage:self.postImage.image withTitle:self.titleText.text withDescription:self.desc.text  withLocation:self.location withSection:self.sections[self.postSection.selectedSegmentIndex] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"Post succeded");
        } else {
            [UIAlertController sendError:error.localizedDescription onView:self];
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

#pragma mark - Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if(textView.textColor == UIColor.lightGrayColor){
        textView.text = nil;
        textView.textColor = UIColor.blackColor;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if([self.titleText.text isEqualToString:@""]) {
        self.titleText.text = @"Type your title here...";
        self.titleText.textColor = UIColor.lightGrayColor;
    }
    if([self.desc.text isEqualToString:@""]) {
        self.desc.text = @"Type your description here...";
        self.desc.textColor = UIColor.lightGrayColor;
    }
}

- (IBAction)locationButton:(id)sender {
    [self performSegueWithIdentifier:@"mapSegue" sender:nil];
}

#pragma mark - HandlePin Delegate

- (void)setLocation:(MKPlacemark *)placemark {
    _location = placemark;
    if(placemark.name != nil) {
        self.locationName.text = placemark.name;
    }
    if(placemark.thoroughfare != nil) {
        self.locationSubtitle.text = placemark.thoroughfare;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    MapViewController *mapView = [segue destinationViewController];
    mapView.handlePin = self;
}


@end
