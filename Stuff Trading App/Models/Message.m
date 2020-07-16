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
@dynamic sender;

+ (nonnull NSString *)parseClassName {
    return @"Message";
}

+ (void)createMessage:(NSString *)message inChat:(Chat *)chat{
    Message *newMessage = [Message new];
    newMessage.sender = [User currentUser];
    [newMessage saveInBackground];
    [chat.messages arrayByAddingObject:newMessage];
    [chat saveInBackground];
}

@end
