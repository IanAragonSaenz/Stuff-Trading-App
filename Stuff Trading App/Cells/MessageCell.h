//
//  MessageCell.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 16/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HandleImageZoomIn <NSObject>

- (void)zoomIn:(UIImage *)image;

@end

@interface MessageCell : UITableViewCell

@property (strong, nonatomic) id<HandleImageZoomIn> handleImageZoomInDelegate;
- (void)setCell:(Message *)message;

@end

NS_ASSUME_NONNULL_END
