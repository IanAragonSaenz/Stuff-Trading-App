//
//  ChatCell.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 16/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "ChatCell.h"

@interface ChatCell ()

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *latestMessage;

@end

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Set Cell

- (void)setCell:(Chat *)chat {
    if([chat.userA.username isEqual:[User currentUser]]) {
        self.username.text = chat.userB.username;
    } else {
        self.username.text = chat.userA.username;
    }
    self.latestMessage.text = chat.latestMessage;
}

@end
