//
//  PullDownUpRefreshViewController.m
//  QyesIOS
//
//  Created by yaoandw on 13-10-13.
//  Copyright (c) 2013年 qyes. All rights reserved.
//

#import "PullDownUpRefreshViewController.h"
#define REFRESH_HEADER_HEIGHT 52.0f
@interface PullDownUpRefreshViewController ()

@end

@implementation PullDownUpRefreshViewController

@synthesize textPull, textRelease, textLoading, refreshFooterView, refreshLabel, refreshArrow, refreshSpinner, hasMore, textNoMore;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPullToRefreshHeader];
    [self addPullToRefreshFooter];
}

-(void)addPullToRefreshHeader{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshedByPullingTable:) forControlEvents:UIControlEventValueChanged];
}
-(void) refreshedByPullingTable:(id) sender {
    
    [self.refreshControl beginRefreshing];
    [self doRefresh];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.refreshControl endRefreshing];
    });
}

-(void) doRefresh
{
    NSLog(@"Override doRefresh in subclass. This line should not appear on console");
}

- (void)setupStrings{
    textPull    = @"上拉刷新...";
    textRelease = @"释放开始刷新...";
    textLoading = @"正在加载...";
    textNoMore  = @"没有更多内容了...";
    hasMore = YES;
}

-(void)addPullToRefreshFooter{
    NSLog(@"self.tableView.frame.size.height:%f",self.tableView.frame.size.height);
    NSLog(@"self.tableView.contentSize.height:%f",self.tableView.contentSize.height);
    refreshFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height+20, 320, REFRESH_HEADER_HEIGHT)];
    refreshFooterView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshFooterView addSubview:refreshLabel];
    [refreshFooterView addSubview:refreshArrow];
    [refreshFooterView addSubview:refreshSpinner];
    [self.tableView addSubview:refreshFooterView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading && scrollView.contentOffset.y > 0) {
        // Update the content inset, good for section headers
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, REFRESH_HEADER_HEIGHT, 0);
    }else if(!hasMore){
        refreshLabel.text = self.textNoMore;
        refreshArrow.hidden = YES;
    }else if (isDragging && scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom) <= 0 ) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        refreshArrow.hidden = NO;
        if (scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom) <= -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading || !hasMore) return;
    isDragging = NO;
    
    //    CGPoint offset = scrollView.contentOffset;
    //    CGRect bounds = scrollView.bounds;
    //    CGSize size = scrollView.contentSize;
    //    UIEdgeInsets inset = scrollView.contentInset;
    //    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    //
    //    CGFloat maximumOffset = size.height;
    //
    //    (maximumOffset - currentOffset) <= -REFRESH_HEADER_HEIGHT)
    
    //上拉刷新
    if(scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom) <= -REFRESH_HEADER_HEIGHT && scrollView.contentOffset.y > 0){
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self loadMore];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.tableView.contentInset = UIEdgeInsetsZero;
    UIEdgeInsets tableContentInset = self.tableView.contentInset;
    tableContentInset.top = 0.0;
    self.tableView.contentInset = tableContentInset;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    NSLog(@"%f",self.tableView.contentSize.height);
    
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    
    [refreshFooterView setFrame:CGRectMake(0, self.tableView.contentSize.height, 320, 0)];
    
    [refreshSpinner stopAnimating];
}

- (void)loadMore {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
    
}




@end
