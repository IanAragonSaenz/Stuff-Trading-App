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

@interface ComposePostViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextView *title;
@property (weak, nonatomic) IBOutlet UITextView *desc;

@end

@implementation ComposePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Buttons

- (IBAction)post:(id)sender {
    [Post postTradeImage:self.postImage.image withTitle:self.title.text withDescription:self.desc.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
