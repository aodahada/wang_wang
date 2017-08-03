//
//  LongProductDetailViewController.m
//  WmjrApp
//
//  Created by horry on 2017/2/15.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "LongProductDetailViewController.h"
#import "RateTypeButton.h"
#import "ProductModel.h"
#import "LongProductSegment.h"
#import "AgViewController.h"
#import "ShowBigImageView.h"
#import "ViewForShuoMing.h"
#import "BaseNavigationController.h"
#import "LoginViewController.h"
#import "PopMenu.h"
#import "SharedView.h"
#import "WebViewForPayViewController.h"
#import "InvestConfirmView.h"
#import "MMPopupItem.h"
#import "RechargeViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface LongProductDetailViewController (){
    PopMenu *_popMenu;
    SharedView *_sharedView;
}

@property (nonatomic, strong)UITextField *restBuyMoneyText;
@property (nonatomic, strong)NSArray *segmentArray;
@property (nonatomic, strong)NSMutableArray *buttonArray;
@property (nonatomic, strong)LongProductSegment *currentProductSegment;
@property (nonatomic, strong)ViewForShuoMing *viewForShuoMing;
@property (nonatomic, strong)UILabel *labelForEarnValue;
@property (nonatomic, strong)UILabel *labelForEndDay;
@property (nonatomic, strong)InvestConfirmView *investConfirmView;
@property (nonatomic, copy) NSString *personalYuEStr;//个人余额
@property (nonatomic, strong) UIView *viewForBack;//背景View;
@property (nonatomic, strong) UITapGestureRecognizer *tapGes;
@property (nonatomic, strong) UIView *bottomview;
@property (nonatomic, assign) BOOL isCheck;//是否同意协议

@end

@implementation LongProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _productModel.name;
    self.view.backgroundColor = RGBA(239, 239, 239, 1.0);
    
    //监听键盘弹出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    _isCheck = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noSelectContract) name:@"noselectContract" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectContract) name:@"selectContract" object:nil];
    
    self.segmentArray = _productModel.segment;
    for (int i=0; i<self.segmentArray.count; i++) {
        LongProductSegment *longProductSeg = self.segmentArray[i];
        longProductSeg.isSelect = NO;
    }
    for (int i=0; i<self.segmentArray.count; i++) {
        LongProductSegment *longProductSeg = self.segmentArray[i];
        if (![longProductSeg.returnrate isEqualToString:@"0"]) {
            longProductSeg.isSelect = YES;
            _currentProductSegment = longProductSeg;
            break;
        }
    }
    [self setUpLayout];
}


- (void)noSelectContract {
    
    _isCheck = NO;
    
}

- (void)selectContract {
    
    _isCheck = YES;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LongProductDetailViewController"];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [self setUpNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LongProductDetailViewController"];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
}

- (void)keyboardFrameChange:(NSNotification *)noti {
    
//    NSLog(@"键盘信息:%@",noti.userInfo);
    //获取键盘结束时frame
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    //获取键盘结束时的y值
    CGFloat keyboardEndY = keyboardFrame.origin.y;
//    NSLog(@"我的键盘高度:%.f",keyboardEndY);
    
    [UIView animateWithDuration:1.0 animations:^{
        _bottomview.frame = CGRectMake(0, keyboardEndY-RESIZE_UI(57)-64, SCREEN_WIDTH, RESIZE_UI(57));
    }];
//    [_bottomview mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_bottom).with.offset(-(SCREEN_HEIGHT-keyboardEndY));
//    }];
    
}

/* 设置导航条 */
- (void)setUpNavigationBar {
    
    /* 分享 */
    UIImage *imageHelp = [[UIImage imageNamed:@"icon_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *sharedBtn = [[UIBarButtonItem alloc] initWithImage:imageHelp style:UIBarButtonItemStylePlain target:self action:@selector(sharedBtnAction)];
    self.navigationItem.rightBarButtonItem = sharedBtn;
    
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
//        NSString *urlStr = [NSString stringWithFormat:@"http://wmjr888.com/home/download/product/id/%@", _productModel.proIntro_id];
        NSString *urlStr = [NSString stringWithFormat:@"http://m.wangmacaifu.com/#/long-detail/%@", _productModel.proIntro_id];
        SharedManager *sharedManager = [[SharedManager alloc] init];
        [sharedManager shareContent:sender withTitle:@"旺马财富" andContent:@"这是一个值得信赖的的投资理财平台" andUrl:urlStr];
    }];
    
}

