//
//  DetailTableViewController.h
//  joke
//
//  Created by yaoandw on 15/10/11.
//  Copyright © 2015年 yycon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVObject.h"

@interface DetailViewController : UITableViewController
-(id)initWithStyle:(UITableViewStyle)style joke:(AVObject*)joke scrollToComment:(BOOL)scrollToComment;
@end
