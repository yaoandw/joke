//
//  AppCache.h
//  joke
//
//  Created by yaoandw on 14-5-12.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppCache : NSObject
+(void)saveMemoryCacheToDisk;
+(void) clearCache;
+(void) cacheMenuItems:(NSArray*) menuItems;
+(NSMutableArray*) getCachedMenuItems;
+(BOOL) isMenuItemsStale;

#pragma mark - custom

//最新笑话
+(void) cacheLastestJokes:(NSArray*)lastestJokes;
+(NSArray*) getCachedLastestJokes;
//随机笑话
+(void) cacheRadomJokes:(NSArray*)radomJokes;
+(NSArray*) getCachedRadomJokes;
//最新笑图
+(void) cacheLastestRichJokes:(NSArray*)lastestRichJokes;
+(NSArray*) getCachedLastestRichJokes;
//随机笑图
+(void) cacheRadomRichJokes:(NSArray*)radomRichJokes;
+(NSArray*) getCachedRadomRichJokes;
@end
