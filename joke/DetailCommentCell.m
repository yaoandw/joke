//
//  DetailCell.m
//  joke
//
//  Created by yaoandw on 15/10/11.
//  Copyright © 2015年 yycon. All rights reserved.
//

#import "DetailCommentCell.h"
#import "NSString+HTML.h"
#import "NSString+yycon.h"
#import "ColorUtil.h"
#import "OLImageView.h"
#import "UIImageView+yycon.h"

@interface DetailCommentCell()
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)OLImageView *thumbImageView;
@end

@implementation DetailCommentCell
static NSDateFormatter  *cmtDateformatter;//10-19 11:08
static UIImage *defaultThumbnail;

+(void)initialize{
    cmtDateformatter=[[NSDateFormatter alloc] init];
    [cmtDateformatter setDateFormat:@"MM-dd HH:mm"];
    defaultThumbnail = [UIImage imageNamed:@"avatar_default"];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setUpViews];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataWithComment:(AVObject*)comment{
    CGFloat windowWidth = MyAppDelegate.window.bounds.size.width;
    AVUser *author = comment[@"author"];
    NSString *content = comment[@"content"];
    
    self.nameLabel.textColor = [ColorUtil getFontMainColor];
    self.contentLabel.textColor = [ColorUtil getFontMainColor];
    self.timeLabel.textColor = [ColorUtil getFontAssistColor];
    
    [self.thumbImageView setYyconImageWithURL:[NSURL URLWithString:author[@"avatar"]] placeholderImage:defaultThumbnail];
    NSString *nickname = author[@"nickname"];
    NSString *name = nickname.length>0?nickname:author[@"username"];
    [self.nameLabel setText:name];
    
    NSDate *createDate = comment[@"createdAt"];
    [self.timeLabel setText:[cmtDateformatter stringFromDate:createDate]];
    
    CGFloat contentWidth = windowWidth - 50;
    content = [[content stringByUnescapingHTML] stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    
    CGRect textRect = [content boundingRectWithSize:CGSizeMake(contentWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontSize_4} context:nil];
    CGSize textSize=textRect.size;
    [self.contentLabel setText:content];
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel setFrame:CGRectMake(50, 40, contentWidth, textSize.height)];
}

-(void)setUpViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!self.nameLabel) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 25)];
        self.nameLabel.font = fontSize_3;
        self.nameLabel.textColor = [ColorUtil getFontMainColor];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.nameLabel];
    }
    if (!self.contentLabel) {
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentLabel setFont:fontSize_4];
        self.contentLabel.textColor = [ColorUtil getFontMainColor];
        [self.contentLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.contentLabel];
    }
    if (!self.thumbImageView) {
        self.thumbImageView = [[OLImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        self.thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.thumbImageView.userInteractionEnabled = YES;
        self.thumbImageView.layer.masksToBounds = YES;
        self.thumbImageView.layer.cornerRadius = 15.0;
        
        //[self.thumbImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
        [self.contentView addSubview:self.thumbImageView];
    }
    if (!self.timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 27, 60, 10)];
        self.timeLabel.font = fontSize_1;
        self.timeLabel.textColor = [ColorUtil getFontAssistColor];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.timeLabel];
    }
}

+(CGFloat)calHeightWithComment:(AVObject*)comment{
    CGFloat windowWidth = MyAppDelegate.window.bounds.size.width;
    NSString *content = comment[@"content"];
    CGFloat contentWidth = windowWidth - 50;
    content = [[content stringByUnescapingHTML] stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    
    CGRect textRect = [content boundingRectWithSize:CGSizeMake(contentWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontSize_4} context:nil];
    CGSize textSize=textRect.size;
    
    CGFloat contentHeight = textSize.height;
    
    return 40+contentHeight+5;
}
@end
