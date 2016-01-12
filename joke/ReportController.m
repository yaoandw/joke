//
//  ReportController.m
//  joke
//
//  Created by yaoandw on 16/1/1.
//  Copyright © 2016年 yycon. All rights reserved.
//

#import "ReportController.h"
#import "LeanCloudHelper.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"

@interface ReportController ()
@property(nonatomic,strong)NSString *subject;
@property(nonatomic,strong)NSString *identity;
@property(nonatomic,strong)NSArray *datasource;
@end

@implementation ReportController
-(id)initWithStyle:(UITableViewStyle)style subject:(NSString*)subject identity:(NSString*)identity{
    self = [super initWithStyle:style];
    if (self) {
        self.subject = subject;
        self.identity = identity;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setEditing:YES animated:YES];
    [self.tableView setAllowsMultipleSelectionDuringEditing:YES];
    
    self.title = @"举报";
    self.datasource = @[@"色情",@"谣言",@"恶意营销",@"诱导分享",@"侮辱诋毁"];
    
    [self.tableView reloadData];
    
    [self setUpLeftBarItem];
    [self setUpRightBarItem];
}

-(void)setUpLeftBarItem{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftButtonTapped:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}
-(void)leftButtonTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setUpRightBarItem{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightButtonTapped:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
}
-(void)rightButtonTapped:(id)sender{
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    if ([selectedRows count] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请选择举报原因"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要举报吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *title = [NSString stringWithFormat:@"[%@]%@-%@",@"举报",self.subject,self.identity];
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        NSString *content = [self.datasource objectAtIndex:((NSIndexPath*)selectedRows[0]).row];
        
        [LeanCloudHelper saveReportWithTitle:title content:content onSuccess:^{
            [MyAppDelegate.window makeToast:@"提交成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        } onError:^(NSError *error) {
            [self.view makeToast:@"提交失败"];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.datasource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"reportCell"];
    }
    
    // Configure the cell...
    [cell.textLabel setText:[self.datasource objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (int i = 0; i<[self.datasource count];i++) {
        if (i != indexPath.row) {
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
        }
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"请选择举报原因";
}

@end
