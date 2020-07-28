//
//  User.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 13/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "User.h"

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
