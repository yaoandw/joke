//
//  AppDelegate.m
//  joke
//
//  Created by yaoandw on 15/10/3.
//  Copyright © 2015年 yycon. All rights reserved.
//

#import "AppDelegate.h"
#import "SocialHelper.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LeftTableViewController.h"
#import "MainTableViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "JokeNavController.h"

@interface AppDelegate ()
@property (nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation AppDelegate
-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    UIViewController * leftSideDrawerViewController = [[LeftTableViewController alloc] init];
    
    UIViewController * centerViewController = [[MainTableViewController alloc] init];
    
    UINavigationController * navigationController = [[JokeNavController alloc] initWithRootViewController:centerViewController];
    [navigationController setRestorationIdentifier:@"JokeCenterNavigationControllerRestorationKey"];
    UINavigationController * leftSideNavController = [[JokeNavController alloc] initWithRootViewController:leftSideDrawerViewController];
    [leftSideNavController setRestorationIdentifier:@"JokeLeftNavigationControllerRestorationKey"];
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:navigationController
                             leftDrawerViewController:leftSideNavController
                             rightDrawerViewController:nil];
    [self.drawerController setShowsShadow:NO];
    [self.drawerController setRestorationIdentifier:@"Joke"];
    //[self.drawerController setMaximumRightDrawerWidth:200.0];
    [self.drawerController setMaximumLeftDrawerWidth:150.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                          green:173.0/255.0
                                           blue:234.0/255.0
                                          alpha:1.0];
    [self.window setTintColor:tintColor];
    [self.window setRootViewController:self.drawerController];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    
    //使用leancloud
    //如果使用美国站点，请加上这行代码 [AVOSCloud useAVCloudUS];
    [AVOSCloud setApplicationId:@"eq5tge5ziB5wPQdu1WJyy3O2" clientKey:@"EjyBMtW8AJatUGpw6mKaszPR"];
    //跟踪统计应用的打开情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //设置友盟统计分析
    //[MobClick startWithAppkey:UM_APPKEY reportPolicy:SEND_INTERVAL   channelId:nil];
    //友盟SDK为了兼容Xcode3的工程，默认取的是Build号，如果需要取Xcode4及以上版本的Version，可以使用下面的方法
    //NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //[MobClick setAppVersion:version];
    
    /*
     //设置友盟社会化组件appkey
     [UMSocialData setAppKey:UM_APPKEY];
     //设置微信AppId，url地址传nil，将默认使用友盟的网址，需要#import "UMSocialWechatHandler.h"
     [UMSocialWechatHandler setWXAppId:@"wx7a6709b4f6733a36" appSecret:@"86d8b8740aba62caa7c0fa09a7e2a888" url:nil];
     //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
     [UMSocialQQHandler setQQWithAppId:@"1101718393" appKey:@"55411f37b1d738e3bbb8c13113c0a261" url:nil];
     //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
     //[UMSocialConfig setSupportSinaSSO:YES appRedirectUrl:nil];
     //设置易信Appkey和分享url地址,注意需要引用头文件 #import UMSocialYixinHandler.h
     [UMSocialYixinHandler setYixinAppKey:@"yx9309b33d18a74b1e9afb787504c1bc6c" url:nil];
     //设置来往AppId，appscret，显示来源名称和url地址，注意需要引用头文件 #import "UMSocialLaiwangHandler.h"
     [UMSocialLaiwangHandler setLaiwangAppId:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" appDescription:@"友盟社会化组件" urlStirng:nil];
     //设置Facebook，AppID和分享url，需要#import "UMSocialFacebookHandler.h"
     //默认使用iOS自带的Facebook分享framework，在iOS 6以上有效。若要使用我们提供的facebook分享需要使用此开关：
     //[UMSocialFacebookHandler setFacebookAppID:@"1440390216179601" shareFacebookWithURL:@"http://www.umeng.com/social"];
     //默认使用iOS自带的Twitter分享framework，在iOS 6以上有效。若要使用我们提供的twitter分享需要使用此开关：
     //[UMSocialTwitterHandler openTwitter];
     */
    
    [SocialHelper registerAppWithDelegate:self];
    
    self.fromLaunch_jokeRefreshed = NO;
    self.fromLaunch_richJokeRefreshed = NO;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return  [SocialHelper handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    return  [SocialHelper handleOpenURL:url delegate:self];
}
@end
