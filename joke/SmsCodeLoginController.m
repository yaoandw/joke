//
//  SmsCodeLoginController.m
//  joke
//
//  Created by yaoandw on 15/10/5.
//  Copyright © 2015年 yycon. All rights reserved.
//

#import "SmsCodeLoginController.h"
#import "UIView+Toast.h"

@interface SmsCodeLoginController ()
@property(nonatomic,strong)NSString *loginName;
@property(nonatomic,strong)LoginViewController*loginViewController;
@property(nonatomic,strong)NSMutableArray *datasource;

@property(nonatomic,strong)UITextField *loginNameTextField;
@property(nonatomic,strong)UITextField *smsCodeTextField;
@end

@implementation SmsCodeLoginController

-(id)initWithLoginName:(NSString*)loginName loginViewController:(LoginViewController*)loginViewController{
    self = [self init];
    if (self) {
        self.loginName = loginName;
        self.loginViewController = loginViewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"验证码登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self doInitDatasource];
    [self.tableView reloadData];
}

-(void)doInitDatasource{
    self.datasource = [NSMutableArray array];
    [self.datasource addObject:[self doInitLoginNameView]];
}

-(UIView*)doInitLoginNameView{
    UIView *loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.loginNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 2, self.view.frame.size.width, 40)];
    [self.loginNameTextField setPlaceholder:@"手机号"];
    [self.loginNameTextField setLeftViewMode:(UITextFieldViewModeAlways)];
    [self.loginNameTextField setRightViewMode:(UITextFieldViewModeAlways)];
    [self.loginNameTextField setKeyboardType:(UIKeyboardTypeNumberPad)];
    UIImageView *nameLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_user"]];
    [nameLeftView setFrame:CGRectMake(0, 0, 40, 40)];
    [nameLeftView setContentMode:(UIViewContentModeCenter)];
    [self.loginNameTextField setLeftView:nameLeftView];
    
    UIButton *nameRightView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [nameRightView setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [nameRightView setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [nameRightView addTarget:self action:@selector(sendSnsCodeButtonTapped:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.loginNameTextField setRightView:nameRightView];
    
    [loginView addSubview:self.loginNameTextField];
    
    return loginView;
}

-(UIView*)doInitSmsCodeView{
    UIView *snsCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.smsCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 2, self.view.frame.size.width, 40)];
    [self.smsCodeTextField setPlaceholder:@"验证码"];
    [self.smsCodeTextField setLeftViewMode:(UITextFieldViewModeAlways)];
    [self.smsCodeTextField setKeyboardType:(UIKeyboardTypeNumberPad)];
    UIImageView *nameLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_snscode"]];
    [nameLeftView setFrame:CGRectMake(0, 0, 40, 40)];
    [nameLeftView setContentMode:(UIViewContentModeCenter)];
    [self.smsCodeTextField setLeftView:nameLeftView];
    
    [snsCodeView addSubview:self.smsCodeTextField];
    
    return snsCodeView;
}

-(UIView*)doInitLoginButtonView{
    UIView *registerButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 2, self.view.frame.size.width-20, 40)];
    [registerButton addTarget:self action:@selector(loginButtonTapped:) forControlEvents:(UIControlEventTouchUpInside)];
    [registerButton setTitle:@"注册" forState:(UIControlStateNormal)];
    [registerButton setBackgroundColor:[UIColor colorWithRed:29/255.0f green:173/255.0f blue:234/255.0f alpha:1.0f]];
    
    [registerButtonView addSubview:registerButton];
    
    return registerButtonView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.datasource count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"smsloginCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"smsloginCell"];
    }
    
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIView *view = [self.datasource objectAtIndex:indexPath.row];
    [cell addSubview:view];
    
    return cell;
}

#pragma mark - button actions
-(void)sendSnsCodeButtonTapped:(UIButton*)btn{
    if (self.loginNameTextField.text.length <= 0) {
        [self.view makeToast:@"请输入手机号" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    
    self.loginNameTextField.enabled = NO;
    
    [AVUser requestLoginSmsCode:self.loginNameTextField.text withBlock:^(BOOL succeeded, NSError *error) {
        self.loginNameTextField.enabled = YES;
        if (succeeded) {
            [self.datasource addObject:[self doInitSmsCodeView]];
            [self.datasource addObject:[self doInitLoginButtonView]];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"%@",[[error userInfo] objectForKey:@"error"]] duration:3.0 position:CSToastPositionCenter];
        }
    }];
    
}

-(void)loginButtonTapped:(UIButton*)btn{
    
    if (self.smsCodeTextField.text.length <= 0) {
        [self.view makeToast:@"请输入验证码" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    
    [AVUser logInWithMobilePhoneNumberInBackground:self.loginNameTextField.text smsCode:self.smsCodeTextField.text block:^(AVUser *user, NSError *error) {
        if (!error) {
            if ([self.loginViewController.delegate respondsToSelector:@selector(loginSucceedWithUser:authData:)]) {
                [self.loginViewController.delegate loginSucceedWithUser:user authData:nil];
            }else{
                [self.view makeToast:@"登录成功" duration:3.0 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[NSString stringWithFormat:@"%@",[[error userInfo] objectForKey:@"error"]] duration:3.0 position:CSToastPositionCenter];
        }
    }];
}

@end
