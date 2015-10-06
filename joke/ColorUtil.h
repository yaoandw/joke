//
//  ColorUtil.h
//  joke
//
//  Created by yaoandw on 14-5-15.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

#define viewBackgroundColor [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1.0f]

//#define bgColor_day [UIColor colorWithRed:152/255.0f green:152/255.0f blue:152/255.0f alpha:1.0f]
#define bgColor_day [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1.0f]
#define bgColor_night [UIColor blackColor]

#define panelBgColor_day [UIColor whiteColor]
#define panelBgColor_night [UIColor colorWithRed:12/255.0f green:12/255.0f blue:12/255.0f alpha:1.0f]

#define fontColor_day [UIColor colorWithRed:35/255.0f green:30/255.0f blue:23/255.0f alpha:1.0f]
#define fontColor_night [UIColor colorWithRed:90/255.0f green:90/255.0f blue:90/255.0f alpha:1.0f]

#define fontAssistColor_day [UIColor colorWithRed:102/255.0f green:94/255.0f blue:94/255.0f alpha:1.0f]
#define fontAssistColor_night [UIColor colorWithRed:136/255.0f green:136/255.0f blue:136/255.0f alpha:1.0f]

#define nvColor_day [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0f]
#define nvColor_night [UIColor colorWithRed:30/255.0f green:30/255.0f blue:30/255.0f alpha:1.0f]

#define border_color_day [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f]
#define border_color_night [UIColor colorWithRed:45/255.0f green:45/255.0f blue:45/255.0f alpha:1.0f]

#define fontSize_4 [UIFont systemFontOfSize:16.0]
#define fontSize_3 [UIFont systemFontOfSize:14.0]
#define fontSize_2 [UIFont systemFontOfSize:12.0]
#define fontSize_1 [UIFont systemFontOfSize:10.0]

#define fontSize_cellText [UIFont systemFontOfSize:16.0]
#define fontSize_cellDetailText [UIFont systemFontOfSize:12.0]

#define fontColor_strong [UIColor colorWithRed:50/255.0f green:161/255.0f blue:241/255.0f alpha:1.0f] //#32A1F1
#define fontColor_main [UIColor colorWithRed:34/255.0f green:34/255.0f blue:34/255.0f alpha:1.0f] //#222222
#define fontColor_assist [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0f] //#808080
#define fontColor_weak [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1.0f] //#cccccc

@interface ColorUtil : NSObject
+(UIColor*)getBgColor;
+(UIColor*)getPanelBgColor;
+(UIColor*)getSettingBgColor;
+(UIColor*)getNavigatorTintColor;
+(UIColor*)getNavigatorTitleColor;
+(UIColor*)getFontMainColor;
+(UIColor*)getFontAssistColor;
+(UIColor*)getTableSeperatorColor;
+(UIColor*)getBorderColor;
+(void)setStatusBarStyle;
+(void)setStyle1ForTableViewController:(UITableViewController*)tableViewController;
+(void)setStyle2ForTableViewController:(UITableViewController*)tableViewController;
@end
