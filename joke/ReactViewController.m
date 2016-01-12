//
//  ReactViewController.m
//  joke
//
//  Created by yaoandw on 15/8/21.
//  Copyright (c) 2015年 yycon. All rights reserved.
//

#import "ReactViewController.h"
#import "ReactView.h"
#import "Game2048ViewController.h"

@interface ReactViewController ()
@property(nonatomic,strong)NSArray *datasource;
@end

@implementation ReactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    ReactView *view = [[ReactView alloc] initWithFrame:self.view.bounds];
//    self.view = view;
    self.title = @"游戏";
}

-(void)doInitDatasource{
    self.datasource = @[@"2048"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.datasource count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"react cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"react cell"];
    }
    [cell.textLabel setText:[self.datasource objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            Game2048ViewController *target = [[Game2048ViewController alloc] init];
            [self.navigationController pushViewController:target animated:YES];
            break;
        }
        default:
            break;
    }
}
@end
