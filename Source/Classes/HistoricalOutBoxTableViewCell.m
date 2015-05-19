//
//  HistoricalOutBoxTableViewCell.m
//  HomeLess
//
//  Created by Guillermo Apoj on 11/13/14.
//
//

#import "HistoricalOutBoxTableViewCell.h"

@implementation HistoricalOutBoxTableViewCell

- (void)awakeFromNib {
     self.message.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}
@end
