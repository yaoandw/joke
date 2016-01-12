//
//  RegisterViewController.h
//  joke
//
//  Created by yaoandw on 15/10/9.
//  Copyright © 2015年 yycon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface RegisterViewController : UITableViewController
-(id)initWithLoginName:(NSString*)loginName loginViewController:(LoginViewController*)loginViewController;
@end