/* 取消覆盖 */
- (void)tapPopViewAction {
    [_popMenu dismissMenu];
}

- (void)setUpLayout{
    
    UIScrollView *mainScrollview = [[UIScrollView alloc]init];
    mainScrollview.bounces = NO;
    [self.view addSubview:mainScrollview];
    [mainScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(RESIZE_UI(-59));
    }];
    
    UIView *mainView = [[UIView alloc]init];
    mainView.backgroundColor = RGBA(239, 239, 239, 1.0);
    [mainScrollview addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollview);
        make.width.mas_equalTo(self.view.mas_width);
//        make.height.mas_equalTo(1000);
    }];
    
    //顶部部分
    UIView *topview = [[UIView alloc]init];
    topview.backgroundColor = RGBA(0, 109, 175, 1.0);
    [mainView addSubview:topview];
    [topview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView.mas_top);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_equalTo(RESIZE_UI(151));
    }];
    
    UILabel *labelForEarnTitle = [[UILabel alloc]init];
    labelForEarnTitle.text = @"预计收益";
    labelForEarnTitle.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    labelForEarnTitle.textAlignment = NSTextAlignmentCenter;
    labelForEarnTitle.textColor = [UIColor whiteColor];
    [topview addSubview:labelForEarnTitle];
    [labelForEarnTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topview.mas_top).with.offset(RESIZE_UI(12));
        make.centerX.equalTo(topview.mas_centerX);
    }];
    
    _labelForEarnValue = [[UILabel alloc]init];
    _labelForEarnValue.text = @"0";
    _labelForEarnValue.textColor = [UIColor whiteColor];
    _labelForEarnValue.font = [UIFont systemFontOfSize:RESIZE_UI(48)];
    _labelForEarnValue.textAlignment = NSTextAlignmentCenter;
    [topview addSubview:_labelForEarnValue];
    [_labelForEarnValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelForEarnTitle.mas_bottom).with.offset(RESIZE_UI(12));
        make.centerX.equalTo(labelForEarnTitle.mas_centerX);
    }];
    
    UIImageView *imageView1 = [[UIImageView alloc]init];
    imageView1.image = [UIImage imageNamed:@"icon_round"];
    [topview addSubview:imageView1];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topview.mas_bottom).with.offset(RESIZE_UI(-22));
        make.left.mas_offset(RESIZE_UI(37));
        make.width.height.mas_offset(RESIZE_UI(6));
    }];
    
    UILabel *labelForSumMoney = [[UILabel alloc]init];
    labelForSumMoney.text = [NSString stringWithFormat:@"总金额:%@万",_productModel.purchasable];
    labelForSumMoney.textColor = [UIColor whiteColor];
    labelForSumMoney.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    [topview addSubview:labelForSumMoney];
    [labelForSumMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView1.mas_centerY);
        make.left.equalTo(imageView1.mas_right).with.offset(RESIZE_UI(9));
    }];
    
    _labelForEndDay = [[UILabel alloc]init];
    _labelForEndDay.text = [NSString stringWithFormat:@"到期天数:%@",_currentProductSegment.duration];
    _labelForEndDay.textColor = [UIColor whiteColor];
    _labelForEndDay.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    [topview addSubview:_labelForEndDay];
    [_labelForEndDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelForSumMoney.mas_centerY);
        make.right.equalTo(topview.mas_right).with.offset(RESIZE_UI(-37));
    }];
    
    UIImageView *imageView2 = [[UIImageView alloc]init];
    imageView2.image = [UIImage imageNamed:@"icon_round"];
    [topview addSubview:imageView2];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labelForSumMoney.mas_centerY);
        make.right.equalTo(_labelForEndDay.mas_left).with.offset(RESIZE_UI(-12));
        make.width.height.mas_offset(RESIZE_UI(6));
    }];
    
    //横滑部分
    UIView *crossbottomview = [[UIView alloc]init];
    crossbottomview.backgroundColor = RGBA(239, 239, 239, 1.0);
    [mainView addSubview:crossbottomview];
    [crossbottomview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(RESIZE_UI(174));
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.top.equalTo(topview.mas_bottom);
    }];
    
    UIScrollView *crossScrollview = [[UIScrollView alloc]init];
    [crossbottomview addSubview:crossScrollview];
    [crossScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(crossbottomview);
    }];
    
    UIView *crossview = [[UIView alloc]init];
    crossview.backgroundColor = RGBA(239, 239, 239, 1.0);
    [crossScrollview addSubview:crossview];
    [crossview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(crossScrollview);
        make.height.mas_equalTo(crossbottomview.mas_height);
        make.width.mas_offset(RESIZE_UI(128+3)*self.segmentArray.count);
    }];
    
    _buttonArray = [[NSMutableArray alloc]init];
    for (int i=0; i<self.segmentArray.count; i++) {
        RateTypeButton *ratetypeBtn = [[RateTypeButton alloc]initWithSementProduct:self.segmentArray[i]];
        ratetypeBtn.tag = i;
//        ratetypeBtn.segmentProduct = self.segmentArray[i];
        [ratetypeBtn addTarget:self action:@selector(selectRateMethod:) forControlEvents:UIControlEventTouchUpInside];
        [crossview addSubview:ratetypeBtn];
        [ratetypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(RESIZE_UI(165));
            make.width.mas_offset(RESIZE_UI(128));
            make.left.equalTo(crossview.mas_left).with.offset(RESIZE_UI(6)+(RESIZE_UI(128+3))*i);
            make.centerY.equalTo(crossview.mas_centerY);
        }];
        [_buttonArray addObject:ratetypeBtn];
    }
    
    //产品信息
    UIView *productMessTitleView = [[UIView alloc]init];
    [mainView addSubview:productMessTitleView];
    productMessTitleView.backgroundColor = [UIColor whiteColor];
    [productMessTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(crossbottomview.mas_bottom);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(30));
    }];
    
    //红色条
    UIView *redLineView = [[UIView alloc]init];
    redLineView.backgroundColor = RGBA(255, 86, 57, 1.0);
    [productMessTitleView addSubview:redLineView];
    [redLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(productMessTitleView.mas_centerY);
        make.left.equalTo(productMessTitleView.mas_left);
        make.height.mas_offset(RESIZE_UI(20));
        make.width.mas_offset(RESIZE_UI(6));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"产品信息";
    titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    titleLabel.textColor = RGBA(153, 153, 153, 1.0);
    [productMessTitleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(productMessTitleView.mas_centerY);
        make.left.equalTo(redLineView.mas_right).with.offset(RESIZE_UI(6));
    }];
    
    //产品信息tableview
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
        [self.navigationController pushViewController:agVC animated:YES];
