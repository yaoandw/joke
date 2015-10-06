//
//  FileUtil.h
//  joke
//
//  Created by yaoandw on 14-5-14.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface FileUtil : NSObject
+(NSMutableDictionary*)getUserSettings;
+(void)saveUserSettings:(NSMutableDictionary*)userSettings;
+(void)clearCache;

#pragma mark - afnetworking image cache
+ (UIImage *)cachedAFNetworkingImageForRequest:(NSURLRequest *)request;
+ (void)cacheAFNetworkingImage:(UIImage *)image
                    forRequest:(NSURLRequest *)request;


+ (UIImage *)scaleToSize:(UIImage *)img maxLength:(CGFloat)maxLength;
@end
