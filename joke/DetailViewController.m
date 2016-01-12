//
//  DetailTableViewController.m
//  joke
//
//  Created by yaoandw on 15/10/11.
//  Copyright © 2015年 yycon. All rights reserved.
//

#import "DetailViewController.h"
#import "LeanCloudHelper.h"
#import "UIView+Toast.h"
#import "DetailCommentCell.h"
#import "DetailJokeCell.h"
#import "ColorUtil.h"
#import "AVUser.h"
#import "NewCommentController.h"
#import "SocialHelper.h"
#import "LoginHelper.h"
#import "MJRefresh.h"
#import "ReportController.h"
#import "JokeNavController.h"

@interface DetailViewController ()
@property(nonatomic,strong)AVObject *joke;
@property(nonatomic,strong)NSMutableArray *datasource;
@property(nonatomic,assign)long page;
@property(nonatomic,strong)UIView *toolView;
@property(nonatomic,strong)UIButton *forwardButton;
@property(nonatomic,strong)UIButton *commentButton;
@property(nonatomic,strong)MCFireworksButton *supportButton;
@property(nonatomic,strong)MCFireworksButton *favoriteButton;
@property(nonatomic,assign)BOOL scrollToComment;
@end

@implementation DetailViewController

-(id)initWithStyle:(UITableViewStyle)style joke:(AVObject*)joke scrollToComment:(BOOL)scrollToComment{
    self = [self initWithStyle:style];
    if (self) {
        self.joke = joke;
        self.scrollToComment = scrollToComment;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"笑哈哈";
    
    [self doInitDatasource];
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshTable];
    }];
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    
    [self setUpRightButton];
}

-(void)setUpRightButton{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"举报" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightButtonTapped:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}
-(void)rightButtonTapped:(id)sender{
    ReportController *controller = [[ReportController alloc] initWithStyle:(UITableViewStyleGrouped) subject:self.joke[@"name"] identity:self.joke.objectId];
    [self presentViewController:[[JokeNavController alloc] initWithRootViewController:controller] animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self doInitToolView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.toolView removeFromSuperview];
}

-(void)reloadTableViewData{
    [self.tableView reloadData];
    if (self.scrollToComment) {
        self.scrollToComment = NO;
        if ([self.datasource count] > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
        }
    }
}

-(void)refreshTable{
    
    [self doInitDatasource];
}

