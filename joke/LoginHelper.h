//
//  LoginHelper.h
//  joke
//
//  Created by yaoandw on 15/8/25.
//  Copyright (c) 2015年 yycon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

typedef void (^AVUserBlock)(AVUser* user);

@interface LoginHelper : NSObject
+(id)getInstance;
-(void)loginWithBlock:(AVUserBlock) block;
@end
