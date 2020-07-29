//
//  UIImage+Utils.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 29/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "UIImage+Utils.h"

@implementation UIImage (Utils)

#pragma mark - Sizing Image

+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
