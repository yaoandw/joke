//
//  AppDelegate.h
//  joke
//
//  Created by yaoandw on 15/10/3.
//  Copyright © 2015年 yycon. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MyAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define yycon_request_timeout 20

#ifdef DEBUG
#ifndef DLog
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#endif
#ifndef ELog
#   define ELog(err) {if(err) DLog(@"%@", err)}
#endif
#else
#ifndef DLog
#   define DLog(...)
#endif
#ifndef ELog
#   define ELog(err)
#endif
#endif

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



#define UM_APPKEY @"536a269456240b7897011f76"

#define YYCON_CACHE_APPCACHE @"AppCache"

#define ios_version [[[UIDevice currentDevice] systemVersion] floatValue]

//获取itune上的版本
#define APPINFO_ON_ITUNES_URL @"http://itunes.apple.com/lookup?id=878921278"
//appstore 地址
#define APPRATE_ON_ITUNES_URL @"https://itunes.apple.com/us/app/xiao-ha-ha-jing-xuan-xiao/id878921278?l=zh&ls=1&mt=8"

#define APP_NAME ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])
#define APP_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define APP_BUILD ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])

#define YYCON_CACHE_IMAGE_AFNETWORKING @"af_YyconImages"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,assign)BOOL fromLaunch_jokeRefreshed;
@property(nonatomic,assign)BOOL fromLaunch_richJokeRefreshed;

@end

