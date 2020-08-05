//
//  SectionCell.m
//  Stuff Trading App
//
//  Created by Ian Andre Aragon Saenz on 23/07/20.
//  Copyright © 2020 IanAragon. All rights reserved.
//

#import "SectionCell.h"

@interface SectionCell ()

@property (strong, nonatomic) Section *section;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *checkmarkImage;

@end

@implementation SectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if(selected) {
        [self setCheckmark];
    }
}

- (void)setCell:(Section *)section {
    _section = section;
    self.name.text = section.name;
    [self.checkmarkImage setHidden:YES];
}

- (void)setCheckmark {
    if([self.checkmarkImage isHidden]) {
        [self.checkmarkImage setHidden:NO];
    } else {
        [self.checkmarkImage setHidden:YES];
    }
}

@end
