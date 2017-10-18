//
//  IntegralProductDetailViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/17.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "IntegralProductDetailViewController.h"
#import "SDCycleScrollView.h"
#import "IntegralConfirmViewController.h"
#import "IntegralProductModel.h"
#import "IntegralProductDetailModel.h"

@interface IntegralProductDetailViewController ()<SDCycleScrollViewDelegate,UIWebViewDelegate>

@property (nonatomic, strong)UIScrollView *mainScrollView;
@property (nonatomic, strong)UIView *mainView;
@property (nonatomic, strong)IntegralProductDetailModel *integralProductDetailModel;

@end

@implementation IntegralProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getProductDetailMethod];
    
}

- (void)getProductDetailMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Goods/detail" withParamDictionary:@{@"goods_id":self.integralProductModel.id} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSDictionary *dic = obj[@"data"];
            _integralProductDetailModel = [IntegralProductDetailModel mj_objectWithKeyValues:dic];
            [self setUpViewDesign];
            [SVProgressHUD dismiss];
        } else {
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            [SVProgressHUD dismiss];
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
    }];
}

- (void)setUpViewDesign {
    UIButton *exchangeButton = [[UIButton alloc]init];
    [exchangeButton setTitle:@"立即兑换" forState:UIControlStateNormal];
    [exchangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    exchangeButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    [exchangeButton setBackgroundColor:RGBA(255, 86, 30, 1.0)];
    [exchangeButton addTarget:self action:@selector(jumpToConfirmIntegralVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exchangeButton];
    [exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(49));
    }];
    
    self.mainScrollView = [[UIScrollView alloc]init];
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(exchangeButton.mas_top);
    }];
    
    self.mainView = [[UIView alloc]init];
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mainScrollView);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]initWithArray:@[_integralProductDetailModel.pic]];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RESIZE_UI(280)) imageURLStringsGroup:nil]; // 模拟网络延时情景
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.delegate = self;
    if (imagesURLStrings.count == 1) {
        cycleScrollView.autoScroll = NO;
    } else {
        cycleScrollView.autoScroll = YES;
    }
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycleScrollView.dotColor = RGBA(255, 84, 34, 1.0); // 自定义分页控件小圆标颜色
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    //             --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    });
    [self.mainView addSubview:cycleScrollView];
    
    //轮播图下方内容
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = RGBA(238, 240, 242, 1.0);
    [self.mainView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cycleScrollView.mas_bottom);
        make.left.equalTo(self.mainView.mas_left);
        make.right.equalTo(self.mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(107));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = _integralProductDetailModel.name;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    titleLabel.numberOfLines = 2;
    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).with.offset(RESIZE_UI(12));
        make.left.equalTo(contentView.mas_left).with.offset(RESIZE_UI(12));
        make.right.equalTo(contentView.mas_right).with.offset(-RESIZE_UI(17));
        make.height.mas_offset(RESIZE_UI(50));
    }];
    
    UILabel *stockLabel = [[UILabel alloc]init];
    stockLabel.textColor = RGBA(153, 153, 153, 1.0);
    stockLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    stockLabel.text = [NSString stringWithFormat:@"当前库存%@个",_integralProductDetailModel.inventory];
    [contentView addSubview:stockLabel];
    [stockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(RESIZE_UI(13));
        make.left.equalTo(titleLabel.mas_left);
    }];
    
    UILabel *integralTitleLabel = [[UILabel alloc]init];
    integralTitleLabel.text = @"积分";
    integralTitleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    integralTitleLabel.textColor = RGBA(153, 153, 153, 1.0);
    [contentView addSubview:integralTitleLabel];
    [integralTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(stockLabel.mas_bottom);
        make.right.equalTo(contentView.mas_right).with.offset(-RESIZE_UI(15));
        make.height.mas_offset(RESIZE_UI(17));
    }];
    
    UILabel *integralLabel = [[UILabel alloc]init];
    integralLabel.text = _integralProductDetailModel.need_score;
    integralLabel.textColor = RGBA(255, 88, 26, 1.0);
    integralLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(20)];
    [contentView addSubview:integralLabel];
    [integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(stockLabel.mas_bottom).with.offset(RESIZE_UI(4));
        make.right.equalTo(integralTitleLabel.mas_left).with.offset(-RESIZE_UI(2));
        make.height.mas_offset(RESIZE_UI(28));
    }];
    
    UIView *proDetailView = [[UIView alloc]init];
    proDetailView.backgroundColor = [UIColor whiteColor];
    [self.mainView addSubview:proDetailView];
    [proDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).with.offset(RESIZE_UI(12));
        make.height.mas_offset(RESIZE_UI(46));
    }];
    
    UILabel *redLine = [[UILabel alloc]init];
    redLine.backgroundColor = RGBA(255, 82, 37, 1.0);
    [self.view addSubview:redLine];
    [proDetailView addSubview:redLine];
    [redLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(proDetailView.mas_centerY);
        make.left.equalTo(self.view.mas_left);
        make.width.mas_offset(RESIZE_UI(5));
        make.height.mas_offset(RESIZE_UI(17));
    }];
    
    UILabel *proDetailLabel = [[UILabel alloc]init];
    proDetailLabel.text = @"商品详情";
    proDetailLabel.textColor = RGBA(102, 102, 102, 1.0);
    proDetailLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [proDetailView addSubview:proDetailLabel];
    [proDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(proDetailView.mas_centerY);
        make.left.equalTo(redLine.mas_right).with.offset(RESIZE_UI(8));
    }];
    
    UIWebView *detailWebView = [[UIWebView alloc]init];
    detailWebView.scrollView.scrollEnabled = NO;
    detailWebView.scrollView.showsVerticalScrollIndicator = NO;
    detailWebView.delegate = self;
    [detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_integralProductDetailModel.detail]]];
    [detailWebView sizeToFit];
    [self.mainView addSubview:detailWebView];
    [detailWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(proDetailView.mas_bottom);
        make.left.equalTo(self.mainView.mas_left);
        make.right.equalTo(self.mainView.mas_right);
        make.height.mas_offset(100);
    }];
    
    [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(detailWebView.mas_bottom);
    }];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}

- (void)jumpToConfirmIntegralVC {
    
    CGFloat myScore = [[SingletonManager sharedManager].userModel.score floatValue];
    CGFloat needScore = [_integralProductDetailModel.need_score floatValue];
    if (myScore>=needScore) {
        IntegralConfirmViewController *integralConfirmVC = [[IntegralConfirmViewController alloc]init];
        integralConfirmVC.integralProductDetailModel = _integralProductDetailModel;
        [self.navigationController pushViewController:integralConfirmVC animated:YES];
    } else {
        [[SingletonManager sharedManager] showHUDView:self.view title:@"您当前积分不足" content:@"" time:1.0 andCodes:^{
            
        }];
    }
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD showWithStatus:@"加载中"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
//    CGRect frame = webView.frame;
//    frame.size.width = 768;
//    frame.size.height = 1;
//
//    //    wb.scrollView.scrollEnabled = NO;
//    webView.frame = frame;
//
//    frame.size.height = webView.scrollView.contentSize.height;
//
//    NSLog(@"frame = %.2f", frame.size.height);
//    webView.frame = frame;
//    [webView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_offset(frame.size.height);
//    }];
    
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
//    NSLog(@"我的高度:%.2f",fittingSize.height);
    [webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(fittingSize.height-20);
    }];
    
//    CGFloat documentWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').offsetWidth"] floatValue];
//    CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] floatValue];
//    NSLog(@"documentSize = {%f, %f}", documentWidth, documentHeight);
//    [webView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_offset(documentHeight);
//    }];
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
