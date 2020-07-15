//
//  Chat.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 15/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "Chat.h"

@implementation Chat

@dynamic chatID;
@dynamic userId;
@dynamic userA;
@dynamic userB;

+ (nonnull NSString *)parseClassName {
    return @"Chat";
}

+ (void)createChat:(User *)userB{
    User *userA = [User currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userA = %@ AND userB = %@) OR (userA = %@ AND userB = %@)", userA, userB, userB, userA];
    PFQuery *query = [PFQuery queryWithClassName:@"Chat" predicate:predicate];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error when trying to check for chat: %@", error.localizedDescription);
        } else if(number == 0){
            Chat *chat = [Chat new];
            chat.userA = userA;
            chat.userB = userB;
            [chat saveInBackground];
            NSLog(@" number: %d", number);
        }
    }];
}

@end


