//
//  LeanCloudHelper.m
//  joke
//
//  Created by yaoandw on 15/8/26.
//  Copyright (c) 2015年 yycon. All rights reserved.
//

#import "LeanCloudHelper.h"
#import <AVOSCloud/AVCloud.h>
#import "AVUser.h"
#import "AVQuery.h"
#import "AVRelation.h"
#import "AppDelegate.h"

@implementation LeanCloudHelper
+(void)saveComment:(NSString*)comment
          withJoke:(AVObject*)joke
         onSuccess:(BoolSuccessBlock) successBlock
           onError:(AVJokeErrorBlock)errorBlock{
    AVUser *currentUser = [AVUser currentUser];
    // 创建评论和内容
    AVObject *myComment = [AVObject objectWithClassName:@"Comment"];
    myComment[@"content"] = comment;
    myComment[@"author"] = currentUser;
    myComment[@"joke"] = joke;
    [myComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [joke addObject:myComment forKey:@"comments"];
            [joke saveInBackground];
            
            [currentUser addObject:myComment forKey:@"comments"];
            [currentUser saveInBackground];
            successBlock();
        }else{
            errorBlock(error);
        }
    }];
}
+(void)saveSupportWithJoke:(AVObject*)joke{
    AVUser *currentUser = [AVUser currentUser];
    
    [joke addObject:currentUser forKey:@"supportUsers"];
    [joke saveInBackground];
    //加入我的support
    AVRelation *relation = [currentUser relationforKey:@"supports"];
    [relation addObject:joke];
    [currentUser saveInBackground];
}
+(void)saveFavoriteWithJoke:(AVObject*)joke
                  onSuccess:(BoolSuccessBlock) successBlock
                    onError:(AVJokeErrorBlock)errorBlock{
    AVUser *currentUser = [AVUser currentUser];
    
    [joke addObject:currentUser forKey:@"favoriteUsers"];
    [joke saveInBackground];
    //加入我的favorite
    AVRelation *relation = [currentUser relationforKey:@"favorites"];
    [relation addObject:joke];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if (successBlock) {
                successBlock();
            }
        }else{
            if (errorBlock) {
                errorBlock(error);
            }
        }
    }];
}
+(void)saveForwardWithJoke:(AVObject*)joke{
    //support 加1
    [joke incrementKey:@"forward"];
    [joke saveInBackground];
}
+(void)deleteComment:(NSString*)comment withJoke:(AVObject*)joke{
    
}
+(void)deleteSupportWithJoke:(AVObject*)joke{
    AVUser *currentUser = [AVUser currentUser];
    
    [joke removeObject:currentUser forKey:@"supportUsers"];
    [joke saveInBackground];
    if (!MyAppDelegate.hasLoginedWhenRunning) {
        AVRelation *relation = [currentUser relationforKey:@"supports"];
        [relation removeObject:joke];
        [currentUser saveInBackground];
    }
}
+(void)deleteFavoriteWithJoke:(AVObject*)joke{
    AVUser *currentUser = [AVUser currentUser];
    
    [joke removeObject:currentUser forKey:@"favoriteUsers"];
    [joke saveInBackground];
    
    if (!MyAppDelegate.hasLoginedWhenRunning) {
        AVRelation *relation = [currentUser relationforKey:@"favorites"];
        [relation removeObject:joke];
        [currentUser saveInBackground];
    }
}
+(void)deleteForwardWithJoke:(AVObject*)joke{
    [joke incrementKey:@"forward" byAmount:[NSNumber numberWithInt:-1]];
    [joke saveInBackground];
}

+(void)fetchAVJokesByPage:(long)page//页
                 jokeType:(long)jokeType//0,文本笑话 1 rich joke
                randomTime:(NSDate*)randomTime//穿越的时间
                onSuccess:(AVObjectSuccessBlock) successBlock
                  onError:(AVJokeErrorBlock)errorBlock{
    DLog(@"page:%ld,jokeType:%ld,randomTime:%@",page,jokeType,randomTime);
    AVQuery *query = [AVQuery queryWithClassName:@"Joke"];
    
    query.skip = page*20;
    query.limit = 20;
    [query whereKey:@"type" equalTo:[NSNumber numberWithLong:jokeType]];
    if (randomTime) {
        [query whereKey:@"time" lessThanOrEqualTo:randomTime];
    }
    [query orderByDescending:@"time"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            errorBlock(error);
        }else{
            successBlock(objects);
        }
    }];
}

