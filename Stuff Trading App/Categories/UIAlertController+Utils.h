//
//  UIAlertController+Utils.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 17/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^alertCompletion)(int);

@interface UIAlertController (Utils)

+ (void)sendError:(NSString *)error onView:(UIViewController *)view;
+ (void)takePictureAlert:(UIViewController *)view withCompletion:(alertCompletion)completion;

@end

NS_ASSUME_NONNULL_END
