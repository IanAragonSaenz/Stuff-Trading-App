//
//  User.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 13/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <PFFacebookUtils.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser <PFSubclassing>

@property (strong, nonatomic) PFFileObject *image;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *userDescription;

+ (void)signUpUser:(UIImage *)image username:(NSString *)username password:(NSString *)password description:(NSString *)description withCompletion:(PFBooleanResultBlock _Nullable)completion;
+ (void)setProfilePic:(UIImage *)image;
+ (void)linkUser;
+ (void)setFacebookInfo:(PFBooleanResultBlock)completion;

@end

NS_ASSUME_NONNULL_END
