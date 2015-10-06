//
//  PullDownUpRefreshViewController.h
//  QyesIOS
//
//  Created by yaoandw on 13-10-13.
//  Copyright (c) 2013年 qyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullDownUpRefreshViewController : UITableViewController{
    UIView *refreshFooterView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
}

@property (nonatomic, strong) UIView *refreshFooterView;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UIImageView *refreshArrow;
@property (nonatomic, strong) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, strong) NSString *textPull;
@property (nonatomic, strong) NSString *textRelease;
@property (nonatomic, strong) NSString *textLoading;
@property (nonatomic, strong) NSString *textNoMore;
@property (nonatomic) BOOL hasMore;

- (void)setupStrings;
- (void)addPullToRefreshFooter;
- (void)startLoading;
- (void)stopLoading;
- (void)loadMore;

@end
