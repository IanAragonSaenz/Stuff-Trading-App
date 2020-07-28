//
//  MessageCell.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 16/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "MessageCell.h"
#import "DateTools.h"

@interface MessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *timeAgo;

@end

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Set Cell

- (void)setCell:(Message *)message {
    self.username.text = message.sender.username;
    self.message.text = message.message;
    self.timeAgo.text = message.createdAt.timeAgoSinceNow;
}

@end
