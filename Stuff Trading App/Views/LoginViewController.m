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

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Login

- (IBAction)login:(id)sender {
    if([self isEmpty:self.usernameText.text password:self.passwordText.text])
        return;
    
    [User logInWithUsernameInBackground:self.usernameText.text password:self.passwordText.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if(error){
            [self sendError:error.localizedDescription];
        } else {
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

#pragma mark - SignUp

- (IBAction)signUp:(id)sender {
    if([self isEmpty:self.usernameText.text password:self.passwordText.text])
        return;
    
    User *user = [User user];
    user.username = self.usernameText.text;
    user.password = self.passwordText.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            [self sendError:error.localizedDescription];
        } else {
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

#pragma mark - Empty Checker

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

#pragma mark - Error Alert

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
