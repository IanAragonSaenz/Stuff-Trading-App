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
@property (weak, nonatomic) IBOutlet UIImageView *messageImage;

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
    if(message.image != nil) {
        [message.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if(!error) {
                self.messageImage.alpha = 0.0;
                self.messageImage.image = [UIImage imageWithData:data];
                [UIView animateWithDuration:0.4 animations:^{
                    self.messageImage.alpha = 1.0;
                }];
            }
        }];
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
        [self.messageImage addGestureRecognizer:pinch];
        [self.messageImage setUserInteractionEnabled:YES];
    }
}

- (void)pinchAction:(UIPinchGestureRecognizer *)pinch {
    if(pinch.state == UIGestureRecognizerStateBegan || pinch.state == UIGestureRecognizerStateChanged) {
        CGFloat currentScale = self.messageImage.frame.size.width / self.messageImage.bounds.size.width;
        CGFloat scale = currentScale * pinch.scale;
        if(scale < 1) {
            scale = 1;
        } else if(scale > 6) {
            scale = 6;
        }
        CGAffineTransform transform = CGAffineTransformMakeScale(scale, currentScale);
        self.messageImage.transform= transform;
        pinch.scale = 1;
    }
}

@end
