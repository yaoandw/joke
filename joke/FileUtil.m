//
//  FileUtil.m
//  joke
//
//  Created by yaoandw on 14-5-14.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "FileUtil.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+yycon.h"
#import "AppCache.h"
#import "AppDelegate.h"

@implementation FileUtil
+(NSMutableDictionary*)getUserSettings{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = nil;
    NSDictionary *userSettings = [def objectForKey:@"yycon_user_settings"];
    if (userSettings) {
        dict = [NSMutableDictionary dictionaryWithDictionary:userSettings];
    }else{
        dict  =[NSMutableDictionary dictionary];
    }
    return dict;
}
+(void)saveUserSettings:(NSMutableDictionary*)userSettings{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (userSettings) {
        [def setValue:userSettings forKey:@"yycon_user_settings"];
        [def synchronize];
    }
}
+(void)clearCache{
    //image
    [(NSCache*)[UIImageView sharedImageCache] removeAllObjects];
    //app cache
    [AppCache clearCache];
    //Clearing UIWebview cache
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark - afnetworking image cache
+ (UIImage *)cachedAFNetworkingImageForRequest:(NSURLRequest *)request {
    switch ([request cachePolicy]) {
        case NSURLRequestReloadIgnoringCacheData:
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            return nil;
        default:
            break;
    }
    NSString *urlString = [FileUtil getAFWorkingImageCachePath:[self AFNetworkingImageCacheKeyFromURLRequest:request]];
    return [UIImage imageWithData:[NSData dataWithContentsOfFile:urlString]];
}

+ (void)cacheAFNetworkingImage:(UIImage *)image
                    forRequest:(NSURLRequest *)request
{
    if (image && request) {
        [self cacheAFNetworkingImageToCacheDirectory:image imageName:[self AFNetworkingImageCacheKeyFromURLRequest:request] quality:1.0];
    }
}
+ (NSString *) AFNetworkingImageCacheKeyFromURLRequest:(NSURLRequest *)request {
    return [[[request URL] absoluteString] md5];
}
+(NSInteger)cacheAFNetworkingImageToCacheDirectory:(UIImage *)image
                                         imageName:(NSString *)imageName
                                           quality:(CGFloat)quality{
    //image = [image fixOrientation];
    //image = [self scaleToSize:image maxLength:image_default_maxLength];
    NSString *imageCahePath = [self getAFWorkingImageCachePath:imageName];
    //NSData* imageData = UIImagePNGRepresentation(image);
    NSData* imageData = UIImageJPEGRepresentation(image, quality);
    BOOL result = [imageData writeToFile:imageCahePath atomically:NO];
    return result?[imageData length]:-1;
}
+(NSString *)getAFWorkingImageCachePath:(NSString *)imageName{
    NSString *imageCahePath = [self getAFNetworkingImageCacheDirectory];
    imageCahePath = [imageCahePath  stringByAppendingPathComponent:imageName];
    return imageCahePath;
}

+(NSString *)getAFNetworkingImageCacheDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *imageCahePath = [cachesDirectory stringByAppendingPathComponent:YYCON_CACHE_IMAGE_AFNETWORKING];
    if(![[NSFileManager defaultManager] fileExistsAtPath:imageCahePath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:imageCahePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    return imageCahePath;
}

+(void)emptyAFNetworkingImageCache{
    
    NSError *error = nil;
    NSArray *directoryContents = [[NSFileManager defaultManager]
                                  contentsOfDirectoryAtPath:[self getAFNetworkingImageCacheDirectory] error:&error];
    if(error) DLog(@"%@", error);
    
    error = nil;
    for(NSString *fileName in directoryContents) {
        
        NSString *path = [[self getAFNetworkingImageCacheDirectory] stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if(error) DLog(@"%@", error);
    }
}



+ (UIImage *)scaleToSize:(UIImage *)img maxLength:(CGFloat)maxLength{
    if (img) {
        CGFloat width = img.size.width;
        CGFloat height = img.size.height;
        CGFloat bigLength = width>height?width:height;
        if (bigLength<=maxLength) {
            return img;
        }else{
            if (bigLength == width) {
                width = maxLength;
                height = height*(maxLength/bigLength);
            }else{
                height = maxLength;
                width = width*(maxLength/bigLength);
            }
            return [self scaleToSize:img width:width height:height];
        }
    }
    return img;
}
+ (UIImage *)scaleToSize:(UIImage *)img width:(CGFloat)width height:(CGFloat)height{
    return [self scaleToSize:img size:CGSizeMake(width, height)];
}
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end
