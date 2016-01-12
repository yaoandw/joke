//
//  LeanCloudHelper.h
//  joke
//
//  Created by yaoandw on 15/8/26.
//  Copyright (c) 2015年 yycon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVObject.h"

#define avjoke_type_text 0
#define avjoke_type_image 1

typedef void (^AVJokeSuccessBlock)(NSArray *avJokes,NSArray *supportedJokes,NSArray *favoritedJokes);
typedef void (^AVObjectSuccessBlock)(NSArray *avObjects);
typedef void (^AVOneObjectSuccessBlock)(AVObject *avObject);
typedef void (^AVJokeErrorBlock)(NSError *error);
typedef void (^BoolSuccessBlock)();

@interface LeanCloudHelper : NSObject
+(void)saveComment:(NSString*)comment
          withJoke:(AVObject*)joke
         onSuccess:(BoolSuccessBlock) successBlock
           onError:(AVJokeErrorBlock)errorBlock;
+(void)saveSupportWithJoke:(AVObject*)joke;
+(void)saveFavoriteWithJoke:(AVObject*)joke
                  onSuccess:(BoolSuccessBlock) successBlock
                    onError:(AVJokeErrorBlock)errorBlock;
+(void)saveForwardWithJoke:(AVObject*)joke;
+(void)deleteComment:(NSString*)comment withJoke:(AVObject*)joke;
+(void)deleteSupportWithJoke:(AVObject*)joke;
+(void)deleteFavoriteWithJoke:(AVObject*)joke;
+(void)deleteForwardWithJoke:(AVObject*)joke;

+(void)fetchAVJokesByPage:(long)page//页
                 jokeType:(long)jokeType//0,文本笑话 1 rich joke
                randomTime:(NSDate*)randomTime//穿越的时间
                onSuccess:(AVObjectSuccessBlock) successBlock
                  onError:(AVJokeErrorBlock)errorBlock;

+(void)fetchAVCommentsOfJoke:(AVObject*)joke
                         page:(long)page//页
                onSuccess:(AVObjectSuccessBlock) successBlock
                  onError:(AVJokeErrorBlock)errorBlock;
+(void)fetchFavoriteJokesByPage:(long)page
                      onSuccess:(AVObjectSuccessBlock) successBlock
                        onError:(AVJokeErrorBlock)errorBlock;
+(void)fetchJokeByObjectId:(NSString*)objectId
                 onSuccess:(AVOneObjectSuccessBlock)successBlock
                   onError:(AVJokeErrorBlock)errorBlock;

+(void)saveReportWithTitle:(NSString*)title
         content:(NSString*)content
        onSuccess:(BoolSuccessBlock) successBlock
          onError:(AVJokeErrorBlock)errorBlock;
+(void)test;
@end