//        BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
//        [self presentViewController:baseNa animated:YES completion:^{
//        }];
        
    };
    [mainView addSubview:_viewForShuoMing];
    [_viewForShuoMing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productMessTitleView.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.bottom.equalTo(mainView.mas_bottom);
        make.height.mas_offset(44*6+230+10);
    }];
    
    //底部结算付款部分
    _bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-RESIZE_UI(57), SCREEN_WIDTH, RESIZE_UI(57))];
    _bottomview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomview];
//    [_bottomview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_offset(RESIZE_UI(57));
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.bottom.equalTo(self.view.mas_bottom);
//    }];
    
    UILabel *buyTitleLabel = [[UILabel alloc]init];
    buyTitleLabel.text = @"购买金额";
    buyTitleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    [_bottomview addSubview:buyTitleLabel];
    [buyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomview.mas_left).with.offset(RESIZE_UI(12));
        make.centerY.equalTo(_bottomview.mas_centerY);
    }];
    
    _restBuyMoneyText = [[UITextField alloc]init];
    _restBuyMoneyText.placeholder = [NSString stringWithFormat:@"可购买剩余金额:%@",_currentProductSegment.can_buy];
    [_restBuyMoneyText addTarget:self action:@selector(configYearRateMethod) forControlEvents:UIControlEventEditingChanged];
    _restBuyMoneyText.keyboardType = UIKeyboardTypeDecimalPad;
    _restBuyMoneyText.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    [_bottomview addSubview:_restBuyMoneyText];
    [_restBuyMoneyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buyTitleLabel.mas_right).with.offset(RESIZE_UI(13));
        make.centerY.equalTo(buyTitleLabel.mas_centerY);
    }];
    
    UIButton *buyButton = [[UIButton alloc]init];
    [buyButton addTarget:self action:@selector(payButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    if ([_productModel.isdown isEqualToString:@"0"]) {
        [buyButton setBackgroundColor:RGBA(255, 86, 45, 1.0)];
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buyButton setUserInteractionEnabled:YES];
    } else {
        [buyButton setBackgroundColor:RGBA(234, 234, 234, 1.0)];
        [buyButton setTitle:@"已售罄" forState:UIControlStateNormal];
        [buyButton setTitleColor:RGBA(164, 164, 164, 1.0) forState:UIControlStateNormal];
        [buyButton setUserInteractionEnabled:NO];
    }
    buyButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    [_bottomview addSubview:buyButton];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomview.mas_top);
        make.width.mas_offset(RESIZE_UI(115));
        make.right.equalTo(_bottomview.mas_right);
        make.bottom.equalTo(_bottomview.mas_bottom);
    }];
    
}

