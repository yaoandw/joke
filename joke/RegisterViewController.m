//
//  RegisterViewController.m
//  joke
//
//  Created by yaoandw on 15/10/9.
//  Copyright © 2015年 yycon. All rights reserved.
//

#import "RegisterViewController.h"
#import "AVUser.h"
#import "UIView+Toast.h"

@interface RegisterViewController ()
@property(nonatomic,strong)NSString *loginName;
@property(nonatomic,strong)LoginViewController*loginViewController;
@property(nonatomic,strong)NSMutableArray *datasource;

@property(nonatomic,strong)UITextField *loginNameTextField;
@property(nonatomic,strong)UITextField *snsCodeTextField;
@property(nonatomic,strong)UITextField *passwordTextField;
@end

@implementation RegisterViewController

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
    self.title = @"注册";
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
    
    UIButton *nameRightView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [nameRightView setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [nameRightView setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    nameRightView.titleLabel.font = [UIFont systemFontOfSize:13];
    [nameRightView addTarget:self action:@selector(sendSnsCodeButtonTapped:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.loginNameTextField setRightView:nameRightView];
    
    [loginView addSubview:self.loginNameTextField];
    
    return loginView;
}

-(UIView*)doInitSnsCodeView{
    UIView *snsCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.snsCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 2, self.view.frame.size.width, 40)];
    [self.snsCodeTextField setPlaceholder:@"验证码"];
    [self.snsCodeTextField setLeftViewMode:(UITextFieldViewModeAlways)];
    [self.snsCodeTextField setRightViewMode:(UITextFieldViewModeAlways)];
    [self.snsCodeTextField setKeyboardType:(UIKeyboardTypeNumberPad)];
    UIImageView *nameLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_snscode"]];
    [nameLeftView setFrame:CGRectMake(0, 0, 40, 40)];
    [nameLeftView setContentMode:(UIViewContentModeCenter)];
    [self.snsCodeTextField setLeftView:nameLeftView];
    
    UIButton *nameRightView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [nameRightView setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [nameRightView setTitle:@"确定" forState:(UIControlStateNormal)];
    nameRightView.titleLabel.font = [UIFont systemFontOfSize:13];
    [nameRightView addTarget:self action:@selector(validSnsCodeButtonTapped:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.snsCodeTextField setRightView:nameRightView];
    
    [snsCodeView addSubview:self.snsCodeTextField];
    
    return snsCodeView;
}

-(UIView*)doInitPasswordView{
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 2, self.view.frame.size.width, 40)];
    [self.passwordTextField setPlaceholder:@"密码"];
    [self.passwordTextField setLeftViewMode:(UITextFieldViewModeAlways)];
    [self.passwordTextField setSecureTextEntry:YES];
    UIImageView *nameLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pwd"]];
    [nameLeftView setFrame:CGRectMake(0, 0, 40, 40)];
    [nameLeftView setContentMode:(UIViewContentModeCenter)];
    [self.passwordTextField setLeftView:nameLeftView];
    
    [passwordView addSubview:self.passwordTextField];
    
    return passwordView;
}

-(UIView*)doInitRegisterButtonView{
    UIView *registerButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 2, self.view.frame.size.width-20, 40)];
    [registerButton addTarget:self action:@selector(registerButtonTapped:) forControlEvents:(UIControlEventTouchUpInside)];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registerCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"registerCell"];
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
    
    AVUser *user = [AVUser user];
    user.username = self.loginNameTextField.text;
    user.password =  @"123456";
    user.mobilePhoneNumber = self.loginNameTextField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.loginNameTextField.enabled = YES;
        if (succeeded) {
            [self.datasource addObject:[self doInitSnsCodeView]];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"%@",[[error userInfo] objectForKey:@"error"]] duration:3.0 position:CSToastPositionCenter];
        }
    }];
}

-(void)validSnsCodeButtonTapped:(UIButton*)btn{
    if (self.snsCodeTextField.text.length <= 0) {
        [self.view makeToast:@"请输入验证码" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    
    [AVUser verifyMobilePhone:self.snsCodeTextField.text withBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.datasource addObject:[self doInitPasswordView]];
            [self.datasource addObject:[self doInitRegisterButtonView]];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0],[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"%@",[[error userInfo] objectForKey:@"error"]] duration:3.0 position:CSToastPositionCenter];
        }
    }];
}

-(void)registerButtonTapped:(UIButton*)btn{
    
    if (self.passwordTextField.text.length <= 0) {
        [self.view makeToast:@"请输入密码" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    
    [AVUser logInWithUsernameInBackground:self.loginNameTextField.text password:@"123456" block:^(AVUser *user, NSError *error) {
        if (!error) {
            [[AVUser currentUser] updatePassword:@"123456" newPassword:self.passwordTextField.text block:^(id object, NSError *error) {
                //处理结果
                if (!error) {
                    [AVUser logInWithUsernameInBackground:self.loginNameTextField.text password:self.passwordTextField.text block:^(AVUser *user, NSError *error) {
                        if (!error) {
                            if ([self.loginViewController.delegate respondsToSelector:@selector(loginSucceedWithUser:authData:)]) {
                                [self.loginViewController.delegate loginSucceedWithUser:user authData:nil];
                            }else{
                                [self.view makeToast:@"注册成功" duration:3.0 position:CSToastPositionCenter];
                            }
                        }else{
                            [self.view makeToast:[NSString stringWithFormat:@"%@",[[error userInfo] objectForKey:@"error"]] duration:3.0 position:CSToastPositionCenter];
                        }
                    }];
                    
                }else{
                    [self.view makeToast:[NSString stringWithFormat:@"%@",[[error userInfo] objectForKey:@"error"]] duration:3.0 position:CSToastPositionCenter];
                }
            }];
        }else{
            [self.view makeToast:[NSString stringWithFormat:@"%@",[[error userInfo] objectForKey:@"error"]] duration:3.0 position:CSToastPositionCenter];
        }
    }];
    
}

@end
