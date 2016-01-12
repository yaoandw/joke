//
//  NewCommentController.h
//  joke
//
//  Created by yaoandw on 15/10/18.
//  Copyright © 2015年 yycon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVObject.h"

@protocol NewCommentControllerDelegate <NSObject>

-(void)commentHasSent;
-(void)viewDismissed;

@end

@interface NewCommentController : UIViewController
-(id)initWithJoke:(AVObject*)joke delegate:(id)delegate;
@end
