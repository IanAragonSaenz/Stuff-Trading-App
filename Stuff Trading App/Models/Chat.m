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
@dynamic userA;
@dynamic userB;
@dynamic latestMessage;

+ (nonnull NSString *)parseClassName {
    return @"Chat";
}

#pragma mark - Create Chat

+ (void)createChatWithUser:(User *)user withCompletion:(PFBooleanResultBlock)completion {
    User *userA = [User currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userA = %@ AND userB = %@) OR (userA = %@ AND userB = %@)", userA, user, user, userA];
    PFQuery *query = [PFQuery queryWithClassName:@"Chat" predicate:predicate];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if(error){
            completion(NO, error);
        } else {
            if(number == 0){
                Chat *chat = [Chat new];
                chat.userA = userA;
                chat.userB = user;
                [chat saveInBackground];
                completion(YES, nil);
            }
        }
    }];
}

@end
