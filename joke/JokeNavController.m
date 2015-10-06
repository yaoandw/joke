//
//  JokeNavController.m
//  joke
//
//  Created by yaoandw on 14-6-12.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "JokeNavController.h"

@interface JokeNavController ()

@end

@implementation JokeNavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*设置JokeNavController为单例，这样点击侧边栏的时候不会每次都创建一个实例*/
/*static id s_singleton = nil;
+ (id) alloc {
    if(s_singleton != nil)
        return s_singleton;
    return [super alloc];
}
- (id) initWithCoder:(NSCoder *)aDecoder {
    if(s_singleton != nil)
        return s_singleton;
    self = [super initWithCoder:aDecoder];
    if(self) {
        s_singleton = self;
    }
    return self;
}*/
/* end singletion */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
