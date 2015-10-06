//
//  UIImageView+Qyes.h
//  QyesIOS
//
//  Created by yaoandw on 14-10-16.
//  Copyright (c) 2014年 qyes. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView (yycon)
- (void)setYyconImageWithURL:(NSURL *)url;
- (void)setYyconImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage;
- (void)setYyconImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;
@end
