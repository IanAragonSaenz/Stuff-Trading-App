//
//  Post.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 13/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *postID;
@property (strong, nonatomic) NSString *userID;
@property (nonatomic, strong) User *author;
@property (strong, nonatomic) PFFileObject *image;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSNumber *likeCount;

+ (void)postTradeImage:(UIImage *_Nullable)image withTitle:(NSString *_Nullable)title withDescription:(NSString *_Nullable)description withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
