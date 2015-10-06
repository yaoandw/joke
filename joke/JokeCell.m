//
//  JokeCell.m
//  joke
//
//  Created by yaoandw on 14-5-7.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "JokeCell.h"
#import "NSString+HTML.h"
#import "NSString+yycon.h"
#import "UIImageView+yycon.h"
#import "AFImageResponseSerializer+OLImage.h"
#import "EGYWebViewController.h"
#import "FileUtil.h"
#import "SocialHelper.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "LoginHelper.h"
#import "ColorUtil.h"
#import "AppDelegate.h"

@interface JokeCell()<MWPhotoBrowserDelegate>
@property(nonatomic,strong)NSMutableArray *photos;

@property(nonatomic,strong)CALayer *topBorderLayer;
@property(nonatomic,strong)CALayer *bottomBorderLayer;
@property(nonatomic,strong)CALayer *leftBorderLayer1;
@property(nonatomic,strong)CALayer *leftBorderLayer2;
@end

@implementation JokeCell
CGFloat toolViewHeight = 30.0f;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setUpViews];
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
-(void)setJokeCell:(Joke*)joke parentViewController:(UIViewController*)parentViewController{
    self.parentViewController = parentViewController;
    self.joke = joke;
    self.nameLabel.text = [joke.name processName];
    
    self.nameLabel.textColor = [ColorUtil getFontMainColor];
    self.contentLabel.textColor = [ColorUtil getFontMainColor];
    self.timeLabel.textColor = [ColorUtil getFontAssistColor];
    [self.panelView setBackgroundColor:[ColorUtil getPanelBgColor]];
    
    [self.topBorderLayer setBackgroundColor:[ColorUtil getBorderColor].CGColor];
    [self.bottomBorderLayer setBackgroundColor:[ColorUtil getBorderColor].CGColor];
    [self.leftBorderLayer1 setBackgroundColor:[ColorUtil getBorderColor].CGColor];
    [self.leftBorderLayer2 setBackgroundColor:[ColorUtil getBorderColor].CGColor];
    
    CGFloat windowWidth = parentViewController.view.bounds.size.width;
    
    NSString *content = joke.content;
    CGFloat contentWidth = windowWidth - 10;
    content = [[content stringByUnescapingHTML] stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    CGSize textSize=[content sizeWithFont:fontSize_4 constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    [self.contentLabel setText:content];
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel setFrame:CGRectMake(5, 40, contentWidth, textSize.height)];
    
    //[self.forwardButton setFrame:CGRectMake(windowWidth-40, 5, 30, 30)];
    //[self.timeLabel setFrame:CGRectMake(windowWidth-110, 5, 100, 30)];
    
    if (joke.thmurl.length > 0) {
        DLog(@"joke.thmurl:%@,joke.imgurl:%@",joke.thmurl,joke.imgurl);
        [self.thumbImageView setHidden:NO];
        [self.thumbImageView setFrame:CGRectMake(10, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+10, (windowWidth-20), 200)];
        [self.thumbImageView setYyconImageWithURL:[NSURL URLWithString:joke.thmurl] placeholderImage:[OLImage imageNamed:@"loading.gif"]];
        
        if (joke.videourl.length > 0) {//视频,显示播放按钮
            [self.playButton setHidden:NO];
            [self.tipLabel setHidden:YES];
            [self.playButton setFrame:CGRectMake((windowWidth-320)/2+120, self.thumbImageView.frame.origin.y+60, 80, 80)];
        }else{
            [self.playButton setHidden:YES];
            [self.tipLabel setFrame:CGRectMake(10, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+10, (windowWidth-20), 30)];
            [self.tipLabel setHidden:NO];
        }
    }else{
        [self.thumbImageView setHidden:YES];
        [self.playButton setHidden:YES];
    }
    
    CGFloat toolViewY = self.thumbImageView.hidden?(self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height):(self.thumbImageView.frame.origin.y+self.thumbImageView.frame.size.height)+10;
    
    [self.toolView setFrame:CGRectMake(0, toolViewY+5, windowWidth, toolViewHeight)];
    [self.panelView setFrame:CGRectMake(0, 5, windowWidth, toolViewY+toolViewHeight+5)];
    
    [self.timeLabel setText:joke.time];
    //[self.timeLabel setFrame:CGRectMake(10, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+10, 300, 30)];
    
    NSMutableDictionary *userSettings = [FileUtil getUserSettings];
    BOOL nightMode = [[userSettings objectForKey:@"nightMode"] boolValue];
    if (nightMode) {
        
    }
}

-(void)setUpViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat windowWidth = MyAppDelegate.window.frame.size.width;
    CGFloat borderWidth = 0.5;
    
    //init borderlayer
    self.topBorderLayer = [CALayer layer];
    self.topBorderLayer.frame = CGRectMake(0, 0, windowWidth, borderWidth);
    
    self.bottomBorderLayer = [CALayer layer];
    self.bottomBorderLayer.frame = CGRectMake(0, toolViewHeight, windowWidth, borderWidth);
    
    self.leftBorderLayer1 = [CALayer layer];
    self.leftBorderLayer1.frame = CGRectMake(0, 5, borderWidth, toolViewHeight-10);
    
    self.leftBorderLayer2 = [CALayer layer];
    self.leftBorderLayer2.frame = CGRectMake(0, 5, borderWidth, toolViewHeight-10);
    
    if (!self.panelView) {
        self.panelView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.panelView];
    }
    if (!self.nameLabel) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 25)];
        self.nameLabel.font = fontSize_3;
        self.nameLabel.textColor = [ColorUtil getFontMainColor];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        [self.panelView addSubview:self.nameLabel];
    }
    if (!self.toolView) {
        self.toolView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.toolView.layer addSublayer: self.topBorderLayer];
        [self.toolView.layer addSublayer: self.bottomBorderLayer];
        
        [self.panelView addSubview:self.toolView];
    }
    if (!self.forwardButton) {
        self.forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, windowWidth/3, toolViewHeight)];
        [self.forwardButton setImage:[UIImage imageNamed:@"timeline_icon_retweet"] forState:UIControlStateNormal];
        [self.forwardButton addTarget:self action:@selector(forwardButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolView addSubview:self.forwardButton];
    }
    if (!self.commentButton) {
        self.commentButton = [[UIButton alloc] initWithFrame:CGRectMake(windowWidth/3, 0, windowWidth/3, toolViewHeight)];
        [self.commentButton setImage:[UIImage imageNamed:@"timeline_icon_comment"] forState:(UIControlStateNormal)];
        [self.commentButton addTarget:self action:@selector(commentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.commentButton.layer addSublayer: self.leftBorderLayer1];
        
        [self.toolView addSubview:self.commentButton];
    }
    if (!self.supportButton) {
        self.supportButton = [[MCFireworksButton alloc] initWithFrame:CGRectMake(2*windowWidth/3, 0, windowWidth/3, toolViewHeight)];
        [self.supportButton setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:(UIControlStateNormal)];
        [self.supportButton addTarget:self action:@selector(supportButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.supportButton.layer addSublayer: self.leftBorderLayer2];
        
        [self.toolView addSubview:self.supportButton];
    }
    if (!self.favoriteButton) {
        self.favoriteButton = [[MCFireworksButton alloc] initWithFrame:CGRectMake(windowWidth-40, 5, 30, 30)];
        [self.favoriteButton setImage:[UIImage imageNamed:@"toolbar_favorite"] forState:(UIControlStateNormal)];
        [self.favoriteButton addTarget:self action:@selector(favoriteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.panelView addSubview:self.favoriteButton];
        
    }
    if (!self.contentLabel) {
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentLabel setFont:fontSize_4];
        self.contentLabel.textColor = [ColorUtil getFontMainColor];
        [self.contentLabel setBackgroundColor:[UIColor clearColor]];
        [self.panelView addSubview:self.contentLabel];
    }
    if (!self.thumbImageView) {
        self.thumbImageView = [[OLImageView alloc] initWithFrame:CGRectZero];
        self.thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.thumbImageView.userInteractionEnabled = YES;
        [self.thumbImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
        [self.panelView addSubview:self.thumbImageView];
    }
    if (!self.playButton) {
        self.playButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(playButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.panelView addSubview:self.playButton];
    }
    if (!self.timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(windowWidth-110, 5, 100, 30)];
        self.timeLabel.font = fontSize_2;
        self.timeLabel.textColor = [ColorUtil getFontAssistColor];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        [self.panelView addSubview:self.timeLabel];
    }
    if (!self.tipLabel) {
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.tipLabel setText:@"点击图片显示大图"];
        [self.tipLabel setTextColor:fontColor_strong];
        [self.tipLabel setFont:fontSize_4];
        [self.tipLabel setTextAlignment:NSTextAlignmentCenter];
        [self.tipLabel setBackgroundColor:[UIColor clearColor]];
        [self.panelView addSubview:self.tipLabel];
    }
}
+(CGFloat)calJokeCellHeight:(Joke*)joke parentViewController:(UIViewController*)parentViewController{
    CGFloat nameHeight = 40;
    
    CGFloat windowWidth = parentViewController.view.bounds.size.width;
    
    NSString *content = joke.content;
    CGFloat contentWidth = windowWidth - 10;
    content = [[content stringByUnescapingHTML] stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    CGSize textSize=[content sizeWithFont:fontSize_4 constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat contentHeight = textSize.height;
    
    CGFloat imgHeight = 0;
    if (joke.thmurl.length>0) {
        imgHeight = 20+200;
    }
    return nameHeight + contentHeight + imgHeight + toolViewHeight +15;
}

- (void)handleTap:(UITapGestureRecognizer *)gestRecon{
    if (self.joke.videourl.length > 0) {
        
    }else{
        // Or use this constructor to receive an NSArray of IDMPhoto objects from your NSURL objects
        DLog(@"joke.imgurl: %@",self.joke.imgurl);
        /*NSArray *photos = [IDMPhoto photosWithURLs:@[[NSURL URLWithString:self.joke.imgurl]]];
        
        // Create and setup browser
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:self.thumbImageView]; // using initWithPhotos:animatedFromView: method to use the zoom-in animation
        browser.delegate = self;
        browser.displayActionButton = YES;
        browser.displayArrowButton = YES;
        browser.displayCounterLabel = YES;
        browser.displayDoneButton = YES;
        [browser setInitialPageIndex:0];
        
        // Show
        [self.parentViewController presentViewController:browser animated:YES completion:nil];
        */
        
        self.photos = [NSMutableArray array];
        [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:self.joke.imgurl]]];
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        // Set options
        browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
        browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
        browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
        browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
        browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
        browser.autoPlayOnAppear = NO; // Auto-play first video
        
        [self.parentViewController.navigationController pushViewController:browser animated:YES];
        
        /*OLImageView *imageView = (OLImageView *)gestRecon.view;
        if (imageView.isAnimating) {
            NSLog(@"STOP");
            [imageView stopAnimating];
        } else {
            NSLog(@"START");
            [imageView startAnimating];
        }*/
    }
    
}
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.photos.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}
-(void)playButtonTap:(UIButton*)button{
    NSString *url = [NSString stringWithFormat:@"%@&isAutoPlay=true",self.joke.videourl];
    DLog(@"url:%@",url);
    EGYWebViewController *webViewController = [[EGYWebViewController alloc] initWithAddress:url];
    [self.parentViewController.navigationController pushViewController:webViewController animated:YES];
}

