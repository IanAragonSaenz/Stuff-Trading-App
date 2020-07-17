//
//  UIAlertController+Utils.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 17/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "UIAlertController+Utils.h"

@implementation UIAlertController (Utils)

+ (void)sendError:(NSString *)error onView:(UIViewController *)view {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    [view presentViewController:alert animated:YES completion:nil];
}

@end
