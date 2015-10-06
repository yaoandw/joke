//
//  AppCache.h
//  joke
//
//  Created by yaoandw on 14-5-12.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JokeXmlModel.h";

@interface AppCache : NSObject
+(void)saveMemoryCacheToDisk;
+(void) clearCache;
+(void) cacheMenuItems:(NSArray*) menuItems;
+(NSMutableArray*) getCachedMenuItems;
+(BOOL) isMenuItemsStale;

#pragma mark - custom

//最新笑话
+(void) cacheLastestJokes:(JokeXmlModel*)lastestJokes;
+(JokeXmlModel*) getCachedLastestJokes;
//随机笑话
+(void) cacheRadomJokes:(JokeXmlModel*)radomJokes;
+(JokeXmlModel*) getCachedRadomJokes;
//最新笑图
+(void) cacheLastestRichJokes:(JokeXmlModel*)lastestRichJokes;
+(JokeXmlModel*) getCachedLastestRichJokes;
//随机笑图
+(void) cacheRadomRichJokes:(JokeXmlModel*)radomRichJokes;
+(JokeXmlModel*) getCachedRadomRichJokes;
@end
