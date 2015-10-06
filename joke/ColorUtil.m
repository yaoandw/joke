//
//  ColorUtil.m
//  joke
//
//  Created by yaoandw on 14-5-15.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "ColorUtil.h"
#import "FileUtil.h"

@implementation ColorUtil
+(UIColor*)getBgColor{
    NSMutableDictionary *userSettings = [FileUtil getUserSettings];
    return [[userSettings objectForKey:@"nightMode"] boolValue]?bgColor_night:bgColor_day;
}
+(UIColor*)getPanelBgColor{
    NSMutableDictionary *userSettings = [FileUtil getUserSettings];
    return [[userSettings objectForKey:@"nightMode"] boolValue]?panelBgColor_night:panelBgColor_day;
}
+(UIColor*)getSettingBgColor{
    NSMutableDictionary *userSettings = [FileUtil getUserSettings];
    return [[userSettings objectForKey:@"nightMode"] boolValue]?bgColor_night:viewBackgroundColor;
}
+(UIColor*)getNavigatorTintColor{
    NSMutableDictionary *userSettings = [FileUtil getUserSettings];
    return [[userSettings objectForKey:@"nightMode"] boolValue]?nvColor_night:nvColor_day;
}
+(UIColor*)getNavigatorTitleColor{
    NSMutableDictionary *userSettings = [FileUtil getUserSettings];
    return [[userSettings objectForKey:@"nightMode"] boolValue]?fontColor_night:fontColor_day;
}
+(UIColor*)getFontMainColor{
    NSMutableDictionary *userSettings = [FileUtil getUserSettings];
    return [[userSettings objectForKey:@"nightMode"] boolValue]?fontColor_night:fontColor_day;
}
+(UIColor*)getFontAssistColor{
    NSMutableDictionary *userSettings = [FileUtil getUserSettings];
    return [[userSettings objectForKey:@"nightMode"] boolValue]?fontAssistColor_night:fontAssistColor_day;
}
+(UIColor*)getBorderColor{
    NSMutableDictionary *userSettings = [FileUtil getUserSettings];
    return [[userSettings objectForKey:@"nightMode"] boolValue]?border_color_night:border_color_day;
}
+(UIColor*)getTableSeperatorColor{
    return [ColorUtil getFontAssistColor];
}
+(void)setStatusBarStyle{
    NSMutableDictionary *userSettings = [FileUtil getUserSettings];
    [[UIApplication sharedApplication] setStatusBarStyle:[[userSettings objectForKey:@"nightMode"] boolValue]? UIStatusBarStyleLightContent:UIStatusBarStyleDefault];
}
+(void)setStyle1ForTableViewController:(UITableViewController*)tableViewController{
    tableViewController.view.backgroundColor = [ColorUtil getBgColor];
    if (ios_version >=7.0)
        tableViewController.navigationController.navigationBar.barTintColor = [ColorUtil getNavigatorTintColor];
    else
        tableViewController.navigationController.navigationBar.tintColor = [ColorUtil getNavigatorTintColor];
    [tableViewController.tableView setSeparatorColor:[ColorUtil getTableSeperatorColor]];
    [ColorUtil setStatusBarStyle];
}
+(void)setStyle2ForTableViewController:(UITableViewController*)tableViewController{
    tableViewController.view.backgroundColor = [ColorUtil getSettingBgColor];
    tableViewController.tableView.backgroundColor = [ColorUtil getSettingBgColor];
    tableViewController.tableView.backgroundView = nil;//ios6 grouped类型的需要设成nil ,否者设置backgroundColor是无效的
    if (ios_version >=7.0)
        tableViewController.navigationController.navigationBar.barTintColor = [ColorUtil getNavigatorTintColor];
    else
        tableViewController.navigationController.navigationBar.tintColor = [ColorUtil getNavigatorTintColor];
    //
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[ColorUtil getNavigatorTitleColor] forKey:UITextAttributeTextColor];
    tableViewController.navigationController.navigationBar.titleTextAttributes = dict;
    
    [tableViewController.tableView setSeparatorColor:[ColorUtil getTableSeperatorColor]];
    [ColorUtil setStatusBarStyle];
}
@end
