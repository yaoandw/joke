//
//  JokeCell.h
//  joke
//
//  Created by yaoandw on 14-5-7.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Joke.h"
#import "OLImageView.h"
#import "OLImage.h"
#import "MCFireworksButton.h"

@interface JokeCell : UITableViewCell<UIActionSheetDelegate>

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIButton *forwardButton;
@property(nonatomic,strong)UIButton *commentButton;
@property(nonatomic,strong)MCFireworksButton *supportButton;
@property(nonatomic,strong)MCFireworksButton *favoriteButton;

@property(nonatomic,strong)UIView *toolView;

@property(nonatomic,strong)OLImageView *thumbImageView;
@property(nonatomic,strong)UIButton *playButton;
@property(nonatomic,strong)UILabel *tipLabel;

@property(nonatomic,strong)UIView *panelView;

@property(nonatomic,weak)UIViewController *parentViewController;
@property(nonatomic,strong)Joke *joke;

-(void)setJokeCell:(Joke*)joke parentViewController:(UIViewController*)parentViewController;
+(CGFloat)calJokeCellHeight:(Joke*)joke parentViewController:(UIViewController*)parentViewController;
@end
