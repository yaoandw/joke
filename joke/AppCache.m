//
//  AppCache.m
//  joke
//
//  Created by yaoandw on 14-5-12.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "AppCache.h"
#import "AppDelegate.h"
#define kMenuStaleSeconds 10

@interface AppCache (/*Private Methods*/)
+(NSString*) cacheDirectory;
+(NSString*) appVersion;
@end

@implementation AppCache

static NSMutableDictionary *memoryCache;
static NSMutableArray *recentlyAccessedKeys;
static int kCacheMemoryLimit;
static NSLock *queueTaskLock;
static NSLock *localMsgLock;

+(void) initialize
{
    NSString *cacheDirectory = [AppCache cacheDirectory];
    if(![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    double lastSavedCacheVersion = [[NSUserDefaults standardUserDefaults] doubleForKey:@"CACHE_VERSION"];
    double currentAppVersion = [[AppCache appVersion] doubleValue];
    NSLog(@"lastSavedCacheVersion:%f,currentAppVersion:%f",lastSavedCacheVersion,currentAppVersion);
    if( lastSavedCacheVersion == 0.0f || lastSavedCacheVersion < currentAppVersion)
    {
        // assigning current version to preference
        [AppCache clearCache];
        
        [[NSUserDefaults standardUserDefaults] setDouble:currentAppVersion forKey:@"CACHE_VERSION"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    memoryCache = [[NSMutableDictionary alloc] init];
    recentlyAccessedKeys = [[NSMutableArray alloc] init];
    
    // you can set this based on the running device and expected cache size
    kCacheMemoryLimit = 20;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMemoryCacheToDisk:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    queueTaskLock = [[NSLock alloc] init];
    localMsgLock = [[NSLock alloc] init];
}

+(void) dealloc
{
    memoryCache = nil;
    
    recentlyAccessedKeys = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    
}

+(void) saveMemoryCacheToDisk:(NSNotification *)notification
{
    [self saveMemoryCacheToDisk];
}
+(void)saveMemoryCacheToDisk{
    for(NSString *filename in [memoryCache allKeys])
    {
        NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:filename];
        NSData *cacheData = [memoryCache objectForKey:filename];
        [cacheData writeToFile:archivePath atomically:YES];
    }
    
    [memoryCache removeAllObjects];
}
+(void) clearCache
{
    NSArray *cachedItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[AppCache cacheDirectory]
                                                                               error:nil];
    
    for(NSString *fileName in cachedItems){
        NSString *path = [[AppCache cacheDirectory] stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    [memoryCache removeAllObjects];
}

+(void)clearCacheByName:(NSString*)fileName{
    NSString *path = [[AppCache cacheDirectory] stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [memoryCache removeObjectForKey:fileName];
}

+(NSString*) appVersion
{
	CFStringRef versStr = (CFStringRef)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey);
	NSString *version = [NSString stringWithUTF8String:CFStringGetCStringPtr(versStr,kCFStringEncodingMacRoman)];
	
	return version;
}

+(NSString*) cacheDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
	return [cachesDirectory stringByAppendingPathComponent:YYCON_CACHE_APPCACHE];
}

#pragma mark -
#pragma mark Custom Methods

// Add your custom methods here

+(void) cacheData:(NSData*) data toFile:(NSString*) fileName
{
    [memoryCache setObject:data forKey:fileName];
    if([recentlyAccessedKeys containsObject:fileName])
    {
        [recentlyAccessedKeys removeObject:fileName];
    }
    
    [recentlyAccessedKeys insertObject:fileName atIndex:0];
    
    if([recentlyAccessedKeys count] > kCacheMemoryLimit)
    {
        NSString *leastRecentlyUsedDataFilename = [recentlyAccessedKeys lastObject];
        NSData *leastRecentlyUsedCacheData = [memoryCache objectForKey:leastRecentlyUsedDataFilename];
        NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:fileName];
        [leastRecentlyUsedCacheData writeToFile:archivePath atomically:YES];
        
        [recentlyAccessedKeys removeLastObject];
        [memoryCache removeObjectForKey:leastRecentlyUsedDataFilename];
    }
}

+(NSData*) dataForFile:(NSString*) fileName
{
    NSData *data = [memoryCache objectForKey:fileName];
    if(data) return data; // data is present in memory cache
    
	NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:fileName];
    data = [NSData dataWithContentsOfFile:archivePath];
    
    if(data)
        [self cacheData:data toFile:fileName]; // put the recently accessed data to memory cache
    
    return data;
}

+(void) cacheMenuItems:(NSArray*) menuItems
{
    [self cacheData:[NSKeyedArchiver archivedDataWithRootObject:menuItems]
             toFile:@"MenuItems.archive"];
}

+(NSMutableArray*) getCachedMenuItems
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForFile:@"MenuItems.archive"]];
}

+(BOOL) isMenuItemsStale
{
    // if it is in memory cache, it is not stale
    if([recentlyAccessedKeys containsObject:@"MenuItems.archive"])
        return NO;
    
	NSString *archivePath = [[AppCache cacheDirectory] stringByAppendingPathComponent:@"MenuItems.archive"];
    
    NSTimeInterval stalenessLevel = [[[[NSFileManager defaultManager] attributesOfItemAtPath:archivePath error:nil] fileModificationDate] timeIntervalSinceNow];
    
    return stalenessLevel > kMenuStaleSeconds;
}

#pragma mark - custom
//最新笑话
+(void) cacheLastestJokes:(JokeXmlModel*)lastestJokes{
    [self cacheData:[NSKeyedArchiver archivedDataWithRootObject:lastestJokes]
             toFile:@"lastest_jokes.archive"];
}
+(JokeXmlModel*) getCachedLastestJokes{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForFile:@"lastest_jokes.archive"]];
}
//随机笑话
+(void) cacheRadomJokes:(JokeXmlModel*)radomJokes{
    [self cacheData:[NSKeyedArchiver archivedDataWithRootObject:radomJokes]
             toFile:@"radom_jokes.archive"];
}

+(JokeXmlModel*) getCachedRadomJokes{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForFile:@"radom_jokes.archive"]];
}
//最新笑图
+(void) cacheLastestRichJokes:(JokeXmlModel*)lastestRichJokes{
    [self cacheData:[NSKeyedArchiver archivedDataWithRootObject:lastestRichJokes]
             toFile:@"lastest_richjokes.archive"];
}
+(JokeXmlModel*) getCachedLastestRichJokes{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForFile:@"lastest_richjokes.archive"]];
}

//随机笑图
+(void) cacheRadomRichJokes:(JokeXmlModel*)radomRichJokes{
    [self cacheData:[NSKeyedArchiver archivedDataWithRootObject:radomRichJokes]
             toFile:@"radom_richjokes.archive"];
}
+(JokeXmlModel*) getCachedRadomRichJokes{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForFile:@"radom_richjokes.archive"]];
}
@end
