//
//  User.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 13/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "User.h"
#import "UIImage+Utils.h"

@implementation User

@dynamic image;
@dynamic userDescription;

+ (User *)user {
    return (User *)[PFUser user];
}

#pragma mark - Sign Up User

+ (void)signUpUser:(UIImage *)image username:(NSString *)username password:(NSString *)password description:(NSString *)description withCompletion:(PFBooleanResultBlock _Nullable)completion {
    User *user = [User user];
    user.username = username;
    user.password = password;
    user.image = [self getPFFileFromImage:image];
    user.userDescription = description;
    
    [user signUpInBackgroundWithBlock:completion];
}

#pragma mark - Change Values in User

+ (void)setProfilePic:(UIImage *)image {
    User *user = [User currentUser];
    user.image = [self getPFFileFromImage:image];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"profile pic changed");
        } else {
            NSLog(@"pfile pic failed: %@", error.localizedDescription);
        }
    }];
}

+ (void)setProfileDescription:(NSString *)desc {
    User *user = [User currentUser];
    user.userDescription = desc;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"profile pic changed");
        } else {
            NSLog(@"pfile pic failed: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - Facebook

+ (void)linkUser {
    [PFFacebookUtils linkUserInBackground:[User currentUser] withReadPermissions:nil block:^(BOOL succeeded, NSError *error) {
          if (succeeded) {
              NSLog(@"Woohoo, user is linked with Facebook!");
          }
    }];
}

+ (void)setFacebookInfo:(PFBooleanResultBlock)completion {
    //creates parameters for info request
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email,picture" forKey:@"fields"];

    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog(@"fetched user:%@  and Email : %@", result,result[@"email"]);
             //gets profile image
             NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", result[@"id"]]];
             NSData  *data = [NSData dataWithContentsOfURL:url];
             UIImage *image = [UIImage imageWithData:data];
             image = [UIImage resizeImage:image withSize:CGSizeMake(325, 325)];
             NSString *username = [NSString stringWithFormat:@"%@_%@", result[@"name"], result[@"id"]];
             
             User *user = [User currentUser];
             user.username = username;
             user.image = [self getPFFileFromImage:image];
             user.userDescription = @"New Facebook user";
             [user saveInBackground];
             
             [User linkUser];
             completion(YES, nil);
         } else {
             completion(NO, error);
         }
     }];
}

#pragma mark - Get PFFile from Image

+ (PFFileObject *)getPFFileFromImage:(UIImage *_Nullable)image {
   if (!image) {
       return nil;
   }
   
   NSData *imageData = UIImagePNGRepresentation(image);
   if (!imageData) {
       return nil;
   }
   
   return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
