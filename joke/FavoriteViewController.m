//
//  FavoriteViewController.m
//  joke
//
//  Created by yaoandw on 15/10/19.
//  Copyright © 2015年 yycon. All rights reserved.
//

#import "FavoriteViewController.h"
#import "MJRefresh.h"
#import "LeanCloudHelper.h"
#import "JokeCell.h"
#import "DetailViewController.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"
#import "ColorUtil.h"

@interface FavoriteViewController ()
@property(nonatomic,strong)NSMutableArray *datasource;
@property(nonatomic,assign)long page;
@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收藏的笑话";
    
    [self setupLeftMenuButton];
    
    [self doInitDatasource];
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshTable];
    }];
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    
    
    [self.tableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ColorUtil setStyle2ForTableViewController:self];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshTable{
    
    [self doInitDatasource];
}
-(void)reloadTableViewData{
    [self.tableView reloadData];
}
-(void)doInitDatasource{
    self.page = 0;
    [self.refreshControl beginRefreshing];
    [LeanCloudHelper fetchFavoriteJokesByPage:self.page onSuccess:^(NSArray *avComments) {
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
    [LeanCloudHelper fetchFavoriteJokesByPage:self.page++ onSuccess:^(NSArray *avComments) {
        [self.tableView.mj_footer endRefreshing];
        [self.datasource addObjectsFromArray:avComments];
        [self reloadTableViewData];
    } onError:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.view makeToast:[NSString stringWithFormat:@"%@",[[error userInfo] objectForKey:@"error"]] duration:3.0 position:CSToastPositionCenter];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JokeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favorite cell"];
    if (!cell) {
        cell = [[JokeCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"favorite cell"];
    }
    
    // Configure the cell...
    cell.delegate = self;
    // Configure the cell...
    AVObject *joke = [self.datasource objectAtIndex:indexPath.row];
    [cell setJokeCell:joke parentViewController:self];
    //cell.delegate = self;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AVObject *joke = [self.datasource objectAtIndex:indexPath.row];
    return [JokeCell calJokeCellHeight:joke];}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AVObject *joke = [self.datasource objectAtIndex:indexPath.row];
    [self pushToDetailWithJoke:joke scrollToComment:NO];
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
    [self doInitDatasource];
}
-(void)reloadRowAtJoke:(AVObject*)joke{
    NSUInteger index = [self.datasource indexOfObject:joke];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
}
-(void)jokeCell:(JokeCell *)jokeCell commentButtonTappedOfjoke:(AVObject *)joke{
    [self pushToDetailWithJoke:joke scrollToComment:YES];
}

@end
