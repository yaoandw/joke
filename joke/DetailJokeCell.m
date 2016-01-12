//
//  DetailJokeCell.m
//  joke
//
//  Created by yaoandw on 15/10/18.
//  Copyright © 2015年 yycon. All rights reserved.
//  笑话详情中的笑话内容

#import "DetailJokeCell.h"

@implementation DetailJokeCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setJokeCell:(AVObject*)joke parentViewController:(UIViewController*)parentViewController{
    [super setJokeCell:joke parentViewController:parentViewController];
    [self.toolView setFrame:CGRectZero];
    for (UIView *subView in self.toolView.subviews) {
        [subView removeFromSuperview];
    }
    [self.favoriteButton setHidden:YES];
}
+(CGFloat)calJokeCellHeight:(AVObject*)joke{
    return [super calJokeCellHeight:joke] - 30;
}
@end
