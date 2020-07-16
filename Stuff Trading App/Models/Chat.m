//
//  Chat.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 16/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "Chat.h"

@implementation Chat

@dynamic chatID;
@dynamic userId;
@dynamic messages;
@dynamic userA;
@dynamic userB;


+ (nonnull NSString *)parseClassName {
    return @"Chat";
}

+ (void)createChatWithUser:(User *)user{
    User *userA = [User currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userA = %@ AND userB = %@) OR (userA = %@ AND userB = %@)", userA, user, user, userA];
    PFQuery *query = [PFQuery queryWithClassName:@"Chat" predicate:predicate];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error when finding chat: %@", error.localizedDescription);
        } else {
            if(number == 0){
                Chat *chat = [Chat new];
                chat.userA = userA;
                chat.userB = user;
                chat.messages = [NSArray array];
                [chat saveInBackground];
            }
        }
    }];
}

@end