-(void)forwardButtonTapped:(UIButton*)button{
    //qq空间不支持纯文本的分享
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"分享到..." delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信",@"微信朋友圈",@"qq", nil];
    if (self.joke.thmurl.length > 0){//如果是笑图
        sheet = [[UIActionSheet alloc] initWithTitle:@"分享到..." delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信",@"微信朋友圈",@"qq",@"qq空间", nil];
    }
    [sheet showInView:MyAppDelegate.window];
    
    //在分享代码前设置微信分享应用类型，用户点击消息将跳转到应用，或者到下载页面
    //UMSocialWXMessageTypeImage 为纯图片类型
    /*
    UIImage *shareImage = [UIImage imageNamed:@"icon"];
    if (self.joke.thmurl.length > 0){//如果是笑图
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
        shareImage = self.thumbImageView.image;
    }else{
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
    }
    
    //分享图文样式到微信朋友圈显示字数比较少，只显示分享标题
    //[UMSocialData defaultData].extConfig.title = @"朋友圈分享内容yycon";
    //设置微信好友或者朋友圈的分享url,下面是微信好友，微信朋友圈对应wechatTimelineData
    //[UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://xxxx";//UMSocialYXMessageTypeWeb 类型 点击微信消息后跳转
    
    //[UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    
    
    [UMSocialSnsService presentSnsIconSheetView:self.parentViewController
                                         appKey:UM_APPKEY
                                      shareText:[NSString stringWithFormat:@"%@【来自笑哈哈】", self.joke.content]
                                     shareImage:shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToQzone, UMShareToQQ,UMShareToTencent,UMShareToSina,UMShareToRenren,nil]
                                       delegate:self];
    */
}
#pragma mark uiactionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [SocialHelper sendJokeToWeixin:self.joke];
            break;
        case 1:
            [SocialHelper sendJokeToWeixinTimeline:self.joke];
            break;
        case 2:
            [SocialHelper sendJokeToQQ:self.joke];
            break;
        case 3:
            [SocialHelper sendJokeToQZone:self.joke];
            break;
        default:
            break;
    }
}
-(void)commentButtonTapped:(UIButton*)button{
    
}
-(void)supportButtonTapped:(UIButton*)button{
    [[LoginHelper getInstance] loginWithBlock:^(AVUser *user) {
        
        [self.supportButton popOutsideWithDuration:0.5];
        [self.supportButton setImage:[UIImage imageNamed:@"timeline_icon_like"] forState:(UIControlStateNormal)];
        [self.supportButton animate];
    }];
}
-(void)favoriteButtonTapped:(UIButton*)button{
    [[LoginHelper getInstance] loginWithBlock:^(AVUser *user) {
        [self.favoriteButton popOutsideWithDuration:0.5];
        [self.favoriteButton setImage:[UIImage imageNamed:@"toolbar_favorite_highlighted"] forState:(UIControlStateNormal)];
        [self.favoriteButton animate];
    }];
}
@end
