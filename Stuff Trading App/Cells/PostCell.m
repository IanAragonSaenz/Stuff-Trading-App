//
//  PostCell.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 13/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "PostCell.h"
#import "DateTools.h"

@interface PostCell ()

@property (weak, nonatomic) IBOutlet UILabel *usernameText;
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *descriptionText;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) Post *post;

@end

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Set Cell

- (void)setPost:(Post *)post {
    _post = post;
    self.usernameText.text = post.author.name;
    self.titleText.text = post.title;
    self.descriptionText.text = post.desc;
    [post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(!error) {
            self.userImage.alpha = 0.0;
            self.userImage.image = [UIImage imageWithData:data];
            [UIView animateWithDuration:0.4 animations:^{
                self.userImage.alpha = 1.0;
            }];
        }
    }];
    self.timeLabel.text = post.createdAt.timeAgoSinceNow;
}


@end
