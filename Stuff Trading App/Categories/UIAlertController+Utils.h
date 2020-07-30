//
//  UIAlertController+Utils.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 17/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^alertCompletion)(int, NSString *_Nullable);

@interface UIAlertController (Utils)

+ (UIAlertController *)sendError:(NSString *)error;
+ (UIAlertController *)takePictureAlert:(alertCompletion)completion;

@end

NS_ASSUME_NONNULL_END
