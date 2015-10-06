//
//  SmallImageCell.m
//  joke
//
//  Created by yaoandw on 14-5-14.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "SmallImageCell.h"
#import "ColorUtil.h"

@implementation SmallImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(20,7,30,30);
    self.textLabel.frame = CGRectMake(70, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    self.textLabel.backgroundColor = [UIColor clearColor];
    [self.textLabel setTextColor:[ColorUtil getFontMainColor]];
    
    self.detailTextLabel.frame = CGRectMake(70, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    [self.detailTextLabel setTextColor:[ColorUtil getFontAssistColor]];
}
@end
