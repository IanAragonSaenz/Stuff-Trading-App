//
//  LoginViewController.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 13/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "UIAlertController+Utils.h"
#import <PFFacebookUtils.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Sign Up / Login

- (IBAction)login:(id)sender {
    if([self isEmpty:self.usernameText.text password:self.passwordText.text])
        return;
    
    [User logInWithUsernameInBackground:self.usernameText.text password:self.passwordText.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if(error) {
            [UIAlertController sendError:error.localizedDescription onView:self];
        } else {
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (IBAction)signUp:(id)sender {
    [self performSegueWithIdentifier:@"registerSegue" sender:nil];
}

#pragma mark - Check if Empty

- (BOOL)isEmpty:(NSString *)username password:(NSString *)password {
    if([username isEqualToString:@""]) {
        [UIAlertController sendError:@"Username is empty" onView:self];
        return YES;
    } else if([password isEqualToString:@""]) {
        [UIAlertController sendError:@"Password is empty" onView:self];
        return YES;
    }
    return NO;
}

#pragma mark - Facebook Login

- (IBAction)facebookLogin:(id)sender {
    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"email", @"public_profile"] block:^(PFUser *user, NSError *error) {
      if (!user) {
        NSLog(@"Uh oh. The user cancelled the Facebook login.");
      } else if (user.isNew) {
        NSLog(@"User signed up and logged in through Facebook!");
          User *user = [User user];
          [user signUpInBackgroundWithBlock:nil];
          [PFFacebookUtils linkUserInBackground:user withReadPermissions:nil block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Woohoo, user is linked with Facebook!");
                [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            }
          }];
      } else {
          NSLog(@"User logged in through Facebook!");
          [self performSegueWithIdentifier:@"loginSegue" sender:nil];
      }
    }];
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
