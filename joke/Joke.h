//
//  Joke.h
//  joke
//
//  Created by yaoandw on 14-5-7.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "JSONModel.h"
#import "AVObject.h"
@interface Joke : JSONModel
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *content;//text
@property (nonatomic, strong) NSString *imgurl;
@property (nonatomic, strong) NSString *thmurl;
@property (nonatomic, strong) NSString *forward;
@property (nonatomic, strong) NSString *commend;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *videourl;

-(AVObject*)parseToAVObject;

@end
