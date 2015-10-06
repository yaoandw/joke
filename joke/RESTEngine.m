//
//  RESTEngine.m
//  joke
//
//  Created by yaoandw on 14-5-7.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "RESTEngine.h"
#import "XMLReader.h"
#import "NSDate+yycon.h"
#import "Reachability.h"
#import "NSString+yycon.h"
#import "AppDelegate.h"

@implementation RESTEngine
+(AFHTTPRequestOperation*)fetchJokesWithType:(NSString*)type page:(NSString*)page random:(BOOL)random radomNo:(NSNumber*)radomNo timestamp:(NSString*)timestamp onSuccessed:(void (^)(JokeXmlModel* xmlModel)) successBlock onError:(void(^)(NSError* engineError)) errorBlock{
    //NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"http://myPath/Iphone/method" parameters:params];
    NSString *urlString = [NSString stringWithFormat:@"http://joke.zaijiawan.com/Joke/joke2.jsp?appname=readingxiaonimei&version=3.10.0&os=ios&hardware=iphone&sort=%@&page=%@&timestamp=%@",type,page,encodeToPercentEscapeString(timestamp)];
    if (random) {
        
        urlString = [NSString stringWithFormat:@"http://joke.zaijiawan.com/Joke/joke2_random.jsp?appname=readingxiaonimei&version=3.10.0&os=ios&hardware=iphone&sort=%@&page=%@&tryno=%@&timestamp=%@",type,page,radomNo,encodeToPercentEscapeString(timestamp)];
    }
    DLog(@"urlString:%@",urlString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *error;
        JokeXmlModel *xml = [XMLReader jokeArrayForXMLData:responseObject error:error];
        DLog(@"xmlModel:%@",xml);
        successBlock(xml);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
    [operation start];
    return operation;
}
//html encode
NSString *encodeToPercentEscapeString(NSString *string) {
    return (__bridge NSString *)
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (CFStringRef) string,
                                            NULL,
                                            (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
}

+(YyconNetworkStatus)detectNetworkStatus{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        return YyconNotReachable;
    }
    else if (status == ReachableViaWiFi)
    {
        return YyconReachableViaWiFi;
    }
    else if (status == ReachableViaWWAN)
    {
        return YyconReachableViaWWAN;
    }else{
        return YyconReachableUnknow;
    }
}

+(id)getAppStoreInfoOnSucceeded:(DictionaryBlock) succeededBlock
                        onError:(ErrorBlock) errorBlock{
    NSString *urlString = [NSString stringWithFormat:@"%@",APPINFO_ON_ITUNES_URL];
    DLog(@"urlString:%@",urlString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        succeededBlock([responseString jsonToDict]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(error);
    }];
    [operation start];
    return operation;
}
@end