//
//  DetailJokeCell.h
//  joke
//
//  Created by yaoandw on 15/10/18.
//  Copyright © 2015年 yycon. All rights reserved.
//

#import "JokeCell.h"

@interface DetailJokeCell : JokeCell
-(void)setJokeCell:(AVObject*)joke parentViewController:(UIViewController*)parentViewController;
+(CGFloat)calJokeCellHeight:(AVObject*)joke;
@end
