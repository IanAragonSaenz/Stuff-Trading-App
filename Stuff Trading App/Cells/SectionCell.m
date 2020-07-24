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

@end

@implementation SectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(Section *)section {
    _section = section;
    self.name.text = section.name;
}

@end
