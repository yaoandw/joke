//
//  SocialHelper.h
//  joke
//
//  Created by yaoandw on 14/12/22.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVObject.h"

@interface SocialHelper : NSObject
+(void)registerAppWithDelegate:(id) delegate;
+(BOOL) handleOpenURL:(NSURL *) url delegate:(id) delegate;

+ (void) sendJokeToWeixin:(AVObject*)joke;
+ (void) sendJokeToWeixinTimeline:(AVObject*)joke;

+ (void) sendJokeToQQ:(AVObject*)joke;
+ (void) sendJokeToQZone:(AVObject*)joke;

+(void)showShareActionSheetWithJoke:(AVObject*)joke;
@end
