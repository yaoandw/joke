//
//  JokeXmlModel.m
//  joke
//
//  Created by yaoandw on 14-5-12.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "JokeXmlModel.h"

@implementation JokeXmlModel
//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.timestamp forKey:@"timestamp"];
    [encoder encodeObject:self.jokeArray forKey:@"jokeArray"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.timestamp = [decoder decodeObjectForKey:@"timestamp"];
        self.jokeArray = [decoder decodeObjectForKey:@"jokeArray"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setTimestamp:[self.timestamp copy]];
    [theCopy setJokeArray:[self.jokeArray copy]];
    
    return theCopy;
}
@end
