//
//  Message.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 15/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Chat.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *chatID;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) Chat *chat;
@property (strong, nonatomic) User *sender;

@end

NS_ASSUME_NONNULL_END