-(void)doInitDatasource{
    self.page = 0;
    [self.refreshControl beginRefreshing];
    [LeanCloudHelper fetchAVCommentsOfJoke:self.joke page:self.page onSuccess:^(NSArray *avComments) {
        self.page ++;
        [self.tableView.mj_header endRefreshing];
        self.datasource = [NSMutableArray arrayWithArray:avComments];
        [self reloadTableViewData];
    } onError:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.view makeToast:[NSString stringWithFormat:@"%@",[[error userInfo] objectForKey:@"error"]] duration:3.0 position:CSToastPositionCenter];
    }];
}
-(void)loadMore{
    [LeanCloudHelper fetchAVCommentsOfJoke:self.joke page:self.page++ onSuccess:^(NSArray *avComments) {
        [self.tableView.mj_footer endRefreshing];
        [self.datasource addObjectsFromArray:avComments];
        [self reloadTableViewData];
    } onError:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.view makeToast:[NSString stringWithFormat:@"%@",[[error userInfo] objectForKey:@"error"]] duration:3.0 position:CSToastPositionCenter];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - footview

-(void)doInitToolView{
    if (self.toolView) {
        [self.navigationController.view addSubview:self.toolView];
        return;
    }
    CGFloat toolViewHeight = 44;
    CGFloat windowWidth = self.view.frame.size.width;
    CGFloat borderWidth = 0.5;
    
    //init borderlayer
    CALayer *topBorderLayer = [CALayer layer];
    topBorderLayer.frame = CGRectMake(0, 0, windowWidth, borderWidth);
    
    CALayer *bottomBorderLayer = [CALayer layer];
    bottomBorderLayer.frame = CGRectMake(0, toolViewHeight, windowWidth, borderWidth);
    
    CALayer *leftBorderLayer1 = [CALayer layer];
    leftBorderLayer1.frame = CGRectMake(0, 5, borderWidth, toolViewHeight-10);
    
    CALayer *leftBorderLayer2 = [CALayer layer];
    leftBorderLayer2.frame = CGRectMake(0, 5, borderWidth, toolViewHeight-10);
    
    CALayer *leftBorderLayer3 = [CALayer layer];
    leftBorderLayer3.frame = CGRectMake(0, 5, borderWidth, toolViewHeight-10);
    
    [topBorderLayer setBackgroundColor:[ColorUtil getBorderColor].CGColor];
    [bottomBorderLayer setBackgroundColor:[ColorUtil getBorderColor].CGColor];
    [leftBorderLayer1 setBackgroundColor:[ColorUtil getBorderColor].CGColor];
    [leftBorderLayer2 setBackgroundColor:[ColorUtil getBorderColor].CGColor];
    [leftBorderLayer3 setBackgroundColor:[ColorUtil getBorderColor].CGColor];
    
    if (!self.toolView) {
        self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.view.frame.size.height - toolViewHeight, windowWidth, toolViewHeight)];
        [self.toolView setBackgroundColor:[ColorUtil getPanelBgColor]];
        [self.toolView.layer addSublayer: topBorderLayer];
        [self.toolView.layer addSublayer: bottomBorderLayer];
        
        [self.navigationController.view addSubview:self.toolView];
    }
    self.forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, windowWidth/4, toolViewHeight)];
    [self.forwardButton setImage:[UIImage imageNamed:@"timeline_icon_retweet"] forState:UIControlStateNormal];
    [self.forwardButton addTarget:self action:@selector(forwardButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.forwardButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    self.forwardButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.forwardButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, 10, 0, 0))];
    
    [self.toolView addSubview:self.forwardButton];
    
    self.commentButton = [[UIButton alloc] initWithFrame:CGRectMake(windowWidth/4, 0, windowWidth/4, toolViewHeight)];
    [self.commentButton setImage:[UIImage imageNamed:@"timeline_icon_comment"] forState:(UIControlStateNormal)];
    [self.commentButton addTarget:self action:@selector(commentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.commentButton.layer addSublayer: leftBorderLayer1];
    
    [self.commentButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    self.commentButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.commentButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, 10, 0, 0))];
    
    [self.toolView addSubview:self.commentButton];
    
    self.supportButton = [[MCFireworksButton alloc] initWithFrame:CGRectMake(2*windowWidth/4, 0, windowWidth/4, toolViewHeight)];
    [self.supportButton setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:(UIControlStateNormal)];
    [self.supportButton addTarget:self action:@selector(supportButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.supportButton.layer addSublayer: leftBorderLayer2];
    
    [self.supportButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    self.supportButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.supportButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, 10, 0, 0))];
    
    [self.toolView addSubview:self.supportButton];
    
    self.favoriteButton = [[MCFireworksButton alloc] initWithFrame:CGRectMake(3*windowWidth/4, 0, windowWidth/4, toolViewHeight)];
    [self.favoriteButton setImage:[UIImage imageNamed:@"timeline_icon_unfavorite"] forState:(UIControlStateNormal)];
    [self.favoriteButton addTarget:self action:@selector(favoriteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.favoriteButton.layer addSublayer: leftBorderLayer3];
    
    [self.favoriteButton setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    self.favoriteButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.favoriteButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, 10, 0, 0))];
    
    [self.toolView addSubview:self.favoriteButton];
    
    //set values
    [self setToolViewValues];
}

-(void)setToolViewValues{
    BOOL supported = [self.joke[@"supportUsers"] containsObject:[AVUser currentUser]];
    BOOL favorited = [self.joke[@"favoriteUsers"] containsObject:[AVUser currentUser]];
    
    UIImage *supportImage = supported?[UIImage imageNamed:@"timeline_icon_like"]:[UIImage imageNamed:@"timeline_icon_unlike"];
    [self.supportButton setImage:supportImage forState:(UIControlStateNormal)];
    
    UIImage *favoriteImage = favorited?[UIImage imageNamed:@"timeline_icon_favorite"]:[UIImage imageNamed:@"timeline_icon_unfavorite"];
    [self.favoriteButton setImage:favoriteImage forState:(UIControlStateNormal)];
    long supportCount = [self.joke[@"supportUsers"] count];
    long favoriteCount = [self.joke[@"favoriteUsers"] count];
    long commentCount = [self.joke[@"comments"] count];
    NSNumber *forwardCount = self.joke[@"forward"];
    if (supportCount > 0) {
        [self.supportButton setTitle:[NSString stringWithFormat:@"%ld",supportCount] forState:(UIControlStateNormal)];
    }else{
        [self.supportButton setTitle:@"赞" forState:(UIControlStateNormal)];
    }
    if (favoriteCount > 0) {
        [self.favoriteButton setTitle:[NSString stringWithFormat:@"%ld",favoriteCount] forState:(UIControlStateNormal)];
    }else{
        [self.favoriteButton setTitle:@"收藏" forState:(UIControlStateNormal)];
    }
    if (commentCount > 0) {
        [self.commentButton setTitle:[NSString stringWithFormat:@"%ld",commentCount] forState:(UIControlStateNormal)];
    }else{
        [self.commentButton setTitle:@"评论" forState:(UIControlStateNormal)];
    }
    if (forwardCount && forwardCount.longValue > 0) {
        [self.forwardButton setTitle:forwardCount.stringValue forState:(UIControlStateNormal)];
    }else{
        [self.forwardButton setTitle:@"分享" forState:(UIControlStateNormal)];
    }
}

