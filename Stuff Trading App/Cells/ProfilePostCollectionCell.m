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

- (void)setCell:(Post *)post{
    self.post = post;
    [post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(!error)
            self.postImage.image = [UIImage imageWithData:data];
    }];
}

@end
