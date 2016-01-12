//
//  NewCommentController.m
//  joke
//
//  Created by yaoandw on 15/10/18.
//  Copyright © 2015年 yycon. All rights reserved.
//

#import "NewCommentController.h"
#import "LeanCloudHelper.h"
#import "UIView+Toast.h"
#import "UIAlertView+yycon.h"

@interface NewCommentController ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *commentTextView;
@property(nonatomic,strong)AVObject *joke;
@property(nonatomic,assign)id delegate;
@end

@implementation NewCommentController

-(id)initWithJoke:(AVObject*)joke delegate:(id)delegate{
    self = [self init];
    if (self) {
        self.joke = joke;
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpCommentTextView];
    [self setUpLeftButton];
    [self setUpRightButton];
}

-(void)setUpCommentTextView{
    self.commentTextView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.commentTextView.delegate = self;
    [self.commentTextView setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:self.commentTextView];
    [self.commentTextView becomeFirstResponder];
}

-(void)setUpLeftButton{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleBordered) target:self action:@selector(leftButtonTapped:)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

-(void)setUpRightButton{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:(UIBarButtonItemStyleBordered) target:self action:@selector(rightButtonTapped:)];
    [rightButton setEnabled:NO];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void)leftButtonTapped:(id)sender{
    if ([self.delegate respondsToSelector:@selector(viewDismissed)]) {
        [self.delegate viewDismissed];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)rightButtonTapped:(id)sender{
    NSString *content = [self.commentTextView.text stringByTrimmingCharactersInSet:( [NSCharacterSet whitespaceAndNewlineCharacterSet])];
    if (content.length <= 0) {
        [self.view makeToast:@"请输入内容" duration:3.0 position:CSToastPositionCenter];
        return;
    }
    [LeanCloudHelper saveComment:content withJoke:self.joke onSuccess:^{
        if ([self.delegate respondsToSelector:@selector(commentHasSent)]) {
            [self.delegate commentHasSent];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } onError:^(NSError *error) {
        [UIAlertView showWithError:error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)textViewDidChange:(UITextView *)textView{
    NSString *content = [self.commentTextView.text stringByTrimmingCharactersInSet:( [NSCharacterSet whitespaceAndNewlineCharacterSet])];
    if (content.length > 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }else{
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
