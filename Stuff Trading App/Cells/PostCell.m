//
//  PostCell.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 13/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "PostCell.h"

@interface PostCell ()

@property (weak, nonatomic) IBOutlet UILabel *usernameText;
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *descriptionText;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

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

- (void)setPost:(Post *)post{
    self.usernameText.text = post.author.username;
    self.titleText.text = post.title;
    self.descriptionText.text = post.desc;
    //self.userImage = post.author.image;
}

@end