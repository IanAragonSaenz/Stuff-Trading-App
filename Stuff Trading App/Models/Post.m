//
//  Post.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 13/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic image;
@dynamic title;
@dynamic desc;
@dynamic likeCount;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void)postTradeImage:(UIImage *_Nullable)image withTitle:(NSString *_Nullable)title withDescription:(NSString *_Nullable)description withCompletion:(PFBooleanResultBlock _Nullable)completion {
    Post *post = [Post new];
    post.author = [User currentUser];
    post.image = [self getPFFileFromImage:image];
    post.title = title;
    post.desc = description;
    post.likeCount = @(0);
    [post saveInBackgroundWithBlock: completion];
}
                   
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
