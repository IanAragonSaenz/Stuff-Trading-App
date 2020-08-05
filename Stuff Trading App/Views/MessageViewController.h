//
//  MessageViewController.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 16/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chat.h"
#import "MessageCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageViewController : UIViewController <HandleImageZoomIn>

@property (strong, nonatomic) Chat *chat;

@end

NS_ASSUME_NONNULL_END
