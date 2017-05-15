//
//  ProductIntroViewController.m
//  wangmajinrong
//
//  Created by 1 & 0 on 15/6/24.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "ProductIntroViewController.h"
//#import "FundBuyViewController.h"
#import "ProductListViewController.h"
//#import "proIntroModel.h"
#import "ProductModel.h"
#import "LoginViewController.h"

#import "PopMenu.h"
#import "SharedView.h"
#import "MMPopupItem.h"
#import "MMPopupWindow.h"
#import "RealNameCertificationViewController.h"
#import "ShowBigImageView.h"
#import "AgViewController.h"
#import "BaseNavigationController.h"
#import "HRBuyViewController.h"

#import "ViewForShuoMing.h"
#import "ViewForJianJie.h"
#import "AddBankViewController.h"
#import "LongProductSegment.h"

@interface ProductIntroViewController ()  //ISSShareViewDelegate
{
    UIImageView *_imageViewForTitle;//图标
    UILabel *_billLable;//票据
//    UILabel *_bankAcceptLable;//银行承兑
    UILabel *_earnOfYearLable;//收益描述
    UILabel *_earnOfPercent;//收益百分比
    
    UILabel *_financingLable;
    UILabel *_financingNum;//融资余额
    UILabel *_financingTermLable;
    UILabel *_financingOfdays;//融资期限
    UILabel *_riskLable;
    UILabel *_financingRisk;//融资风险
    
    PopMenu *_popMenu;
    SharedView *_sharedView;
    
}

@property (nonatomic, strong) ProductModel *productModel;

@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, assign) BOOL isCheck;

@property (nonatomic, strong) UILabel *labelForShuoMing;
@property (nonatomic, strong) UILabel *labelForJianJie;
@property (nonatomic, strong) UIButton *buttonForShuoMing;
@property (nonatomic, strong) UIButton *buttonForJianJie;

@property (nonatomic, strong) ViewForShuoMing *viewForShuoMing;
@property (nonatomic, strong) ViewForJianJie *viewForJianJie;
@property (nonatomic, strong) UIView *viewForBottomIntroduce;

@property (nonatomic, weak) UIView *viewMainBottom;

@end

@implementation ProductIntroViewController

/* 设置导航条 */
- (void)setUpNavigationBar {
    
    /* 分享 */
    UIImage *imageHelp = [[UIImage imageNamed:@"icon_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *sharedBtn = [[UIBarButtonItem alloc] initWithImage:imageHelp style:UIBarButtonItemStylePlain target:self action:@selector(sharedBtnAction)];
    self.navigationItem.rightBarButtonItem = sharedBtn;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    [self setUpNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isCheck = YES;
//    self.title = @"产品介绍";
    self.view.backgroundColor = RGBA(240, 240, 240, 1.0);
    //数据请求
    [self getDataWithNetManager];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noSelectContract) name:@"noselectContract" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectContract) name:@"selectContract" object:nil];
    
}

- (void)noSelectContract {
    
    _isCheck = NO;
    
}

- (void)selectContract {
    
    _isCheck = YES;
    
}

#pragma mark - 数据处理 －
- (void)getDataWithNetManager {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
//    NSDictionary *paramDic = @{@"product_id":self.getPro_id};
    NSDictionary *paramDic = @{@"is_recommend":@"1", @"page":@"1", @"size":@"1",@"is_long":@"0",@"product_id":self.getPro_id};
    [manager postDataWithUrlActionStr:@"Finance/index" withParamDictionary:paramDic withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [ProductModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"segment":@"LongProductSegment"
                         };
            }];
            _productModel = [ProductModel mj_objectWithKeyValues:obj[@"data"][0]];
            _productModel.type_id = _type_id;
            _productModel.proIntro_id = self.getPro_id;
            /* 立即购买 */
            [self configViewWithBuy];
            
            //主界面布局
            [self setUpLayOut];
            
            if ([_productModel.isdown isEqualToString:@"0"]) {
                _buyBtn.enabled = YES;
                [_buyBtn setBackgroundColor:RGBA(255, 86, 45, 1.0)];
                [_buyBtn setTitle:@"立 即 购 买" forState:UIControlStateNormal];
                [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else {
                _buyBtn.enabled = NO;
                [_buyBtn setBackgroundColor:RGBA(234, 234, 234, 1.0)];
                [_buyBtn setTitle:@"已售罄" forState:UIControlStateNormal];
                [_buyBtn setTitleColor:RGBA(164, 164, 164, 1.0) forState:UIControlStateNormal];
            }
            
            [SVProgressHUD dismiss];
            
        } else {
            [SVProgressHUD showErrorWithStatus:[obj[@"data"] objectForKey:@"mes"]];
        }
    }];
}

