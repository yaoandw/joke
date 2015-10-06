//
//  XMLReader.m
//  joke
//
//  Created by yaoandw on 14-5-7.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "XMLReader.h"
#import "NSString+yycon.h"

NSString *const kXMLReaderTextNodeKey = @"text";

@interface XMLReader (Internal)

- (id)initWithError:(NSError *)error;
- (JokeXmlModel *)objectWithData:(NSData *)data;

@end

@implementation XMLReader

#pragma mark -
#pragma mark Public methods

+ (JokeXmlModel *)jokeArrayForXMLData:(NSData *)data error:(NSError *)errorPointer;
{
    XMLReader *reader = [[XMLReader alloc] initWithError:errorPointer];
    JokeXmlModel *resultDict = [reader objectWithData:data];
    return resultDict;
}

#pragma mark -
#pragma mark Parsing

- (id)initWithError:(NSError *)error
{
    if (self = [super init])
    {
        errorPointer = error;
    }
    return self;
}

- (void)dealloc
{
    
}

- (JokeXmlModel *)objectWithData:(NSData *)data
{
    
    self.jokeArray = [NSMutableArray array];
    textInProgress = [[NSMutableString alloc] init];
    
    // Parse the XML
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    BOOL success = [parser parse];
    
    // Return the stack’s root dictionary on success
    if (success)
    {
        JokeXmlModel *xml = [[JokeXmlModel alloc] init];
        [xml setTimestamp:self.timestamp];
        [xml setJokeArray:self.jokeArray];
        return xml;
    }
    
    return nil;
}

#pragma mark -
#pragma mark NSXMLParserDelegate methods

static NSString * const kJokeElementName = @"joke";
static NSString * const kIdElementName = @"id";
static NSString * const kNameElementName = @"name";
static NSString * const kTimeElementName = @"time";
static NSString * const kTextElementName = @"text";
static NSString * const kImgurlElementName = @"imgurl";
static NSString * const kThmurlElementName = @"thmurl";
static NSString * const kForwardElementName = @"forward";
static NSString * const kCommendElementName = @"commend";
static NSString * const kCommentElementName = @"comment";
static NSString * const kVideourlElementName = @"videourl";

static NSString * const kTimestampElementName = @"timestamp";

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kJokeElementName]) {
        Joke *joke = [[Joke alloc] init];
        self.currentJokeObject = joke;
        
        textInProgress = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:kTimestampElementName]){
        textInProgress = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:kJokeElementName]) {
        [self.jokeArray addObject:self.currentJokeObject];
    }else if ([elementName isEqualToString:kTextElementName]) {
        [self.currentJokeObject setContent:[textInProgress processXmlContent]];
        textInProgress = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:kIdElementName] || [elementName isEqualToString:kNameElementName]||[elementName isEqualToString:kTimeElementName]||[elementName isEqualToString:kImgurlElementName]||[elementName isEqualToString:kThmurlElementName]||[elementName isEqualToString:kForwardElementName]||[elementName isEqualToString:kCommendElementName]||[elementName isEqualToString:kCommentElementName]||[elementName isEqualToString:kVideourlElementName]) {
        [self.currentJokeObject setValue:[textInProgress processXmlContent] forKey:elementName];
        textInProgress = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:kTimestampElementName]){
        self.timestamp = [textInProgress processXmlContent];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // Build the text value
    [textInProgress appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    // Set the error pointer to the parser’s error object
    errorPointer = parseError;
}

@end
