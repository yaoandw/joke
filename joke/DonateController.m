//
//  DonateController.m
//  joke
//
//  Created by yaoandw on 14-7-22.
//  Copyright (c) 2014年 yycon. All rights reserved.
//

#import "DonateController.h"
#import "ColorUtil.h"

@interface DonateController ()
@property(nonatomic,strong)UILabel *label;
@end

@implementation DonateController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    // Do any additional setup after loading the view.
    self.title = @"捐赠";
    NSString *text = @"    如果您觉得本应用'笑哈哈'的笑话、笑图让你在平淡忙碌的生活中感到一丝的轻松愉悦，想要感谢作者，那您可以考虑给我捐赠\n\n支付宝账号:yaoandw@163.com\n\n      姓名:姚蔚";
    CGSize maximumSize = CGSizeMake(300, 9999);
    UIFont *dateFont = [UIFont systemFontOfSize:16];
    CGSize dateStringSize = [text sizeWithFont:dateFont
                             constrainedToSize:maximumSize
                                 lineBreakMode:NSLineBreakByWordWrapping];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, dateStringSize.height)];
    
    NSAttributedString *attributedString =[[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName : [ColorUtil getFontMainColor],NSKernAttributeName : @(0.0f),NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    [self.label setAttributedText:attributedString];
    
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.numberOfLines = 0;
    [self.label setTextColor:fontColor_main];
    self.label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.label];
    
    [self.tableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ColorUtil setStyle2ForTableViewController:self];
    
    NSAttributedString *attString = self.label.attributedText;
    NSMutableAttributedString *mAttString = [[NSMutableAttributedString alloc] initWithAttributedString:attString];
    [mAttString addAttribute:NSForegroundColorAttributeName value:[ColorUtil getFontMainColor] range:NSMakeRange(0, attString.length)];
    [self.label setAttributedText:mAttString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
