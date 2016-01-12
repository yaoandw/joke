//
//  MainViewController.m
//  joke
//
//  Created by yaoandw on 16/1/1.
//  Copyright © 2016年 yycon. All rights reserved.
//

#import "MainViewController.h"
#import "LeftTableViewController.h"
#import "JokeNavController.h"

@interface MainViewController ()
@property(nonatomic,strong)UIViewController *leftViewController;

@end

@implementation MainViewController

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self setUpLeftView];
    }
    return self;
}

-(void)setUpLeftView{
    //    self.gesturesCancelsTouchesInView = NO;
    self.leftViewController =[[JokeNavController alloc] initWithRootViewController:[[LeftTableViewController alloc] initWithStyle:(UITableViewStyleGrouped)]];
    
    [self setLeftViewEnabledWithWidth:150.0f presentationStyle:(LGSideMenuPresentationStyleSlideBelow) alwaysVisibleOptions:(LGSideMenuAlwaysVisibleOnNone)];
    self.leftViewStatusBarStyle = UIStatusBarStyleDefault;
    self.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnAll;
    
    [self.leftView addSubview:self.leftViewController.view];
}

//- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size{
//    [super rightViewWillLayoutSubviewsWithSize:size];
//    
//    self.rightViewController.view.frame = CGRectMake(0.f , -20.f, size.width, size.height);
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