- (void)selectRateMethod:(UIButton *)sender {
    LongProductSegment *segmentPro = self.segmentArray[sender.tag];
    if ([segmentPro.returnrate isEqualToString:@"0"]) {
        return;
    } else {
        for (int i=0; i<self.segmentArray.count; i++) {
            LongProductSegment *segmentProduct = self.segmentArray[i];
            if (i == sender.tag) {
                segmentProduct.isSelect = YES;
                _currentProductSegment = segmentProduct;
            } else {
                segmentProduct.isSelect = NO;
            }
        }
        for (int i=0; i<_buttonArray.count; i++) {
            RateTypeButton *rateButton = _buttonArray[i];
            rateButton.segmentProduct = self.segmentArray[i];
        }
        _labelForEndDay.text = [NSString stringWithFormat:@"到期天数:%@",_currentProductSegment.duration];
        _restBuyMoneyText.placeholder = [NSString stringWithFormat:@"可购买剩余金额:%@",_currentProductSegment.can_buy];
        //重新计算年化收益
        [self configYearRateMethod];
    }
}

#pragma mark - 计算年化收益
- (void)configYearRateMethod {
    
    float yearRate = _currentProductSegment.returnrate.floatValue;
    float date = _currentProductSegment.duration.floatValue;
    float inputMoney = [_restBuyMoneyText.text floatValue];
    float estimateYearEarnFloat = inputMoney*yearRate/365*date;
    NSString *estimateString = [NSString stringWithFormat:@"%.2f",estimateYearEarnFloat];
    _labelForEarnValue.text = estimateString;

}

#pragma mark - 支付按钮
- (void)payButtonMethod {
    [_restBuyMoneyText resignFirstResponder];
    LongProductSegment *model;
    if (!_isCheck) {
        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
        alertConfig.defaultTextOK = @"确认";
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"你还未同意购买合同" detail:nil];
        [alertView show];
        return;
    }
    for (int i=0; i<self.segmentArray.count; i++) {
        
        LongProductSegment *haha = self.segmentArray[i];
        if (haha.isSelect) {
            model = haha;
        }
    }
    float restInvest = model.can_buy.floatValue;
    float lowInvest = _productModel.lowpurchase.floatValue;
    float investmoney = _restBuyMoneyText.text.floatValue;
    if([_restBuyMoneyText.text isEqualToString:@""]){
        [SVProgressHUD showInfoWithStatus:@"请输入购买金额"];
    } else if ([[self convertNullString:[SingletonManager sharedManager].uid] isEqualToString:@""]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.loginIden = @"login";
        loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController *loginNa = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNa animated:YES completion:nil];
    } else if(investmoney>restInvest) {
        NSString *tip = [NSString stringWithFormat:@"投资金额不能超过%.2f元",restInvest];
        [[[UIAlertView alloc]initWithTitle:tip message:@"" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil]show];
    } else if (investmoney<lowInvest){
        NSString *tip = [NSString stringWithFormat:@"产品起购金额为%.2f元",lowInvest];
        [[[UIAlertView alloc]initWithTitle:tip message:@"" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil]show];
    } else {
        
        //获取余额
        [self getCurrentRest];
        
    }
}