+(void)fetchAVCommentsOfJoke:(AVObject*)joke
                        page:(long)page//页
                   onSuccess:(AVObjectSuccessBlock) successBlock
                     onError:(AVJokeErrorBlock)errorBlock{
    AVQuery *query = [AVQuery queryWithClassName:@"Comment"];
    
    query.skip = page*20;
    query.limit = 20;
    [query whereKey:@"joke" equalTo:joke];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            errorBlock(error);
        }else{
            successBlock(objects);
        }
    }];
}
+(void)fetchFavoriteJokesByPage:(long)page
                      onSuccess:(AVObjectSuccessBlock) successBlock
                        onError:(AVJokeErrorBlock)errorBlock{
    AVUser *currentUser = [AVUser currentUser];
    AVRelation *relation = [currentUser relationforKey:@"favorites"];
    
    AVQuery *query = [relation query];
    query.skip = page*20;
    query.limit = 20;
    [query orderByDescending:@"time"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            //errorBlock(error);
            //登录后直接跳转到favorite页面,会报错,The key 'favorites' in class '_User' is not a relation type.
            //调用一下此方法
            [LeanCloudHelper fetchJokeByObjectId:@"5624b1a760b2ce30d2588098" onSuccess:^(AVObject *avObject) {
                [LeanCloudHelper saveFavoriteWithJoke:avObject onSuccess:^{
                    [self _fetchFavoriteJokesByPage:page onSuccess:successBlock onError:errorBlock];
                } onError:^(NSError *error) {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                    errorBlock(error);
                }];
            } onError:^(NSError *error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }];
        }else{
            successBlock(objects);
        }
    }];
}

+(void)_fetchFavoriteJokesByPage:(long)page
                      onSuccess:(AVObjectSuccessBlock) successBlock
                        onError:(AVJokeErrorBlock)errorBlock{
    AVUser *currentUser = [AVUser currentUser];
    AVRelation *relation = [currentUser relationforKey:@"favorites"];
    
    AVQuery *query = [relation query];
    query.skip = page*20;
    query.limit = 20;
    [query orderByDescending:@"time"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            errorBlock(error);
        }else{
            successBlock(objects);
        }
    }];
}



+(void)fetchJokeByObjectId:(NSString*)objectId
                 onSuccess:(AVOneObjectSuccessBlock)successBlock
                   onError:(AVJokeErrorBlock)errorBlock{
    [[AVQuery queryWithClassName:@"Joke"] getObjectInBackgroundWithId:objectId block:^(AVObject *object, NSError *error) {
        if (error) {
            errorBlock(error);
        }else{
            successBlock(object);
        }
    }];
}
+(void)saveReportWithTitle:(NSString*)title
                   content:(NSString*)content
                 onSuccess:(BoolSuccessBlock) successBlock
                   onError:(AVJokeErrorBlock)errorBlock{
    AVObject *report = [AVObject objectWithClassName:@"Report"];
    report[@"title"] = title;
    report[@"content"] = content;
    [report saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (successBlock) {
            successBlock();
        }else{
            errorBlock(error);
        }
    }];
}
+(void)test{
    // 创建微博、内容
    AVObject *myPost = [AVObject objectWithClassName:@"Post"];
    [myPost setObject:@"作为一个程序员，你认为回家以后要不要继续写代码？" forKey:@"content"];
    
    // 创建评论和内容
    AVObject *myComment = [AVObject objectWithClassName:@"Comment"];
    [myComment setObject:@"我若是写代码，进入状态之后最好不要停。下不下班已经不重要了，那种感觉最重要。" forKey:@"content"];
    
    // 为微博和评论建立一对一关系
    [myComment setObject:myPost forKey:@"post"];
    
    // 同时保存 myPost、myComment
    [myComment saveInBackground];
}

@end
