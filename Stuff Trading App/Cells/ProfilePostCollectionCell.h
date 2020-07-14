//
//  ProfilePostCollectionCell.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 14/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfilePostCollectionCell : UICollectionViewCell

- (void)setCell:(Post *)post;

@end

NS_ASSUME_NONNULL_END
