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

+ (void)takePictureAlert:(UIViewController *)view withCompletion:(alertCompletion)completion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose Media" message:@"Choose camera vs photo library" preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            completion(1);
        } else {
            [self sendError:@"Camera source not found" onView:view];
            completion(0);
        }
    }];
    [alert addAction:camera];
    
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            completion(2);
        } else {
            [self sendError:@"Photo library source not found" onView:view];
            completion(0);
        }
    }];
    [alert addAction:photoLibrary];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completion(0);
    }];
    [alert addAction:cancel];
    
    [view presentViewController:alert animated:YES completion:nil];
}
@end
