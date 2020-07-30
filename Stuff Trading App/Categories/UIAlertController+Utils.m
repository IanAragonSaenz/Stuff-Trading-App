//
//  UIAlertController+Utils.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 17/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "UIAlertController+Utils.h"

@implementation UIAlertController (Utils)

+ (UIAlertController *)sendError:(NSString *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    return alert;
    //[view presentViewController:alert animated:YES completion:nil];
}

+ (UIAlertController *)takePictureAlert:(alertCompletion)completion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose Media" message:@"Choose camera vs photo library" preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            completion(1, nil);
        } else {
            completion(0, @"Camera source not found");
        }
    }];
    [alert addAction:camera];
    
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            completion(2, nil);
        } else {
            completion(0, @"Photo library source not found");
        }
    }];
    [alert addAction:photoLibrary];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completion(3, nil);
    }];
    [alert addAction:cancel];
    
    return alert;
    //[view presentViewController:alert animated:YES completion:nil];
}
@end
