//
//  LoginViewController.m
//  joke
//
//  Created by yaoandw on 15/8/23.
//  Copyright (c) 2015年 yycon. All rights reserved.
//

#import "LoginViewController.h"
#import "ColorUtil.h"
#import "SmsCodeLoginController.h"
#import "RegisterViewController.h"
#import "UIView+Toast.h"

@interface LoginViewController ()
@property(nonatomic,strong)UITextField *loginName;
@property(nonatomic,strong)UITextField *loginPwd;
@end

@implementation LoginViewController

-(id)initWithDelegate:(id)delegate{
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSQQ withAppKey:@"1101718393" andAppSecret:@"mbOVaQE9d5YhR3bB" andRedirectURI:nil];
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSWeiXin withAppKey:@"wx7a6709b4f6733a36" andAppSecret:@"86d8b8740aba62caa7c0fa09a7e2a888" andRedirectURI:nil];
    [AVOSCloudSNS setupPlatform:(AVOSCloudSNSSinaWeibo) withAppKey:@"3390995424" andAppSecret:@"3f554d35c529d8852ab4d7a9905119a2" andRedirectURI:@""];
    
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, 1)];
    [line1 setBackgroundColor:border_color_day];
    [self.view addSubview:line1];
    
    self.loginName = [[UITextField alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 40)];
    [self.loginName setPlaceholder:@"手机号"];
    [self.loginName setLeftViewMode:(UITextFieldViewModeAlways)];
    [self.loginName setKeyboardType:(UIKeyboardTypeNumberPad)];
    UIImageView *nameLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_user"]];
    [nameLeftView setFrame:CGRectMake(0, 0, 40, 40)];
    [nameLeftView setContentMode:(UIViewContentModeCenter)];
    [self.loginName setLeftView:nameLeftView];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 1)];
    [line2 setBackgroundColor:border_color_day];
    [self.view addSubview:line2];
    
    self.loginPwd = [[UITextField alloc] initWithFrame:CGRectMake(0, 121, self.view.frame.size.width, 40)];
    [self.loginPwd setPlaceholder:@"登录密码"];
    [self.loginPwd setLeftViewMode:(UITextFieldViewModeAlways)];
    [self.loginPwd setSecureTextEntry:YES];
    UIImageView *pwdLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pwd"]];
    [pwdLeftView setFrame:CGRectMake(0, 0, 40, 40)];
    [pwdLeftView setContentMode:(UIViewContentModeCenter)];
    [self.loginPwd setLeftView:pwdLeftView];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 161, self.view.frame.size.width, 1)];
    [line3 setBackgroundColor:border_color_day];
    [self.view addSubview:line3];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 180, self.view.frame.size.width-20, 40)];
    [loginButton setTitle:@"登录" forState:(UIControlStateNormal)];
    [loginButton setBackgroundColor:[UIColor colorWithRed:29/255.0f green:173/255.0f blue:234/255.0f alpha:1.0f]];
    [loginButton addTarget:self action:@selector(loginButtonTapped:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:self.loginName];
    [self.view addSubview:self.loginPwd];
    [self.view addSubview:loginButton];
    
    //sms code login
    UIButton *smsCodeLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 240, 150, 40)];
    [smsCodeLoginButton setTitle:@"手机验证码登录" forState:(UIControlStateNormal)];
    [smsCodeLoginButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [smsCodeLoginButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [smsCodeLoginButton.titleLabel setTextAlignment:(NSTextAlignmentCenter)];
    [smsCodeLoginButton addTarget:self action:@selector(smsCodeLoginButtonTapped:) forControlEvents:(UIControlEventTouchUpInside)];
    //[self.view addSubview:smsCodeLoginButton];
    
    //register button
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-170), 240, 150, 40)];
    [registerButton setTitle:@"快速注册" forState:(UIControlStateNormal)];
    [registerButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [registerButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    [registerButton.titleLabel setTextAlignment:(NSTextAlignmentCenter)];
    [registerButton addTarget:self action:@selector(registerButtonTapped:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:registerButton];
    
    //third way login
    
    UIView *thirdIView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, self.view.frame.size.height-100, 200, 80)];
    [self.view addSubview:thirdIView];
    //weibo
    UIView *weiboView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 40, 70)];
    [weiboView setUserInteractionEnabled:YES];
    [weiboView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weiboLogin:)]];
    if ([AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSSinaWeibo])
        [thirdIView addSubview:weiboView];
    
    UIImageView *weiboImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [weiboImageView setImage:[UIImage imageNamed:@"login_weibo"]];
    weiboImageView.layer.cornerRadius = 5.0;
    weiboImageView.layer.masksToBounds = YES;
    [weiboView addSubview:weiboImageView];
    
    UILabel *weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(-5, 45, 50, 25)];
    [weiboLabel setText:@"新浪微博"];
    [weiboLabel setFont:[UIFont systemFontOfSize:12]];
    [weiboLabel setTextAlignment:(NSTextAlignmentCenter)];
    [weiboView addSubview:weiboLabel];
    //qq
    UIView *qqView = [[UIView alloc] initWithFrame:CGRectMake(150, 0, 40, 70)];
    [qqView setUserInteractionEnabled:YES];
    [qqView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qzoneLogin:)]];
    if ([AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSQQ])
        [thirdIView addSubview:qqView];
    
    UIImageView *qqImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [qqImageView setImage:[UIImage imageNamed:@"login_qq"]];
    qqImageView.layer.cornerRadius = 5.0;
    qqImageView.layer.masksToBounds = YES;
    [qqView addSubview:qqImageView];
    
    UILabel *qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(-5, 45, 50, 25)];
    [qqLabel setText:@"腾讯QQ"];
    [qqLabel setFont:[UIFont systemFontOfSize:12]];
    [qqLabel setTextAlignment:(NSTextAlignmentCenter)];
    [qqView addSubview:qqLabel];
    
    [self setUpLeftButton];
