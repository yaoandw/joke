//
//  XMLReader.h
//  joke
//
//  Created by yaoandw on 14-5-7.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Joke.h"
#import "JokeXmlModel.h"

@interface XMLReader : NSObject<NSXMLParserDelegate>
{
    NSMutableString *textInProgress;
    NSError *errorPointer;
}
@property (nonatomic, strong) Joke *currentJokeObject;
@property (nonatomic,strong) NSMutableArray *jokeArray;
@property (nonatomic,strong) NSString *timestamp;

+ (JokeXmlModel *)jokeArrayForXMLData:(NSData *)data error:(NSError *)errorPointer;



@end
