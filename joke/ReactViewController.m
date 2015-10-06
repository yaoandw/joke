//
//  ReactViewController.m
//  joke
//
//  Created by yaoandw on 15/8/21.
//  Copyright (c) 2015年 yycon. All rights reserved.
//

#import "ReactViewController.h"
#import "ReactView.h"

@interface ReactViewController ()

@end

@implementation ReactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ReactView *view = [[ReactView alloc] initWithFrame:self.view.bounds];
    self.view = view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
