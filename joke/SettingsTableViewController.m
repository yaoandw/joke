//
//  SettingsTableViewController.m
//  joke
//
//  Created by yaoandw on 14-5-12.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "SmallImageCell.h"
#import "FileUtil.h"
#import <AVOSCloud/AVUser.h>
#import "ColorUtil.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    [self setupLeftMenuButton];
    
    NSMutableDictionary *userSettings = [FileUtil getUserSettings];
    self.view.backgroundColor = [[userSettings objectForKey:@"nightMode"] boolValue]?bgColor_night:viewBackgroundColor;
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"settingsCell";
    SmallImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[SmallImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSMutableDictionary *userSettings = [FileUtil getUserSettings];
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                [cell.imageView setImage:[UIImage imageNamed:@"dayNight"]];
                [cell.textLabel setText:@"夜间模式"];
                UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                switchView.tag = 0;
                cell.accessoryView = switchView;
                [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                if ([[userSettings objectForKey:@"nightMode"] boolValue]) {
                    [switchView setOn:YES];
                }else{
                    [switchView setOn:NO];
                }
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }else if (indexPath.row == 1){
                [cell.imageView setImage:[UIImage imageNamed:@"clearCache"]];
                [cell.textLabel setText:@"点击清除缓存"];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }else if (indexPath.row == 2){
                [cell.imageView setImage:[UIImage imageNamed:@"rate"]];
                [cell.textLabel setText:@"去评分"];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }else if (indexPath.row == 3){
                [cell.imageView setImage:[UIImage imageNamed:@"donate"]];
                [cell.textLabel setText:@"捐赠"];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            break;
        }
        case 1:{
            [cell.textLabel setText:@"退出登录"];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            break;
        }
        default:
            break;
    }
    
    
    //cell.delegate = self;
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[[userSettings objectForKey:@"nightMode"] boolValue]?fontColor_night:fontColor_day];
    return cell;
}

-(void)switchChanged:(UISwitch*)switchView{
    NSMutableDictionary *settings = [FileUtil getUserSettings];
    switch (switchView.tag) {
        case 0:{
            [settings setObject:[NSNumber numberWithBool:switchView.on] forKey:@"nightMode"];
            [FileUtil saveUserSettings:settings];
            
            [ColorUtil setStyle2ForTableViewController:self];
            
            [self.tableView reloadData];
            break;
        }
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 1) {
                UIAlertView *cacheAlert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要清除缓存么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                cacheAlert.alertViewStyle = UIAlertViewStyleDefault;
                [cacheAlert show];
            }else if (indexPath.row == 2){
                NSURL *url = [NSURL URLWithString:APPRATE_ON_ITUNES_URL];
                [[UIApplication sharedApplication] openURL:url];
            }else if (indexPath.row == 3){
                [self performSegueWithIdentifier:@"donate segue" sender:self];
            }
            break;
        }
        case 1:{
            [AVUser logOut];
            [[[UIAlertView alloc] initWithTitle:nil message:@"退出登录成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            break;
        }
        default:
            break;
    }
    
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [FileUtil clearCache];
    }
}
@end
