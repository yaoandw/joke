//
//  JokeXmlModel.h
//  joke
//
//  Created by yaoandw on 14-5-12.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "JSONModel.h"

@interface JokeXmlModel : JSONModel
@property(nonatomic,strong)NSString *timestamp;
@property(nonatomic,strong)NSArray* jokeArray;
@end
