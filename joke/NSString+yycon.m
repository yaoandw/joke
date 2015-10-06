//
//  NSString+yycon.m
//  joke
//
//  Created by yaoandw on 14-5-7.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "NSString+yycon.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"

@implementation NSString (yycon)

-(NSString*)processXmlContent{
    NSString *temp = self;
    if ([temp hasPrefix:@"\n"]) {
        temp = [temp substringFromIndex:1];
    }
    if ([temp hasSuffix:@"_"]) {
        temp = [temp substringToIndex:temp.length-1];
    }
    return temp;
}
-(BOOL)isGif{
    if ([[self lowercaseString] hasSuffix:@"gif"]) {
        return YES;
    }else{
        return NO;
    }
}
-(NSString*)processName{
    return [self stringByReplacingOccurrencesOfString:@"搞笑妹子" withString:@"笑哈哈"];
}
-(NSArray*)jsonToArray{
    NSData* jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray* result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error)
        DLog(@"jsonToArray Parsing Error: %@", error);
    return result;
}
-(NSDictionary*)jsonToDict{
    NSData* jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary* result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error)
        DLog(@"jsonToArray Parsing Error: %@", error);
    return result;
}
- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];      
}
@end
