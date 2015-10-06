//
//  RESTEngine.h
//  joke
//
//  Created by yaoandw on 14-5-7.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "JokeXmlModel.h"
#define joke_type_text @"0"
#define joke_type_image @"1"

typedef enum : NSInteger {
	YyconNotReachable = 0,
	YyconReachableViaWiFi,
	YyconReachableViaWWAN,
    YyconReachableUnknow
} YyconNetworkStatus;

typedef void (^VoidBlock)(void);
typedef void (^ModelBlock)(JSONModel* aModelBaseObject);
typedef void (^StringBlock)(NSString* string);
typedef void (^ArrayBlock)(NSMutableArray* listOfModelBaseObjects);
typedef void (^ArrayStringBlock)(NSMutableArray* listOfModelBaseObjects,NSString* responseJson);
typedef void (^DictionaryBlock)(NSDictionary* mapOfModelBaseObjects);
typedef void (^DoubleBlock)(double doubleValue);
typedef void (^ErrorBlock)(NSError* engineError);

@interface RESTEngine : NSObject
+(AFHTTPRequestOperation*)fetchJokesWithType:(NSString*)type page:(NSString*)page random:(BOOL)random radomNo:(NSNumber*)radomNo timestamp:(NSString*)timestamp onSuccessed:(void (^)(JokeXmlModel* xmlModel)) successBlock onError:(void(^)(NSError* engineError)) errorBlock;

+(YyconNetworkStatus)detectNetworkStatus;

+(id)getAppStoreInfoOnSucceeded:(DictionaryBlock) succeededBlock
                        onError:(ErrorBlock) errorBlock;
@end
