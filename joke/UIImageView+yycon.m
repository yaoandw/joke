//
//  UIImageView+Qyes.m
//  QyesIOS
//
//  Created by yaoandw on 14-10-16.
//  Copyright (c) 2014年 qyes. All rights reserved.
//

#import "UIImageView+yycon.h"
#import "FileUtil.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"

@implementation UIImageView (yycon)
- (void)setYyconImageWithURL:(NSURL *)url{
    [self setYyconImageWithURL:url placeholderImage:nil];
}
- (void)setYyconImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholderImage{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self setYyconImageWithURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}
- (void)setYyconImageWithURLRequest:(NSURLRequest *)urlRequest
                  placeholderImage:(UIImage *)placeholderImage
                           success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                           failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure{
    UIImage *cachedImage = [[[self class] sharedImageCache] cachedImageForRequest:urlRequest];
    if (cachedImage) {
        if (success) {
            success(nil, nil, cachedImage);
        } else {
            self.image = cachedImage;
        }
        
        [self cancelImageRequestOperation];
    }else{
        //本地缓存 start
        UIImage *localCachedImage = [FileUtil cachedAFNetworkingImageForRequest:urlRequest];
        if (localCachedImage) {
            if (success) {
                success(nil, nil, localCachedImage);
            } else {
                self.image = localCachedImage;
            }
            [[[self class] sharedImageCache] cacheImage:localCachedImage forRequest:urlRequest];
            [self cancelImageRequestOperation];
            return;
        }
        //本地缓存end
        
        __weak __typeof(self)weakSelf = self;
        NSMutableURLRequest *mUrlRequest = [[NSMutableURLRequest alloc] initWithURL:urlRequest.URL];
        [mUrlRequest setTimeoutInterval:yycon_request_timeout];
        [self setImageWithURLRequest:mUrlRequest placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (success) {
                success(request,response,image);
            }else if (image) {
                strongSelf.image = image;
            }
            //本地缓存
            [FileUtil cacheAFNetworkingImage:image forRequest:urlRequest];
        } failure:failure];
    }
}
@end
