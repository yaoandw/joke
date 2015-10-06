//
//  LoginHelper.m
//  joke
//
//  Created by yaoandw on 15/8/25.
//  Copyright (c) 2015年 yycon. All rights reserved.
//

#import "LoginHelper.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginHelper()
@property(nonatomic,copy)AVUserBlock userBlock;
@end

@implementation LoginHelper
static id instance;
+(id)getInstance{
    if (!instance) {
        instance = [[LoginHelper alloc] init];
    }
    return instance;
}

-(void)loginWithBlock:(AVUserBlock) block{
    self.userBlock = block;
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser) {
        self.userBlock(currentUser);
    }else {
        LoginViewController *loginCtr = [[LoginViewController alloc] initWithDelegate:self];
        [MyAppDelegate.window.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:loginCtr] animated:YES completion:nil];
    }
}
#pragma mark - LoginViewControllerDelegate
- (void)loginSucceedWithUser:(AVUser *)user authData:(NSDictionary *)authData{
    [MyAppDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    self.userBlock(user);
}
@end
