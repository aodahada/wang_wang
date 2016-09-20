//
//  AgreementViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/12/16.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@property (nonatomic, copy) UIWebView *webView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *txtLable;

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = self.titName;
    
    NSError *error=nil;
    NSString *introStr=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.selectIndex ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64)];
    [self.view addSubview:_scrollView];
    
    _txtLable = [[UILabel alloc] init];
    _txtLable.text = introStr;
    _txtLable.backgroundColor = VIEWBACKCOLOR;
    _txtLable.numberOfLines = 0;
    _txtLable.textColor = TITLE_COLOR;
    _txtLable.textAlignment = NSTextAlignmentLeft;
    _txtLable.contentMode = UIViewContentModeTopLeft;
    _txtLable.font = [UIFont systemFontOfSize:13.0];
    CGFloat height = [_txtLable.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - RESIZE_UI(30), CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil].size.height;
    _txtLable.frame = CGRectMake(0, 0, SCREEN_WIDTH - RESIZE_UI(30), height);
    [_scrollView addSubview:_txtLable];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH - RESIZE_UI(30), height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
