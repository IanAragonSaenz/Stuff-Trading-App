//
//  ProfilePostCollectionCell.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 14/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "ProfilePostCollectionCell.h"
#import <Parse/Parse.h>

@interface ProfilePostCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (strong, nonatomic) Post *post;

@end

@implementation ProfilePostCollectionCell

#pragma mark - Set Cell

- (void)setCell:(Post *)post {
    self.post = post;
    [post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(!error) {
            self.postImage.alpha = 0.0;
            self.postImage.image = [UIImage imageWithData:data];
            [UIView animateWithDuration:0.4 animations:^{
                self.postImage.alpha = 1.0;
            }];
        }
    }];
}

@end
