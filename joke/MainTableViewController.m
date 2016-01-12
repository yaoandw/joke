//
//  MainTableViewController.m
//  joke
//
//  Created by yaoandw on 14-5-7.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "MainTableViewController.h"
#import "RESTEngine.h"
#import "UIAlertView+yycon.h"
#import "AFHTTPRequestOperation.h"
#import "Joke.h"
#import "JokeCell.h"
#import "NSDate+yycon.h"
#import "FileUtil.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ColorUtil.h"
#import "AppCache.h"
#import "LeanCloudHelper.h"
#import "DetailViewController.h"
#import "ReportController.h"
#import "JokeNavController.h"

@interface MainTableViewController ()
@property(nonatomic,strong)NSMutableArray *datasource;
//
@property(nonatomic,assign)NSInteger startPage;
@property(nonatomic,strong)UISegmentedControl *segmentControl;
@property(nonatomic,strong)NSMutableDictionary *userSettings;
//radom
@property(nonatomic,assign)NSInteger rdStartPage;

@property(nonatomic,assign)BOOL radom;
@property(nonatomic,strong)NSDate *randomDate;

@property(nonatomic,strong)AFHTTPRequestOperation* currentOperation;
@property(nonatomic,strong)UILabel *noResultLabel;
@end

@implementation MainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doAppDidBecomeActiveNotification:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doAppDidChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    [self setupLeftMenuButton];
    
    [self setUpRefreshButton];
    
    [self setUpTitle];
    
    [self setNumberOfSections:1];
    
    [self loadData];
    
    [self.tableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    
    //[LeanCloudHelper test];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [ColorUtil setStyle1ForTableViewController:self];
    
    /*if (self.richJoke) {
        [MobClick beginLogPageView:@"richJoke"];
    }else{
        [MobClick beginLogPageView:@"textJoke"];
    }*/
    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    /*if (self.richJoke) {
        [MobClick endLogPageView:@"richJoke"];
    }else{
        [MobClick endLogPageView:@"textJoke"];
    }*/
}
-(void)reloadTableData{
    if ([self.datasource count] > 0) {
        [self.noResultLabel setHidden:YES];
    }else{
        if (self.noResultLabel) {
            [self.noResultLabel setHidden:NO];
        }else{
            self.noResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 30)];
            [self.noResultLabel setText:@"没有结果"];
            self.noResultLabel.textAlignment = NSTextAlignmentCenter;
            self.noResultLabel.font = [UIFont systemFontOfSize:20];
            self.noResultLabel.textColor = [UIColor grayColor];
            [self.view addSubview:self.noResultLabel];
        }
    }
    [self.tableView reloadData];
}
-(void)loadData{
    //启动的时候,刷新下
    BOOL refreshed = self.richJoke?MyAppDelegate.fromLaunch_richJokeRefreshed:MyAppDelegate.fromLaunch_jokeRefreshed;
    if (!refreshed) {
        self.richJoke?(MyAppDelegate.fromLaunch_richJokeRefreshed = YES):(MyAppDelegate.fromLaunch_jokeRefreshed = YES);
        [self doRefresh];
        return;
    }
    self.datasource = [NSMutableArray arrayWithArray:[self getCachedJokes]];
    if ([self.datasource count] > 0) {
        self.radom?(self.rdStartPage = 1):(self.startPage = 1);
        [self reloadTableData];
    }else{
        [self doRefresh];
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1 && alertView.tag == 1){//refresh
        [self refresh];
    }else if (buttonIndex == 1 && alertView.tag == 2){//loadmore
        [self doLoadMore];
    }else{
        self.loading = NO;
    }
}
-(void)doRefresh{
    if (self.richJoke && [RESTEngine detectNetworkStatus] != YyconReachableViaWiFi) {
        UIAlertView *networkAlert = [[UIAlertView alloc] initWithTitle:nil message:@"建议在Wifi环境下观看,土豪请随意" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续",nil];
        networkAlert.alertViewStyle = UIAlertViewStyleDefault;
        networkAlert.tag = 1;
        [networkAlert show];
    }else{
        [self refresh];
    }
}
-(void)refresh{
    //
    if (self.radom) {//下拉刷新,更新随机数
        self.randomDate = [self genRandomDate];
    }
    [LeanCloudHelper fetchAVJokesByPage:0 jokeType:self.richJoke?avjoke_type_image:avjoke_type_text randomTime:self.radom?self.randomDate:nil onSuccess:^(NSArray *avJokes) {
        //DLog(@"avJokes=%@,supportedJokes=%@,favoritedJokes=%@",avJokes,supportedJokes,favoritedJokes);
        self.loading = NO;
        if (avJokes && [avJokes count] > 0) {
            self.datasource = [NSMutableArray arrayWithArray:avJokes];
            self.radom?(self.rdStartPage = 1):(self.startPage = 1);
            self.endReached = NO;
            [self cacheJokes];
        }else{
            self.endReached = YES;
        }
        [self reloadTableData];
    } onError:^(NSError *error) {
        self.loading = NO;
        [UIAlertView showWithError:error];
    }];
}
-(void)loadMore{
    if (self.richJoke && [RESTEngine detectNetworkStatus] != YyconReachableViaWiFi) {
        UIAlertView *networkAlert = [[UIAlertView alloc] initWithTitle:nil message:@"建议在Wifi环境下观看,土豪请随意" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续",nil];
        networkAlert.alertViewStyle = UIAlertViewStyleDefault;
        networkAlert.tag = 2;
        [networkAlert show];
    }else{
        [self doLoadMore];
    }
}
-(void)doLoadMore{
    NSInteger nowStartPage = self.radom?self.rdStartPage:self.startPage;
    if (nowStartPage>0) {
        if (self.radom && !self.randomDate) {//如果没有随机数,生成一个
            self.randomDate = [self genRandomDate];
        }
        //
        [LeanCloudHelper fetchAVJokesByPage:nowStartPage jokeType:self.richJoke?avjoke_type_image:avjoke_type_text randomTime:self.radom?self.randomDate:nil onSuccess:^(NSArray *avJokes) {
            if (avJokes && [avJokes count] > 0) {
                [self.datasource addObjectsFromArray:avJokes];
                self.radom?(self.rdStartPage++):(self.startPage ++);
                self.endReached = NO;
                [self cacheJokes];
            }else{
                self.endReached = YES;
            }
            [self reloadTableData];
        } onError:^(NSError *error) {
            [UIAlertView showWithError:error];
        }];
    }else{
        self.endReached = YES;
    }
}
-(NSArray*)getCachedJokes{
    NSArray *cachedJokes = self.richJoke?(self.radom?[AppCache getCachedRadomRichJokes]:[AppCache getCachedLastestRichJokes]):(self.radom?[AppCache getCachedRadomJokes]:[AppCache getCachedLastestJokes]);
    NSMutableArray *jokeArray = [NSMutableArray array];
    for (NSDictionary *dict in cachedJokes) {
        [jokeArray addObject:[AVObject objectWithDictionary:dict]];
    }
    return jokeArray;
}
-(void)cacheJokes{
    NSMutableArray *dictArray = [NSMutableArray array];
    for (AVObject *obj in self.datasource) {
        [dictArray addObject:[obj dictionaryForObject]];
    }
    self.richJoke?(self.radom?[AppCache cacheRadomRichJokes:dictArray]:[AppCache cacheLastestRichJokes:dictArray]):(self.radom?[AppCache cacheRadomJokes:dictArray]:[AppCache cacheLastestJokes:dictArray]);
}
#pragma mark title
-(void)setUpTitle{
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"最新",@"穿越"]];
    
    //self.segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.segmentControl setSelectedSegmentIndex:0];
    [self.segmentControl addTarget:self action:@selector(segmentControlTaped:) forControlEvents:UIControlEventValueChanged];
    [self.segmentControl setFrame:CGRectMake(0, 0, 150, 30)];
    self.segmentControl.tintColor = [UIColor grayColor];
    
    //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIColor blackColor],UITextAttributeTextShadowColor ,nil];
    //[self.segmentControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 150, 30)];
    [titleView addSubview:self.segmentControl];
    self.navigationItem.titleView = titleView;
}
-(void)segmentControlTaped:(UISegmentedControl*)segmentedControl{
    long index = segmentedControl.selectedSegmentIndex;
    NSLog(@"select index:%ld",index);
    if (index==0) {
        self.radom = NO;
    }else if(index == 1){
        self.radom = YES;
    }
    [self loadData];
    self.endReached = NO;
}
#pragma mark refresh button
-(void)setUpRefreshButton{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonTapped)];
    self.navigationItem.rightBarButtonItem = rightButton;
}
-(void)refreshButtonTapped{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.tableView.contentInset = UIEdgeInsetsMake(66.0f, 0.0f, 0.0f, 0.0f);// set the Inset
    // scroll the table view to the new top region
    [self.tableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
    [UIView commitAnimations];
    [self showRefreshHeader:self.tableView];
}
#pragma mark leftButton
-(void)setupLeftMenuButton{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftButton setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:leftButton] animated:YES];
}
#pragma mark - Button Handlers
-(void)leftButtonTapped:(id)sender{
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == self.numberOfSections)  {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    return [self.datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == self.numberOfSections)  {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    static NSString *CellIdentifier = @"jokeCell";
    JokeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[JokeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.delegate = self;
    // Configure the cell...
    AVObject *joke = [self.datasource objectAtIndex:indexPath.row];
    [cell setJokeCell:joke parentViewController:self];
    //cell.delegate = self;
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == self.numberOfSections)  {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    AVObject *joke = [self.datasource objectAtIndex:indexPath.row];
    return [JokeCell calJokeCellHeight:joke];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AVObject *joke = [self.datasource objectAtIndex:indexPath.row];
    [self pushToDetailWithJoke:joke scrollToComment:NO];
}
#pragma mark - 长按出菜单
-(BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIMenuItem* mi1 = [[UIMenuItem alloc] initWithTitle:@"举报" action:NSSelectorFromString(@"reportJoke:")];
    [[UIMenuController sharedMenuController] setMenuItems:@[mi1]];
    return YES;
}
-(BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    return action == NSSelectorFromString(@"reportJoke:");
}
-(void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if(action == NSSelectorFromString(@"reportJoke:")){
        AVObject *joke = [self.datasource objectAtIndex:indexPath.row];
        ReportController *controller = [[ReportController alloc] initWithStyle:(UITableViewStyleGrouped) subject:joke[@"name"] identity:joke.objectId];
        [self presentViewController:[[JokeNavController alloc] initWithRootViewController:controller] animated:YES completion:nil];
    }
}

-(void)pushToDetailWithJoke:(AVObject*)joke scrollToComment:(BOOL)scrollToComment{
    DetailViewController *detail = [[DetailViewController alloc] initWithStyle:(UITableViewStyleGrouped) joke:joke scrollToComment:scrollToComment];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - JokeCellDelegate
-(void)jokeCell:(JokeCell*)jokeCell joke:(AVObject*)joke supported:(BOOL)supported{
    [self reloadRowAtJoke:joke];
}
-(void)jokeCell:(JokeCell*)jokeCell joke:(AVObject*)joke favorited:(BOOL)favorited{
    [self reloadRowAtJoke:joke];
}
-(void)reloadRowAtJoke:(AVObject*)joke{
    NSUInteger index = [self.datasource indexOfObject:joke];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
}
-(void)jokeCell:(JokeCell *)jokeCell commentButtonTappedOfjoke:(AVObject *)joke{
    [self pushToDetailWithJoke:joke scrollToComment:YES];
}
#pragma mark - radomNo
-(NSNumber*)genRadomNo{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSDate *radomDate = [def objectForKey:@"yycon_radom_date"];
    NSNumber *todayRadomNo = [NSNumber numberWithInt:0];
    NSDate *now = [NSDate date];
    BOOL isSameDay = [now isSameDayWithDate:radomDate];
    if (isSameDay) {
        todayRadomNo = [def objectForKey:@"yycon_today_radom_no"];
        todayRadomNo = [NSNumber numberWithInt:[todayRadomNo intValue]+1];
    }
    [def setValue:now forKey:@"yycon_radom_date"];
    [def setValue:todayRadomNo forKey:@"yycon_today_radom_no"];
    [def synchronize];
    return todayRadomNo;
}
-(NSDate*)genRandomDate{
    //笑话的起始时间是13年5月7号
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    // 设置日期格式
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:@"2013-05-07 00:00:00"];
    int timeIntervalSinceNow = 0 - [date timeIntervalSinceNow]/(24*60*60);
    int r = arc4random_uniform(timeIntervalSinceNow);
    date = [date dateByAddingTimeInterval:r*(24*60*60)];
    DLog(@"random date:%@",date);
    return date;
}

#pragma mark 事件
-(void)doAppDidBecomeActiveNotification:(NSNotification*)notification{
    //版本检查
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSDate *cachedVersionLastCheckDate = [def objectForKey:@"yycon_version_last_check_date"];
    // 当前时间
    NSDate *currentDate = [NSDate date];
    // 比当前时间早一天的时间
    NSDate *earlierDate = [[NSDate alloc] initWithTimeInterval:-24*60*60 sinceDate:currentDate];
    if (cachedVersionLastCheckDate == nil || [cachedVersionLastCheckDate compare:earlierDate] == NSOrderedAscending) {
        [def setValue:currentDate forKey:@"yycon_version_last_check_date"];
        [def synchronize];
        [self checkVersion];
        return;
    }
}
-(void)doAppDidChangeStatusBarOrientationNotification:(NSNotification*)notification{
    [self.tableView reloadData];
}
#pragma mark - check version
-(void)checkVersion{
    [RESTEngine getAppStoreInfoOnSucceeded:^(NSDictionary *dict) {
        NSString *version = [[[dict objectForKey:@"results"] objectAtIndex:0] objectForKey:@"version"];
        DLog(@"app verion on itunes:%@ ,local verion:%@",version,APP_VERSION);
        if ([version floatValue] > [APP_VERSION floatValue]) {
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"笑哈哈有新版本"
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"立即更新",nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            actionSheet.tag = 1;
            [actionSheet showInView:MyAppDelegate.window];
            
        }
    } onError:^(NSError *engineError) {
        
    }];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        NSURL *url = [NSURL URLWithString:APPRATE_ON_ITUNES_URL];
        [[UIApplication sharedApplication] openURL:url];
    }
}
@end