#ifdef DEBUG
    [self.loginName setText:@"18616606925"];
    [self.loginPwd setText:@"qqqqqq"];
#endif
}

-(void)setUpLeftButton{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleBordered) target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}
-(void)cancelButtonTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)smsCodeLoginButtonTapped:(UIButton*)btn{
    SmsCodeLoginController *smsCodeLoginController = [[SmsCodeLoginController alloc] initWithLoginName:self.loginName.text loginViewController:self];
    [self.navigationController pushViewController:smsCodeLoginController animated:YES];
}

-(void)registerButtonTapped:(UIButton*)btn{
    RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithLoginName:self.loginName.text loginViewController:self];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

-(void)loginButtonTapped:(UIButton*)btn{
    if (self.loginName.text.length <= 0) {
        [self.view makeToast:@"请输入用户名" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    if (self.loginPwd.text.length <= 0) {
        [self.view makeToast:@"请输入密码" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    [AVUser logInWithMobilePhoneNumberInBackground:self.loginName.text password:self.loginPwd.text block:^(AVUser *user, NSError *error) {
        if (!error) {
            [self loginSucceedWithUser:user authData:nil];
        }else{
            [self.view makeToast:[NSString stringWithFormat:@"%@",[[error userInfo] objectForKey:@"error"]] duration:3.0 position:CSToastPositionCenter];
        }
    }];
}

- (void)weixinLogin:(id)sender {
    if ([AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSWeiXin]) {
        // 请到真机测试
        [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
            
            NSLog(@"object : %@ error:%@", object, error);
            if ([self filterError:error]) {
                [AVUser loginWithAuthData:object platform:AVOSCloudSNSPlatformWeiXin block:^(AVUser *user, NSError *error) {
                    if ([self filterError:error]) {
                        [self loginSucceedWithUser:user authData:object];
                    }
                }];
            }
        } toPlatform:AVOSCloudSNSWeiXin];
    } else {
        [self alert:@"没有安装微信，暂不能登录"];
    }
}

- (void)weiboLogin:(id)sender {
    if ([AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSSinaWeibo]) {
//         请到真机测试
        [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
            NSLog(@"object : %@ error:%@", object, error);
            if ([self filterError:error]) {
                [AVUser loginWithAuthData:object platform:AVOSCloudSNSPlatformWeiBo block:^(AVUser *user, NSError *error) {
                    if ([self filterError:error]) {
                        [self loginSucceedWithUser:user authData:object];
                    }
                }];
            }
            
        } toPlatform:AVOSCloudSNSSinaWeibo];
    } else {
        [self alert:@"没有安装微博，暂不能登录"];
    }
}

- (void)qzoneLogin:(id)sender {
    // 如果安装了QQ，则跳转至应用，否则跳转至网页
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        if (error) {
            NSLog(@"failed to get authentication from weibo. error: %@", error.description);
        } else {
            //NSString *accessToken = object[@"access_token"];
            NSString *username = object[@"username"];
            NSString *avatar = object[@"avatar"];
            //NSDictionary *rawUser = object[@"raw-user"]; // 性别等第三方平台返回的用户信息
            //...
            [AVUser loginWithAuthData:object platform:AVOSCloudSNSPlatformQQ block:^(AVUser *user, NSError *error) {
                if ([self filterError:error]) {
                    user[@"nickname"] = username;
                    user[@"avatar"] = avatar;
                    [self loginSucceedWithUser:user authData:object];
                }
            }];
        }
    } toPlatform:AVOSCloudSNSQQ];
}

- (void)alert:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (BOOL)filterError:(NSError *)error {
    if (error) {
        [self alert:[error localizedDescription]];
        return NO;
    }
    return YES;
}

- (void)loginSucceedWithUser:(AVUser *)user authData:(NSDictionary *)authData{
    MyAppDelegate.hasLoginedWhenRunning = YES;
    if ([self.delegate respondsToSelector:@selector(loginSucceedWithUser:authData:)]) {
        [self.delegate loginSucceedWithUser:user authData:authData];
    }
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
