//
//  Chat.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 15/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN
@class User;
@interface Chat : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *chatID;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) User *userA;
@property (strong, nonatomic) User *userB;

+ (void)createChat:(User *)userB;

@end

NS_ASSUME_NONNULL_END
