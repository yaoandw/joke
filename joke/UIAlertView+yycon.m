//
//  UIAlertView+yycon.m
//  joke
//
//  Created by yaoandw on 14-5-7.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "UIAlertView+yycon.h"

@implementation UIAlertView (yycon)
+(UIAlertView*) showWithError:(NSError*) networkError {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[networkError localizedDescription]
                                           message:@"请重试"
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil];
    [alert show];
    return alert;
}
@end
