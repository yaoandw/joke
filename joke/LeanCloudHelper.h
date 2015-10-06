//
//  LeanCloudHelper.h
//  joke
//
//  Created by yaoandw on 15/8/26.
//  Copyright (c) 2015年 yycon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Joke.h"

#define avjoke_type_text 0
#define avjoke_type_image 1

typedef void (^AVJokeSuccessBlock)(NSArray *avJokes,NSArray *supportedJokes,NSArray *favoritedJokes);
typedef void (^AVJokeErrorBlock)(NSError *error);

@interface LeanCloudHelper : NSObject
+(void)saveComment:(NSString*)comment withJoke:(Joke*)joke;
+(void)saveSupportWithJoke:(Joke*)joke;
+(void)saveFavoriteWithJoke:(Joke*)joke;
+(void)saveForwardWithJoke:(Joke*)joke;
+(void)deleteComment:(NSString*)comment withJoke:(Joke*)joke;
+(void)deleteSupportWithJoke:(Joke*)joke;
+(void)deleteFavoriteWithJoke:(Joke*)joke;
+(void)deleteForwardWithJoke:(Joke*)joke;

+(void)fetchAVJokesByPage:(long)page//第一页需要缓存下来
                 jokeType:(long)jokeType//0,文本笑话 1 rich joke
                randomTime:(NSDate*)randomTime//穿越的时间
                onSuccess:(AVJokeSuccessBlock) successBlock
                  onError:(AVJokeErrorBlock)errorBlock;

@end