#pragma mark - 界面布局
- (void)setUpLayOut {
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = RGBA(240, 240, 240, 1.0);
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(_buyBtn.mas_top);
    }];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = RGBA(240, 240, 240, 1.0);
    [scrollView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(scrollView);
        make.top.equalTo(scrollView.mas_top);
        make.left.equalTo(scrollView.mas_left);
        make.right.equalTo(scrollView.mas_right);
        make.bottom.equalTo(scrollView.mas_bottom);
        make.width.mas_equalTo(self.view.mas_width);
//        make.height.mas_offset(1000);
    }];
    _viewMainBottom = bottomView;
    
    //最上方的篮框
    UIView *viewForTop = [[UIView alloc]init];
    viewForTop.backgroundColor = RGBA(0, 108, 175, 1.0);
    [bottomView addSubview:viewForTop];
    [viewForTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.left.equalTo(bottomView.mas_left);
        make.right.equalTo(bottomView.mas_right);
        make.height.mas_equalTo(RESIZE_UI(180));
    }];
    
//    _imageViewForTitle = [[UIImageView alloc]init];
//    _imageViewForTitle.image = [UIImage imageNamed:@"icon_touzi"];
//    [viewForTop addSubview:_imageViewForTitle];
//    [_imageViewForTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(viewForTop.mas_top).with.offset(RESIZE_UI(12));
//        make.left.equalTo(viewForTop.mas_left).with.offset(RESIZE_UI(12));
//        make.height.mas_offset(RESIZE_UI(27));
//        make.width.mas_offset(RESIZE_UI(23));
//    }];
//    
//    /* 票据 */
//    _billLable = [[UILabel alloc] init];
//    _billLable.textAlignment = NSTextAlignmentLeft;
//    _billLable.textColor = VIEWBACKCOLOR;
//    _billLable.font = [UIFont systemFontOfSize:17];
//    _billLable.text = _productModel.name;
//    [viewForTop addSubview:_billLable];
//    [_billLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(_imageViewForTitle.mas_centerY);
//        make.left.equalTo(viewForTop.mas_left).with.offset(RESIZE_UI(45));
//    }];
    
    LongProductSegment *segment = _productModel.segment[0];
    
    /* 收益  */
    _earnOfPercent = [[UILabel alloc] init];
    _earnOfPercent.textAlignment = NSTextAlignmentCenter;
    _earnOfPercent.textColor = VIEWBACKCOLOR;
    _earnOfPercent.text = [NSString stringWithFormat:@"%.2f", [segment.returnrate doubleValue] * 100];
    _earnOfPercent.font = [UIFont systemFontOfSize:RESIZE_UI(64)];
    [viewForTop addSubview:_earnOfPercent];
    [_earnOfPercent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(RESIZE_UI(35+30));
        make.left.equalTo(viewForTop.mas_left);
        make.right.equalTo(viewForTop.mas_right);
        make.height.mas_offset(RESIZE_UI(64));
    }];
    
    _earnOfYearLable = [[UILabel alloc] init];
    _earnOfYearLable.text = @"预期年化收益(%)";
    _earnOfYearLable.textAlignment = NSTextAlignmentCenter;
    _earnOfYearLable.textColor = VIEWBACKCOLOR;
    _earnOfYearLable.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    [viewForTop addSubview:_earnOfYearLable];
    [_earnOfYearLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_earnOfPercent.mas_centerX);
        make.top.equalTo(_earnOfPercent.mas_bottom).with.offset(RESIZE_UI(12));
        make.height.mas_offset(RESIZE_UI(15));
    }];
    
    //三个平分的框
    //融资总额
    UIView *viewForSum = [[UIView alloc]init];
    viewForSum.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:viewForSum];
    [viewForSum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewForTop.mas_bottom);
        make.left.equalTo(bottomView.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH/3-0.5);
        make.height.mas_equalTo(RESIZE_UI(74));
    }];
    
    _financingLable = [[UILabel alloc] init];
    _financingLable.text = @"融资余额";
    _financingLable.textAlignment = NSTextAlignmentCenter;
    _financingLable.textColor = AUXILY_COLOR;
    _financingLable.font = [UIFont boldSystemFontOfSize:RESIZE_UI(14)];
    [viewForSum addSubview:_financingLable];
    [_financingLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewForSum.mas_top).with.offset(RESIZE_UI(17));
        make.centerX.equalTo(viewForSum.mas_centerX);
        make.height.mas_offset(RESIZE_UI(15));
    }];
    
    /* 融资余额数 */
    _financingNum = [[UILabel alloc] init];
    _financingNum.textAlignment = NSTextAlignmentCenter;
    _financingNum.textColor = TITLE_COLOR;
    _financingNum.text = [NSString stringWithFormat:@"%.2f万", [_productModel.purchasable floatValue] / 10000];;
    _financingNum.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [viewForSum addSubview:_financingNum];
    [_financingNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewForSum.mas_top).with.offset(RESIZE_UI(40));
        make.centerX.equalTo(_financingLable.mas_centerX);
    }];
    
    //融资期限
    UIView *viewForLimit = [[UIView alloc]init];
    viewForLimit.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:viewForLimit];
    [viewForLimit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewForSum.mas_top);
        make.left.equalTo(viewForSum.mas_right).with.offset(1);
        make.height.mas_equalTo(viewForSum.mas_height);
        make.width.mas_equalTo(SCREEN_WIDTH/3-1);
    }];
    
    _financingTermLable = [[UILabel alloc] init];
    _financingTermLable.text = @"融资期限";
    _financingTermLable.textAlignment = NSTextAlignmentCenter;
    _financingTermLable.textColor = AUXILY_COLOR;
    _financingTermLable.font = [UIFont boldSystemFontOfSize:RESIZE_UI(14)];
    [viewForLimit addSubview:_financingTermLable];
    [_financingTermLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewForLimit.mas_top).with.offset(RESIZE_UI(17));
        make.centerX.equalTo(viewForLimit.mas_centerX);
        make.height.mas_offset(RESIZE_UI(15));
    }];
    
    /* 融资期限天数 */
    _financingOfdays = [[UILabel alloc] init];
    _financingOfdays.textAlignment = NSTextAlignmentCenter;
    _financingOfdays.textColor = TITLE_COLOR;
    _financingOfdays.text = [NSString stringWithFormat:@"%@天", segment.duration];
    _financingOfdays.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [viewForLimit addSubview:_financingOfdays];
    [_financingOfdays mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewForLimit.mas_top).with.offset(RESIZE_UI(40));
        make.centerX.equalTo(_financingTermLable.mas_centerX);
        make.height.mas_offset(RESIZE_UI(20));
    }];
    
    //融资风险
    UIView *viewForRisk = [[UIView alloc]init];
    viewForRisk.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:viewForRisk];
    [viewForRisk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewForSum.mas_top);
        make.right.equalTo(bottomView.mas_right);
        make.height.mas_equalTo(viewForSum.mas_height);
        make.width.mas_offset(SCREEN_WIDTH/3-0.5);
    }];
    
    _riskLable = [[UILabel alloc] init];
    _riskLable.text = @"融资风险";
    _riskLable.textAlignment = NSTextAlignmentCenter;
    _riskLable.textColor = AUXILY_COLOR;
    _riskLable.font = [UIFont boldSystemFontOfSize:RESIZE_UI(14)];
    [viewForRisk addSubview:_riskLable];
    [_riskLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewForRisk.mas_top).with.offset(RESIZE_UI(17));
        make.centerX.equalTo(viewForRisk.mas_centerX);
        make.height.mas_offset(RESIZE_UI(15));
    }];
    
    /* 风险程度 */
    _financingRisk = [[UILabel alloc] init];
    _financingRisk.textAlignment = NSTextAlignmentCenter;
    _financingRisk.textColor = TITLE_COLOR;
    _financingRisk.text = _productModel.risk;
    _financingRisk.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [viewForRisk addSubview:_financingRisk];
    [_financingRisk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewForRisk.mas_top).with.offset(RESIZE_UI(40));
        make.centerX.equalTo(_riskLable.mas_centerX);
        make.height.mas_offset(RESIZE_UI(20));
    }];
    
    //产品信息按钮
    _buttonForShuoMing = [[UIButton alloc]init];
    [_buttonForShuoMing setBackgroundColor:[UIColor whiteColor]];
    [_buttonForShuoMing setTitle:@"产品信息" forState:UIControlStateNormal];
    [_buttonForShuoMing addTarget:self action:@selector(buttonShuoMingMethod) forControlEvents:UIControlEventTouchUpInside];
    [_buttonForShuoMing setTitleColor:RGBA(0, 102, 177, 1.0) forState:UIControlStateNormal];
    _buttonForShuoMing.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(18)];
    [bottomView addSubview:_buttonForShuoMing];
    [_buttonForShuoMing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewForSum.mas_bottom).with.offset(RESIZE_UI(16));
        make.left.equalTo(bottomView.mas_left);
        make.width.mas_offset(SCREEN_WIDTH/2-0.5);
        make.height.mas_offset(RESIZE_UI(40));
    }];
    
    _labelForShuoMing = [[UILabel alloc]init];
    _labelForShuoMing.backgroundColor = RGBA(0, 102, 177, 1.0);
    [bottomView addSubview:_labelForShuoMing];
    [_labelForShuoMing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buttonForShuoMing.mas_bottom);
        make.left.equalTo(_buttonForShuoMing.mas_left);
        make.right.equalTo(_buttonForShuoMing.mas_right);
        make.height.mas_offset(RESIZE_UI(3));
    }];
    
    //产品说明按钮
    _buttonForJianJie = [[UIButton alloc]init];
    [_buttonForJianJie setBackgroundColor:[UIColor whiteColor]];
    [_buttonForJianJie setTitle:@"产品说明" forState:UIControlStateNormal];
    [_buttonForJianJie setTitleColor:RGBA(102, 102, 102, 1.0) forState:UIControlStateNormal];
    [_buttonForJianJie addTarget:self action:@selector(buttonForJianJieMethod) forControlEvents:UIControlEventTouchUpInside];
    _buttonForJianJie.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(18)];
    [bottomView addSubview:_buttonForJianJie];
    [_buttonForJianJie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buttonForShuoMing.mas_top);
        make.right.equalTo(bottomView.mas_right);
        make.width.mas_offset(SCREEN_WIDTH/2-0.5);
        make.height.mas_offset(RESIZE_UI(40));
    }];
    
    _labelForJianJie = [[UILabel alloc]init];
    _labelForJianJie.backgroundColor = RGBA(0, 102, 177, 1.0);
    _labelForJianJie.hidden = YES;
    [bottomView addSubview:_labelForJianJie];
    [_labelForJianJie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buttonForJianJie.mas_bottom);
        make.left.equalTo(_buttonForJianJie.mas_left);
        make.right.equalTo(_buttonForJianJie.mas_right);
        make.height.mas_offset(RESIZE_UI(3));
    }];
    
