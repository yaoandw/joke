//
//  NSDate+yycon.m
//  joke
//
//  Created by yaoandw on 14-5-12.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "NSDate+yycon.h"

@implementation NSDate (yycon)
-(BOOL) isSameDayWithDate:(NSDate*)date{
    if (date == nil) {
        return NO;
    }
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}
@end
