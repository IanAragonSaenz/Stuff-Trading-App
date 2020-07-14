//
//  PostCell.h
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 13/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "User.h"

@protocol PostCellDelegate

- (void)tapUser:(User *_Nullable)user;

@end

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (strong, nonatomic) id<PostCellDelegate> delegate;
- (void)setPost:(Post *)post;

@end

NS_ASSUME_NONNULL_END