//    _viewForBottomIntroduce = [[UIView alloc]init];
//    [bottomView addSubview:_viewForBottomIntroduce];
//    [_viewForBottomIntroduce mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_labelForShuoMing.mas_bottom);
//        make.left.equalTo(bottomView.mas_left);
//        make.right.equalTo(bottomView.mas_right);
//        make.bottom.equalTo(bottomView.mas_bottom);
//        make.height.mas_offset(1000);
//    }];
    
    //创建产品说明
    [self creatShuoMingView];
    
    
}

#pragma mark - 创建产品说明
- (void)creatShuoMingView {
    
    _viewForShuoMing = [[ViewForShuoMing alloc]initWithProductModel:_productModel];
    _viewForShuoMing.watchPic = ^(NSString *picStr){
        
        ShowBigImageView *showImgView = [[ShowBigImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [showImgView show];
        showImgView.imageArray = @[picStr];
        showImgView.titleNumberLabel.hidden = YES;
        
    };
    @weakify(self)
    _viewForShuoMing.watchContract = ^(){
        @strongify(self)
        AgViewController *agVC =[[AgViewController alloc] init];
        agVC.title = @"购买合同";
        agVC.webUrl = @"http://api.wmjr888.com/home/page/app/id/9";
        BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
        [self presentViewController:baseNa animated:YES completion:^{
        }];
        
    };
    [_viewMainBottom addSubview:_viewForShuoMing];
    [_viewForShuoMing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labelForShuoMing.mas_bottom);
        make.left.equalTo(_viewMainBottom.mas_left);
        make.right.equalTo(_viewMainBottom.mas_right);
        make.bottom.equalTo(_viewMainBottom.mas_bottom);
        make.height.mas_offset(44*6+230+10);
    }];
    
}