-(void)forwardButtonTapped:(UIButton*)forwardButton{
    [SocialHelper showShareActionSheetWithJoke:self.joke];
}
-(void)commentButtonTapped:(UIButton*)commentButton{
    [[LoginHelper getInstance] loginWithBlock:^(AVUser *user) {
        NewCommentController *controller = [[NewCommentController alloc] initWithJoke:self.joke delegate:self];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES completion:nil];
    }];
}
-(void)supportButtonTapped:(MCFireworksButton*)supportButton{
    [[LoginHelper getInstance] loginWithBlock:^(AVUser *user) {
        UIImage *likeImage;
        BOOL supported = [self.joke[@"supportUsers"] containsObject:[AVUser currentUser]];
        if (supported) {
            [LeanCloudHelper deleteSupportWithJoke:self.joke];
            likeImage = [UIImage imageNamed:@"timeline_icon_unlike"];
        }else{
            [LeanCloudHelper saveSupportWithJoke:self.joke];
            likeImage = [UIImage imageNamed:@"timeline_icon_like"];
        }
        [self setToolViewValues];
        [self.supportButton popOutsideWithDuration:0.5];
        [self.supportButton setImage:likeImage forState:(UIControlStateNormal)];
        [self.supportButton animate];
    }];
}
-(void)favoriteButtonTapped:(MCFireworksButton*)favoriteButton{
    [[LoginHelper getInstance] loginWithBlock:^(AVUser *user) {
        UIImage *favoriteImage;
        BOOL favorited = [self.joke[@"favoriteUsers"] containsObject:[AVUser currentUser]];
        if (favorited) {
            [LeanCloudHelper deleteFavoriteWithJoke:self.joke];
            favoriteImage = [UIImage imageNamed:@"toolbar_favorite"];
        }else{
            [LeanCloudHelper saveFavoriteWithJoke:self.joke onSuccess:nil onError:nil];
            favoriteImage = [UIImage imageNamed:@"toolbar_favorite_highlighted"];
        }
        [self setToolViewValues];
        [self.favoriteButton popOutsideWithDuration:0.5];
        [self.favoriteButton setImage:favoriteImage forState:(UIControlStateNormal)];
        [self.favoriteButton animate];
    }];
}

#pragma mark - NewCommentControllerDelegate
-(void)commentHasSent{
    [self doInitDatasource];
    [self setToolViewValues];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewDismissed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return [self.datasource count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *rtnCell;
    
    // Configure the cell...
    if (indexPath.section == 0) {
        DetailJokeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail joke cell"];
        if (!cell) {
            cell = [[DetailJokeCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"detail joke cell"];
        }
        rtnCell = cell;
        
        [cell setJokeCell:self.joke parentViewController:self];
        
    }else if (indexPath.section == 1){
        DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail cell"];
        if (!cell) {
            cell = [[DetailCommentCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"detail cell"];
        }
        rtnCell = cell;
        AVObject *comment = [self.datasource objectAtIndex:indexPath.row];
        [cell setDataWithComment:comment];
    }
    
    return rtnCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [JokeCell calJokeCellHeight:self.joke];
    }else if (indexPath.section == 1){
        AVObject *comment = [self.datasource objectAtIndex:indexPath.row];
        return [DetailCommentCell calHeightWithComment:comment];
    }
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        [headerView setBackgroundColor:[UIColor whiteColor]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
        [label setText:@"评论"];
        [label setFont:[UIFont boldSystemFontOfSize:16]];
        [headerView addSubview:label];
        return headerView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
    }
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

@end
