//
//  UIImage+Utils.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 29/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Utils)

+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;
+ (UIImage *)iconDropdown;
+ (UIImage *)iconBox;
+ (UIImage *)iconCar;
+ (UIImage *)iconChat;
+ (UIImage *)iconMessage;
+ (UIImage *)iconCheckmark;
+ (UIImage *)iconDown;

@end

NS_ASSUME_NONNULL_END
