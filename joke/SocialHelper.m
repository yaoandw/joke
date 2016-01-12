//
//  SocialHelper.m
//  joke
//
//  Created by yaoandw on 14/12/22.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "SocialHelper.h"
#import "WXApi.h"
#import "FileUtil.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import <AVOSCloudSNS.h>
#import "SocialShareDelegate.h"


@implementation SocialHelper
+(void)registerAppWithDelegate:(id) delegate{
    [WXApi registerApp:@"wx7a6709b4f6733a36"];
    [[TencentOAuth alloc] initWithAppId:@"1101718393" andDelegate:delegate];
}
+(BOOL) handleOpenURL:(NSURL *) url delegate:(id) delegate{
    return [AVOSCloudSNS handleOpenURL:url];
}

+ (void) sendJokeToWeixin:(AVObject*)joke{
    [self sendJokeToWX:joke wxScene:WXSceneSession];
}
+ (void) sendJokeToWeixinTimeline:(AVObject*)joke{
    [self sendJokeToWX:joke wxScene:WXSceneTimeline];
}
+ (void) sendJokeToWX:(AVObject*)joke wxScene:(int)wxScene{
    if (![WXApi isWXAppInstalled]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"微信没有安装" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSString *thmurl = joke[@"thmurl"];
    if (thmurl.length > 0){//如果是笑图
        [self sendJokeAsArticle:joke wxScene:wxScene];
    }else{
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = [NSString stringWithFormat:@"%@【来自笑哈哈】", joke[@"content"]];
        req.bText = YES;
        req.scene = wxScene;
        
        [WXApi sendReq:req];
    }
    
    
}
+(void)sendJokeAsArticle:(AVObject*)joke wxScene:(int)wxScene{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    WXMediaMessage* message = [WXMediaMessage message];
    message.title = joke[@"content"];
    message.description = joke[@"content"];
    
    NSURL *imageUrl = [NSURL URLWithString:joke[@"thmurl"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageUrl];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    UIImage *localCachedImage = [FileUtil cachedAFNetworkingImageForRequest:request];
    
    CGFloat maxLength = 500;
    
    UIImage *resizedImage = [FileUtil scaleToSize:localCachedImage maxLength:maxLength];
    /*NSData* imageData = UIImagePNGRepresentation(resizedImage);// UIImageJPEGRepresentation(localCachedImage, 0.01);
     if(imageData.length > 360000){
     resizedImage = [FileUtil scaleToSize:localCachedImage maxLength:400];
     }
     if(imageData.length > 360000){
     resizedImage = [FileUtil scaleToSize:localCachedImage maxLength:300];
     }*/
    
    //UIImage *thumb = [UIImage imageWithData:imageData];// [UIImage imageNamed:@"delete2.png"];
    [message setThumbImage:resizedImage];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    
    NSString *videourl = joke[@"videourl"];
    if (videourl.length>0) {
        ext.webpageUrl = videourl;
    }else{
        ext.webpageUrl = joke[@"imgurl"];
    }
    
    message.mediaObject = ext;
    
    req.bText = NO;
    req.message = message;
    req.scene = wxScene;
    
    while (![WXApi sendReq:req]) { // 图片最多只能 32k
        maxLength = maxLength/2;
        resizedImage = [FileUtil scaleToSize:localCachedImage maxLength:maxLength];
        [message setThumbImage:resizedImage];
    }
}


+ (void) sendJokeToQQ:(AVObject*)joke{
    SendMessageToQQReq *req = [self doInitQQReq:joke];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
}
+ (void) sendJokeToQZone:(AVObject*)joke{
    SendMessageToQQReq *req = [self doInitQQReq:joke];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
}
+(SendMessageToQQReq*)doInitQQReq:(AVObject*)joke{
    NSString *thmurl = joke[@"thmurl"];
    if (thmurl.length > 0){//如果是笑图
        NSString *utf8String = @"http://www.163.com";
        NSString *videourl = joke[@"videourl"];
        if (videourl.length>0) {
            utf8String = videourl;
        }else{
            utf8String = joke[@"imgurl"];
        }
        NSString *title = joke[@"content"];
        NSString *description = joke[@"content"];
        NSString *previewImageUrl = thmurl;
        QQApiNewsObject *newsObj = [QQApiNewsObject
                                    objectWithURL:[NSURL URLWithString:utf8String]
                                    title:title
                                    description:description
                                    previewImageURL:[NSURL URLWithString:previewImageUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        
        return req;
    }else{
        QQApiTextObject *txtObj = [QQApiTextObject objectWithText:joke[@"content"]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
        return req;
    }
}

+(void)showShareActionSheetWithJoke:(AVObject*)joke{
    SocialShareDelegate *dele = [SocialShareDelegate getInstanceWithJoke:joke];
    //qq空间不支持纯文本的分享
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"分享到..." delegate:dele cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信",@"微信朋友圈",@"qq", nil];
    NSString *thmurl = joke[@"thmurl"];
    if (thmurl.length > 0){//如果是笑图
        sheet = [[UIActionSheet alloc] initWithTitle:@"分享到..." delegate:dele cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信",@"微信朋友圈",@"qq",@"qq空间", nil];
    }
    [sheet showInView:MyAppDelegate.window];
}
@end
