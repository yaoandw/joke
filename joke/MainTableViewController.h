//
//  MainTableViewController.h
//  joke
//
//  Created by yaoandw on 14-5-7.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshViewController.h"
#import "JokeXmlModel.h"

@interface MainTableViewController : PullToRefreshViewController<UIAlertViewDelegate,UIActionSheetDelegate>
@property(nonatomic,assign)BOOL richJoke;
@end