#pragma mark - 支付接口
- (void)useInterfaceForPay {
    
    LongProductSegment *model;
    for (int i=0; i<self.segmentArray.count; i++) {
        
        LongProductSegment *haha = self.segmentArray[i];
        if (haha.isSelect) {
            model = haha;
        }
    }
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Finance/order" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"product_id":_productModel.proIntro_id,@"segment_id":model.segment_id,@"money":_restBuyMoneyText.text,@"returnrate":model.returnrate} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSDictionary *dataDic = obj[@"data"];
                WebViewForPayViewController *webViewForPayVC = [[WebViewForPayViewController alloc]initWithNibName:@"WebViewForPayViewController" bundle:nil];
                webViewForPayVC.htmlString = dataDic[@"html"];
                webViewForPayVC.title = @"支付界面";
                [self.navigationController pushViewController:webViewForPayVC animated:YES];
                [SVProgressHUD dismiss];
                return ;
            } else {
                NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确定";
                [SVProgressHUD dismiss];
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
                [alertView show];
            }
        }
    }];
    
}

#pragma mark - 获取当前余额
- (void)getCurrentRest {
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"User/queryBalance" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"account_type":@"SAVING_POT"} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                
                NSDictionary *dataDic = obj[@"data"];
                self.personalYuEStr = dataDic[@"balance"];
                
                _investConfirmView = [[InvestConfirmView alloc]initWithInvestMoney:_restBuyMoneyText.text restMoney:_personalYuEStr];
                @weakify(self)
                _investConfirmView.closeViewMethod = ^(){
                    @strongify(self)
                    [self tapGesMethod];
                };
                _investConfirmView.jumToReadDelegate = ^(){
                    @strongify(self)
                    [self watchDelegateMethod];
                };
                _investConfirmView.buttonNextMethod = ^(BOOL canPay){
                    @strongify(self)
                    if (canPay) {
                        [self useInterfaceForPay];
                    } else {
                        MMPopupItemHandler block = ^(NSInteger index){
                            if (index == 0) {
                                return ;
                            }
                            if (index == 1) {
                                [self tapGesMethod];
                                /*  充值 */
                                RechargeViewController *rechangeVC = [[RechargeViewController alloc] init];
                                rechangeVC.isPayJump = @"yes";
                                [self.navigationController pushViewController:rechangeVC animated:YES];
                                return;
                            }
                        };
                        NSArray *items =
                        @[MMItemMake(@"取消", MMItemTypeNormal, block),
                          MMItemMake(@"确定", MMItemTypeNormal, block)];
                        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                                             detail:@"您的余额不足，请先去充值"
                                                                              items:items];
                        [alertView show];
                    }
                };
                [self.view addSubview:_investConfirmView];
                [_investConfirmView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view.mas_bottom);
                    make.height.mas_offset(319);
                    make.left.equalTo(self.view.mas_left);
                    make.right.equalTo(self.view.mas_right);
                }];
                
                _viewForBack = [[UIView alloc]init];
                _viewForBack.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.36];
                [self.view addSubview:_viewForBack];
                [_viewForBack mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view.mas_top);
                    make.left.equalTo(self.view.mas_left);
                    make.right.equalTo(self.view.mas_right);
                    make.bottom.equalTo(_investConfirmView.mas_top);
                }];
                
                _tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesMethod)];
                [_viewForBack addGestureRecognizer:_tapGes];
                
                
                [SVProgressHUD dismiss];
                return ;
            } else {
                NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确定";
                [SVProgressHUD dismiss];
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
                [alertView show];
            }
        }
    }];
    
}

- (void)tapGesMethod {
    [_viewForBack removeFromSuperview];
    [_viewForBack removeGestureRecognizer:_tapGes];
    _tapGes = nil;
    _viewForBack = nil;
    [_investConfirmView removeFromSuperview];
    _investConfirmView = nil;
}

#pragma mark - 查看合同
- (void)watchDelegateMethod{
    
    AgViewController *agVC =[[AgViewController alloc] init];
//    BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
    agVC.title = @"交易协议";
    agVC.webUrl = @"http://api.wmjr888.com/home/page/app/id/11";
    [self.navigationController pushViewController:agVC animated:YES];
//    [self presentViewController:baseNa animated:YES completion:^{
//    }];
    
}


#pragma mark - 判断字符串是否为空
- (NSString*)convertNullString:(NSString*)oldString{
    if (oldString!=nil && (NSNull *)oldString != [NSNull null]) {
        if ([oldString length]!=0) {
            if ([oldString isEqualToString:@"(null)"]) {
                return @"";
            }
            return oldString;
        }else{
            return @"";
        }
    }
    else{
        return @"";
    }
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
