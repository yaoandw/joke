//
//  SocialHelper.h
//  joke
//
//  Created by yaoandw on 14/12/22.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Joke.h"

@interface SocialHelper : NSObject
+(void)registerAppWithDelegate:(id) delegate;
+(BOOL) handleOpenURL:(NSURL *) url delegate:(id) delegate;

+ (void) sendJokeToWeixin:(Joke*)joke;
+ (void) sendJokeToWeixinTimeline:(Joke*)joke;

+ (void) sendJokeToQQ:(Joke*)joke;
+ (void) sendJokeToQZone:(Joke*)joke;
@end