#pragma mark - 创建产品简介
- (void)creatJianJieView {
    
    _viewForJianJie = [[ViewForJianJie alloc]initWithProductModel:_productModel];
//    @weakify(self)
//    _viewForJianJie.transHight = ^(CGFloat height) {
//        @strongify(self)
//        [self.viewForJianJie mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_offset(height);
//        }];
//        
//    };
    [_viewMainBottom addSubview:_viewForJianJie];
    [_viewForJianJie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labelForShuoMing.mas_bottom);
        make.left.equalTo(_viewMainBottom.mas_left);
        make.right.equalTo(_viewMainBottom.mas_right);
        make.bottom.equalTo(_viewMainBottom.mas_bottom);
//        make.height.mas_offset(1000);
    }];
    
}

#pragma mark - 说明按钮
- (void)buttonShuoMingMethod {
    
    _labelForJianJie.hidden = YES;
    _labelForShuoMing.hidden = NO;
    [_buttonForShuoMing setTitleColor:RGBA(0, 102, 177, 1.0) forState:UIControlStateNormal];
    [_buttonForJianJie setTitleColor:RGBA(102, 102, 102, 1.0) forState:UIControlStateNormal];
    if (_viewForJianJie) {
        [_viewForJianJie removeFromSuperview];
        _viewForJianJie = nil;
        [self creatShuoMingView];
    }
    
}

