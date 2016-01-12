//
//  SocialShareDelegate.h
//  joke
//
//  Created by yaoandw on 15/10/19.
//  Copyright © 2015年 yycon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVObject.h"

@interface SocialShareDelegate : NSObject<UIActionSheetDelegate>
+(SocialShareDelegate*)getInstanceWithJoke:(AVObject*)joke;
-(id)initWithJoke:(AVObject*)joke;
@end
