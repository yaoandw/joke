//
//  NSString+yycon.h
//  joke
//
//  Created by yaoandw on 14-5-7.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (yycon)
//处理掉xml中最前面的换行
-(NSString*)processXmlContent;
-(BOOL)isGif;
-(NSString*)processName;
-(NSArray*)jsonToArray;
-(NSDictionary*)jsonToDict;
- (NSString *) md5;
@end
