//
//  MainTableViewController.m
//  joke
//
//  Created by yaoandw on 14-5-7.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "MainTableViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
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

@interface MainTableViewController ()
@property(nonatomic,strong)NSMutableArray *datasource;
@property(nonatomic,assign)NSInteger startPage;
@property(nonatomic,strong)UISegmentedControl *segmentControl;
@property(nonatomic,strong)NSMutableDictionary *userSettings;
//radom
@property(nonatomic,assign)NSInteger rdStartPage;

@property(nonatomic,assign)BOOL radom;
@property(nonatomic,strong)NSNumber *todayRadomNo;
@property(nonatomic,strong)NSDate *randomDate;

@property(nonatomic,strong)NSString* timestamp;
@property(nonatomic,strong)NSString* rdTimestamp;

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
    JokeXmlModel *xml = [self getCachedJokeXmlModel];
    self.datasource = [NSMutableArray arrayWithArray:xml.jokeArray];
    self.timestamp = xml.timestamp;
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
    if (self.radom) {//下拉刷新,更新随机数
        self.todayRadomNo = [self genRadomNo];
    }
    self.currentOperation = [RESTEngine fetchJokesWithType:self.richJoke?joke_type_image:joke_type_text page:@"0" random:self.radom radomNo:self.todayRadomNo timestamp:nil onSuccessed:^(JokeXmlModel* xmlModel) {
        NSArray *resultArray = xmlModel.jokeArray;
        DLog(@"jokeArray count:%d",[resultArray count]);
        self.loading = NO;
        if (resultArray && [resultArray count] > 0) {
            self.datasource = [NSMutableArray arrayWithArray:resultArray];
            self.radom?(self.rdStartPage = 1):(self.startPage = 1);
            self.endReached = NO;
            [self cacheJokes:xmlModel];
        }else{
            self.endReached = YES;
        }
        [self reloadTableData];
    } onError:^(NSError *engineError) {
        self.loading = NO;
        [UIAlertView showWithError:engineError];
    }];
    //
    if (self.radom) {//下拉刷新,更新随机数
        self.randomDate = [self genRandomDate];
    }
    [LeanCloudHelper fetchAVJokesByPage:0 jokeType:self.richJoke?avjoke_type_image:avjoke_type_text randomTime:self.randomDate onSuccess:^(NSArray *avJokes, NSArray *supportedJokes, NSArray *favoritedJokes) {
        //DLog(@"avJokes=%@,supportedJokes=%@,favoritedJokes=%@",avJokes,supportedJokes,favoritedJokes);
        //self.datasource = [NSMutableArray arrayWithArray:avJokes];
        //self.radom?(self.rdStartPage = 1):(self.startPage = 1);
        //self.endReached = NO;
    } onError:^(NSError *error) {
        //self.loading = NO;
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
        if (self.radom && !self.todayRadomNo) {//如果没有随机数,生成一个
            self.todayRadomNo = [self genRadomNo];
        }
        JokeXmlModel *xml = [self getCachedJokeXmlModel];
        self.timestamp = xml.timestamp;
        self.currentOperation = [RESTEngine fetchJokesWithType:self.richJoke?joke_type_image:joke_type_text page:[NSString stringWithFormat:@"%i", nowStartPage] random:self.radom radomNo:self.todayRadomNo timestamp:self.timestamp onSuccessed:^(JokeXmlModel* xmlModel) {
            NSArray *resultArray = xmlModel.jokeArray;
            DLog(@"jokeArray count:%d",[resultArray count]);
            if (resultArray && [resultArray count] > 0) {
                [self.datasource addObjectsFromArray:resultArray];
                self.radom?(self.rdStartPage++):(self.startPage ++);
                self.endReached = NO;
                [self cacheJokes:xmlModel];
            }else{
                self.endReached = YES;
            }
            [self reloadTableData];
        } onError:^(NSError *engineError) {
            [UIAlertView showWithError:engineError];
        }];
    }else{
        self.endReached = YES;
    }
}
-(JokeXmlModel*)getCachedJokeXmlModel{
    return self.richJoke?(self.radom?[AppCache getCachedRadomRichJokes]:[AppCache getCachedLastestRichJokes]):(self.radom?[AppCache getCachedRadomJokes]:[AppCache getCachedLastestJokes]);
}
-(void)cacheJokes:(JokeXmlModel*)xmlModel{
    JokeXmlModel *xml = [[JokeXmlModel alloc] init];
    xml.jokeArray = self.datasource;
    xml.timestamp = xmlModel.timestamp?xmlModel.timestamp:self.timestamp;
    self.richJoke?(self.radom?[AppCache cacheRadomRichJokes:xml]:[AppCache cacheLastestRichJokes:xml]):(self.radom?[AppCache cacheRadomJokes:xml]:[AppCache cacheLastestJokes:xml]);
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
    int index = segmentedControl.selectedSegmentIndex;
    NSLog(@"select index:%d",index);
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
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}
#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
    
    // Configure the cell...
    Joke *joke = [self.datasource objectAtIndex:indexPath.row];
    [cell setJokeCell:joke parentViewController:self];
    //cell.delegate = self;
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == self.numberOfSections)  {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    Joke *joke = [self.datasource objectAtIndex:indexPath.row];
    return [JokeCell calJokeCellHeight:joke parentViewController: self];
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
