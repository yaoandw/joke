//
//  Joke.m
//  joke
//
//  Created by yaoandw on 14-5-7.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "Joke.h"

@implementation Joke
//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.time forKey:@"time"];
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeObject:self.imgurl forKey:@"imgurl"];
    [encoder encodeObject:self.thmurl forKey:@"thmurl"];
    [encoder encodeObject:self.commend forKey:@"commend"];
    [encoder encodeObject:self.comment forKey:@"comment"];
    [encoder encodeObject:self.forward forKey:@"forward"];
    [encoder encodeObject:self.videourl forKey:@"videourl"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.id = [decoder decodeObjectForKey:@"id"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.time = [decoder decodeObjectForKey:@"time"];
        self.content = [decoder decodeObjectForKey:@"content"];
        self.imgurl = [decoder decodeObjectForKey:@"imgurl"];
        self.thmurl = [decoder decodeObjectForKey:@"thmurl"];
        self.commend = [decoder decodeObjectForKey:@"commend"];
        self.comment = [decoder decodeObjectForKey:@"comment"];
        self.forward = [decoder decodeObjectForKey:@"forward"];
        self.videourl = [decoder decodeObjectForKey:@"videourl"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setId:[self.id copy]];
    [theCopy setName:[self.name copy]];
    [theCopy setTime:[self.time copy]];
    [theCopy setContent:[self.content copy]];
    [theCopy setImgurl:[self.imgurl copy]];
    [theCopy setCommend:[self.commend copy]];
    [theCopy setComment:[self.comment copy]];
    [theCopy setForward:[self.forward copy]];
    [theCopy setVideourl:[self.videourl copy]];
    [theCopy setThmurl:[self.thmurl copy]];
    
    return theCopy;
}

-(AVObject*)parseToAVObject{
    AVObject *avJoke = [AVObject objectWithClassName:@"Joke"];
    [avJoke setObject:self.id forKey:@"jokeId"];
    [avJoke setObject:self.name forKey:@"name"];
    [avJoke setObject:self.time forKey:@"time"];
    [avJoke setObject:self.content forKey:@"content"];
    [avJoke setObject:self.imgurl forKey:@"imgurl"];
    [avJoke setObject:self.thmurl forKey:@"thmurl"];
    [avJoke setObject:self.videourl forKey:@"videourl"];
    [avJoke setObject:[NSNumber numberWithInt:0] forKey:@"forward"];
    [avJoke setObject:[NSNumber numberWithInt:0] forKey:@"support"];
    [avJoke setObject:[NSNumber numberWithInt:0] forKey:@"comment"];
    [avJoke setObject:[NSNumber numberWithInt:0] forKey:@"favorite"];
    return avJoke;
}
@end