#pragma mark - 简介按钮
- (void)buttonForJianJieMethod {
    
    _labelForShuoMing.hidden = YES;
    _labelForJianJie.hidden = NO;
    [_buttonForJianJie setTitleColor:RGBA(0, 102, 177, 1.0) forState:UIControlStateNormal];
    [_buttonForShuoMing setTitleColor:RGBA(102, 102, 102, 1.0) forState:UIControlStateNormal];
    if (_viewForShuoMing) {
        [_viewForShuoMing removeFromSuperview];
        _viewForShuoMing = nil;
        [self creatJianJieView];
    }
    
}

/* 立即购买 */
- (void)configViewWithBuy {
    
    _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_buyBtn addTarget:self action:@selector(buyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _buyBtn.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    [self.view addSubview:_buyBtn];
    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(40));
    }];
}

//分享
- (void)sharedBtnAction {
    
    if ([[SingletonManager sharedManager].uid isEqualToString:@""]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNa = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNa animated:YES completion:nil];
        return;
    }
    _popMenu = [[PopMenu alloc] init];
    _popMenu.dimBackground = YES;
    _popMenu.coverNavigationBar = YES;
    _sharedView = [[SharedView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - RESIZE_UI(168), SCREEN_WIDTH, RESIZE_UI(168))];
    [_popMenu addSubview:_sharedView];
    [_popMenu showInRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPopViewAction)];
    [_popMenu addGestureRecognizer:tap];
    
    [_sharedView callSharedBtnEventBlock:^(UIButton *sender) {
        [_popMenu dismissMenu];
        NSString *urlStr = [NSString stringWithFormat:@"http://wmjr888.com/home/download/product/id/%@", self.getPro_id];
        SharedManager *sharedManager = [[SharedManager alloc] init];
        [sharedManager shareContent:sender withTitle:@"旺马财富" andContent:@"这是一个值得信赖的的投资理财平台" andUrl:urlStr];
    }];

}

