//
//  SocialShareDelegate.m
//  joke
//
//  Created by yaoandw on 15/10/19.
//  Copyright © 2015年 yycon. All rights reserved.
//

#import "SocialShareDelegate.h"
#import "SocialHelper.h"

@interface SocialShareDelegate()
@property(nonatomic,strong)AVObject *joke;
@end

@implementation SocialShareDelegate
static SocialShareDelegate *instance;
-(id)initWithJoke:(AVObject*)joke{
    self = [self init];
    if (self) {
        self.joke = joke;
    }
    return self;
}
+(SocialShareDelegate*)getInstanceWithJoke:(AVObject*)joke{
    if (!instance) {
        instance = [[SocialShareDelegate alloc] initWithJoke:joke];
    }
    [instance setJoke:joke];
    return instance;
}
#pragma mark uiactionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [SocialHelper sendJokeToWeixin:self.joke];
            break;
        case 1:
            [SocialHelper sendJokeToWeixinTimeline:self.joke];
            break;
        case 2:
            [SocialHelper sendJokeToQQ:self.joke];
            break;
        case 3:
            [SocialHelper sendJokeToQZone:self.joke];
            break;
        default:
            break;
    }
}
@end
