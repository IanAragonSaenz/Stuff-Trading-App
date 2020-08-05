//
//  Message.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 15/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "Message.h"

@implementation Message

@dynamic messageID;
@dynamic userId;
@dynamic message;
@dynamic image;
@dynamic sender;
@dynamic chat;

+ (nonnull NSString *)parseClassName {
    return @"Message";
}

#pragma mark - Create Message

+ (void)createMessage:(NSString *)message withImage:(UIImage *_Nullable)image inChat:(Chat *)chat {
    Message *newMessage = [Message new];
    newMessage.sender = [User currentUser];
    newMessage.message = message;
    newMessage.chat = chat;
    if(image) {
        newMessage.image = [self getPFFileFromImage:image];
    }
    [newMessage saveInBackground];
    chat.latestMessage = message;
    [chat saveInBackground];
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
