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

+ (User *)user{
    return (User *)[PFUser user];
}

+ (void)setProfilePic:(UIImage *)image{
    User *user = [User currentUser];
    user.image = [self getPFFileFromImage:image];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"profile pic changed");
        } else {
            NSLog(@"pfile pic failed: %@", error.localizedDescription);
        }
    }];
}

+ (PFFileObject *)getPFFileFromImage:(UIImage *_Nullable)image{
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
