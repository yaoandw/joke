//
//  LeftTableViewController.m
//  joke
//
//  Created by yaoandw on 14-5-7.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "LeftTableViewController.h"
#import "MainTableViewController.h"
#import "SettingsTableViewController.h"
#import "SmallImageCell.h"
#import "FileUtil.h"
#import "ReactViewController.h"
#import "ColorUtil.h"
#import "JokeNavController.h"

@interface LeftTableViewController ()
@property(nonatomic,strong)NSArray *datasource;
@property(nonatomic,strong)NSMutableDictionary *userSettings;
@property(nonatomic,strong)UINavigationController *jokeNavController;//笑话nav controller实例
@property(nonatomic,strong)UINavigationController *richJokeNavController;//笑图nav controller实例
@end

@implementation LeftTableViewController

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
    
    self.datasource = @[@"笑话",@"笑图",@"设置",@"React"];
    self.title = @"菜单";
    
    self.tableView.scrollsToTop = NO;
    //设置笑话nav controller实例
    self.jokeNavController = (UINavigationController*)self.mm_drawerController.centerViewController;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [ColorUtil setStyle2ForTableViewController:self];
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
    return [self.datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SmallImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
    if (!cell) {
        cell = [[SmallImageCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"categoryCell"];
    }
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:{
            [cell.imageView setImage:[UIImage imageNamed:@"joke"]];
            break;
        }
        case 1:{
            [cell.imageView setImage:[UIImage imageNamed:@"richJoke"]];
            break;
        }
        case 2:{
            [cell.imageView setImage:[UIImage imageNamed:@"settings"]];
            break;
        }
        default:
            break;
    }
    [cell.textLabel setText:[self.datasource objectAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    [cell.textLabel setTextColor:[[self.userSettings objectForKey:@"nightMode"] boolValue]?fontColor_night:fontColor_day];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            if (!self.jokeNavController) {
                //self.jokeNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"jokeNavController"];
                //MainTableViewController *mainController = self.jokeNavController.viewControllers[0];
                
                MainTableViewController * mainController = [[MainTableViewController alloc] init];
                self.jokeNavController = [[JokeNavController alloc] initWithRootViewController:mainController];
                mainController.richJoke = NO;
            }
            [self.mm_drawerController setCenterViewController:self.jokeNavController withCloseAnimation:YES completion:nil];
            break;
        }
        case 1:{
            if (!self.richJokeNavController) {
                //self.richJokeNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"jokeNavController"];
                //MainTableViewController *mainController = self.richJokeNavController.viewControllers[0];
                
                MainTableViewController * mainController = [[MainTableViewController alloc] init];
                self.richJokeNavController = [[JokeNavController alloc] initWithRootViewController:mainController];
                mainController.richJoke = YES;
            }
            [self.mm_drawerController setCenterViewController:self.richJokeNavController withCloseAnimation:YES completion:nil];
            break;
        }
        case 2:{
            //UINavigationController *settingsNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsNavController"];
            UINavigationController *settingsNavController = [[UINavigationController alloc] initWithRootViewController:[[SettingsTableViewController alloc] init]];
            [self.mm_drawerController setCenterViewController:settingsNavController withCloseAnimation:YES completion:nil];
            break;
        }
        case 3:{
            ReactViewController *reactController = [[ReactViewController alloc] init];
            [self.mm_drawerController setCenterViewController:reactController withCloseAnimation:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