/* 取消覆盖 */
- (void)tapPopViewAction {
    [_popMenu dismissMenu];
}

/* 立即购买 */
- (void)buyBtnAction {
    if ([[SingletonManager sharedManager].uid isEqualToString:@""]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNa = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNa animated:YES completion:nil];
    } else {
        /* 是否实名认证 */
        if ([[SingletonManager sharedManager].userModel.is_real_name isEqualToString:@"1"]) {
            if (!_isCheck) {
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确认";
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"你还未同意购买合同" detail:nil];
                [alertView show];
                return;
            }
            //是否绑定银行卡
            if ([[SingletonManager sharedManager].userModel.card_id isEqualToString:@"0"]) {
                MMPopupItemHandler block = ^(NSInteger index){
                    if (index == 0) {
                        return ;
                    }
                    if (index == 1) {
                        /*  绑定银行卡 */
                        UIStoryboard *addbank = [UIStoryboard storyboardWithName:@"AddBankViewController" bundle:[NSBundle mainBundle]];
                        AddBankViewController *addBankVC = [addbank instantiateViewControllerWithIdentifier:@"AddBank"];
                        addBankVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:addBankVC animated:YES];
                        return;
                    }
                };
                NSArray *items =
                @[MMItemMake(@"取消", MMItemTypeNormal, block),
                  MMItemMake(@"好的", MMItemTypeNormal, block)];
                MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                                     detail:@"您还没有绑定银行卡，请去绑定银行卡"
                                                                      items:items];
                [alertView show];
                return;
            }
            /* 购买 */
//            FundBuyViewController *fundBuyVC = [[FundBuyViewController alloc] init];
            HRBuyViewController *fundBuyVC = [[HRBuyViewController alloc]initWithNibName:@"HRBuyViewController" bundle:nil];
            fundBuyVC.productModel = _productModel;
            [self.navigationController pushViewController:fundBuyVC animated:YES];
        } else {
            [[MMPopupWindow sharedWindow] cacheWindow];
            MMPopupItemHandler block = ^(NSInteger index){
                if (index == 0) {
                    return ;
                }
                if (index == 1) {
                    /*  实名认证 */
                    RealNameCertificationViewController *realNameAuth = [[RealNameCertificationViewController alloc] init];
                    [self.navigationController pushViewController:realNameAuth animated:YES];
                }
            };
            NSArray *items =
            @[MMItemMake(@"取消", MMItemTypeNormal, block),
              MMItemMake(@"确定", MMItemTypeNormal, block)];
            MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                                 detail:@"你还未认证,请实名认证"
                                                                  items:items];
            [alertView show];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*判断字符串是否为空*/
- (NSString*)convertNullString:(NSString*)oldString{
    if (oldString!=nil && (NSNull *)oldString != [NSNull null]) {
        if ([oldString length]!=0) {
            if ([oldString isEqualToString:@"(null)"]) {
                return @"";
            }
            return  oldString;
        }else{
            return @"";
        }
    }
    else{
        return @"";
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
