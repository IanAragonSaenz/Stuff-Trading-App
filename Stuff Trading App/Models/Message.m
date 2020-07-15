//
//  Message.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 15/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "Message.h"

@implementation Message

@dynamic chatID;
@dynamic userId;
@dynamic message;
@dynamic chat;
@dynamic sender;

+ (nonnull NSString *)parseClassName {
    return @"Message";
}

+ (void)createMessage:(NSString *)message{
    Message *newMessage = [Message new];
    newMessage.message = message;
    newMessage.sender = [User currentUser];
    [newMessage saveInBackground];
}

@end
