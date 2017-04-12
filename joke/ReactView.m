//
//  ReactView.m
//  joke
//
//  Created by yaoandw on 15/8/21.
//  Copyright (c) 2015年 yycon. All rights reserved.
//

#import "ReactView.h"
//#import "RCTRootView.h"

@implementation ReactView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSURL *jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle"];
        // For production use, this `NSURL` could instead point to a pre-bundled file on disk:
        //
        //   NSURL *jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
        //
        // To generate that file, run the curl command and add the output to your main Xcode build target:
        //
        //   curl http://localhost:8081/index.ios.bundle -o main.jsbundle
//        RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation moduleName:@"SimpleApp" initialProperties:nil launchOptions:nil];
//        [self addSubview:rootView];
//        rootView.frame = self.bounds;
    }
    return self;
}
@end
