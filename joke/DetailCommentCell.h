//
//  DetailCell.h
//  joke
//
//  Created by yaoandw on 15/10/11.
//  Copyright © 2015年 yycon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVObject.h"
#import "AVUser.h"
#import "AppDelegate.h"

@interface DetailCommentCell : UITableViewCell
-(void)setDataWithComment:(AVObject*)comment;
+(CGFloat)calHeightWithComment:(AVObject*)comment;
@end
