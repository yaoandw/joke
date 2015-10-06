//
//  LeanCloudHelper.m
//  joke
//
//  Created by yaoandw on 15/8/26.
//  Copyright (c) 2015年 yycon. All rights reserved.
//

#import "LeanCloudHelper.h"
#import <AVOSCloud/AVCloud.h>
#import "AVObject.h"
#import "AVUser.h"
#import "AVQuery.h"
#import "AVRelation.h"

@implementation LeanCloudHelper
+(void)saveComment:(NSString*)comment withJoke:(Joke*)joke{
    
}
+(void)saveSupportWithJoke:(Joke*)joke{
    AVUser *currentUser = [AVUser currentUser];
    
    AVQuery *query = [AVQuery queryWithClassName:@"Joke"];
    [query whereKey:@"jokeId" equalTo:joke.id];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 检索成功
            AVObject *avJoke;
            if ([objects count] > 0) {
                avJoke = objects[0];
            }else{
                avJoke = [joke parseToAVObject];
            }
            [avJoke saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                //support 加1
                [avJoke incrementKey:@"support"];
                [avJoke saveInBackground];
                //加入我的support
                AVRelation *relation = [currentUser relationforKey:@"supports"];
                [relation addObject:avJoke];
                [currentUser saveInBackground];
            }];
        } else {
            // 输出错误信息
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
+(void)saveFavoriteWithJoke:(Joke*)joke{
    
}
+(void)saveForwardWithJoke:(Joke*)joke{
    
}
+(void)deleteComment:(NSString*)comment withJoke:(Joke*)joke{
    
}
+(void)deleteSupportWithJoke:(Joke*)joke{
    AVUser *currentUser = [AVUser currentUser];
    
    AVQuery *query = [AVQuery queryWithClassName:@"Joke"];
    [query whereKey:@"jokeId" equalTo:joke.id];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 检索成功
            AVObject *avJoke;
            if ([objects count] > 0) {
                avJoke = objects[0];
                [avJoke saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [avJoke incrementKey:@"support" byAmount:[NSNumber numberWithInt:-1]];
                    [avJoke saveInBackground];
                    
                    AVRelation *relation = [currentUser relationforKey:@"supports"];
                    [relation removeObject:avJoke];
                    [currentUser saveInBackground];
                }];
            }
        } else {
            // 输出错误信息
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}
+(void)deleteFavoriteWithJoke:(Joke*)joke{
    
}
+(void)deleteForwardWithJoke:(Joke*)joke{
    
}

+(void)fetchAVJokesByPage:(long)page//第一页需要缓存下来
                 jokeType:(long)jokeType//0,文本笑话 1 rich joke
                randomTime:(NSDate*)randomTime//穿越的时间
                onSuccess:(AVJokeSuccessBlock) successBlock
                  onError:(AVJokeErrorBlock)errorBlock{
    AVQuery *query = [AVQuery queryWithClassName:@"Joke"];
    if (page == 0) {
        [query setCachePolicy:(kAVCachePolicyNetworkElseCache)];
    }
    query.skip = page*20;
    query.limit = 20;
    [query whereKey:@"type" equalTo:[NSNumber numberWithLong:jokeType]];
    [query orderByDescending:@"time"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            errorBlock(error);
        }else{
            NSMutableArray *objectIdArray = [NSMutableArray array];
            for (AVObject *obj in objects) {
                [objectIdArray addObject:obj[@"objectId"]];
            }
            AVUser *user = [AVUser currentUser];
            AVRelation *sRelation = [user relationforKey:@"supports"];
            if (sRelation == nil) {
                successBlock(objects,nil,nil);
                return ;
            }
            AVQuery *relationQuery = [sRelation query];
            [relationQuery whereKey:@"objectId" containedIn:objectIdArray];
            [relationQuery findObjectsInBackgroundWithBlock:^(NSArray *supportedJokes, NSError *error) {
                if (error) {
                    // 呃，报错了
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                    errorBlock(error);
                } else {
                    AVRelation *fRelation = [user relationforKey:@"favorites"];
                    if (fRelation == nil) {
                        successBlock(objects,supportedJokes,nil);
                        return ;
                    }
                    AVQuery *relationQuery = [fRelation query];
                    [relationQuery whereKey:@"objectId" containedIn:objectIdArray];
                    [relationQuery findObjectsInBackgroundWithBlock:^(NSArray *favoritedJokes, NSError *error) {
                        if (error) {
                            // 呃，报错了
                            NSLog(@"Error: %@ %@", error, [error userInfo]);
                            errorBlock(error);
                        } else {
                            successBlock(objects,supportedJokes,favoritedJokes);
                        }
                    }];
                }
            }];
        }
    }];
}

@end
