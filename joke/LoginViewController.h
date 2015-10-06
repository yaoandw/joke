//
//  LoginViewController.h
//  joke
//
//  Created by yaoandw on 15/8/23.
//  Copyright (c) 2015年 yycon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LeanCloudSocial/AVOSCloudSNS.h>
#import <LeanCloudSocial/AVUser+SNS.h>

@class LoginViewController;
@protocol LoginViewControllerDelegate <NSObject>

- (void)loginSucceedWithUser:(AVUser *)user authData:(NSDictionary *)authData;

@end

@interface LoginViewController : UIViewController
@property(nonatomic,assign)id<LoginViewControllerDelegate> delegate;

-(id)initWithDelegate:(id)delegate;
@end
