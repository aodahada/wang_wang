//
//  LotteryActivityViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/12/11.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "LotteryActivityViewController.h"
#import "LotteryModel.h"
#import "WinPrizeView.h"
#import "PrizeRecordView.h"
#import "PrizeRecordModel.h"
#import "TXScrollLabelView.h"
#import "PaoMaDengModel.h"
#import "WatchActivityRuleViewController.h"
#import "PopMenu.h"
#import "SharedView.h"

#define ActivityButtonWidth 80
#define ActivityButtonHeight 80*213/254
#define ActivityButtonDistance 10

@interface LotteryActivityViewController ()<TXScrollLabelViewDelegate>{
    PopMenu *_popMenu;
    SharedView *_sharedView;
}

@property (nonatomic, strong)UIView *zhuanPanView;//转盘view
@property (nonatomic, strong)UIButton *centerButton;
@property (nonatomic, strong)UIButton *button1;
@property (nonatomic, strong)UIButton *button2;
@property (nonatomic, strong)UIButton *button3;
@property (nonatomic, strong)UIButton *button4;
@property (nonatomic, strong)UIButton *button5;
@property (nonatomic, strong)UIButton *button6;
@property (nonatomic, strong)UIButton *button7;
@property (nonatomic, strong)UIButton *button8;
@property (nonatomic, strong)UIView *fugaiView;//覆盖view
@property (nonatomic, strong)NSArray *buttonArray;
@property (nonatomic, strong)NSMutableArray *fugaiArray;//覆盖array

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger circleTime;//循环次数

@property (nonatomic, assign) NSInteger randomSelectNumber;

@property (nonatomic, strong) UIScrollView *ScrollViewMain;
@property (nonatomic, strong) UIView *viewMain;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong) NSMutableArray *lotteryArray;
@property (nonatomic, strong) LotteryModel *selectLotteryModel;//中奖的model
@property (nonatomic, strong) NSMutableArray *paomadengArray;//跑马灯array;
@property (nonatomic, copy) NSString *exchangeNumber;//可兑奖次数
@property (nonatomic, strong) UILabel *choujiangChanceLabel;//抽奖机会label

@property (nonatomic, copy) NSString *invitationcode;//我的推荐码

@end

@implementation LotteryActivityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LotteryActivityViewController"];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"给我红包壕嘛";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getActivityMessage];
    
//    [self showRegardView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LotteryActivityViewController"];
}

#pragma mark - 获取接口信息
- (void)getActivityMessage {
    NetManager *manager = [[NetManager alloc] init];
    _lotteryArray = [[NSMutableArray alloc]init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Raffle/index" withParamDictionary:@{@"nihoa":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            NSArray *activityArray = obj[@"data"];
            [LotteryModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"lotteryId" : @"id"};
            }];
            for (int i=0; i<activityArray.count; i++) {
                NSDictionary *dic = activityArray[i];
                LotteryModel *lotteryModel = [LotteryModel mj_objectWithKeyValues:dic];
//                NSLog(@"我饿奖品id：%@",lotteryModel.lotteryId);
                [_lotteryArray addObject:lotteryModel];
            }
            
            //获取兑奖次数
            [self getExchangeNumberMethod];
            
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

#pragma mark - 兑奖次数
- (void)getExchangeNumberMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Raffle/canHandle" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            _exchangeNumber = obj[@"data"];
            //获取跑马灯信息
            [self getPaoMaDengMessage];
            
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

#pragma mark - update兑奖次数
- (void)updateExchangeNumberMethod {
    NetManager *manager = [[NetManager alloc] init];
//    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Raffle/canHandle" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            _exchangeNumber = obj[@"data"];
            if (_choujiangChanceLabel) {
                _choujiangChanceLabel.text = [NSString stringWithFormat:@"您还有%@次抽奖机会",_exchangeNumber];
            }
            
            [self canChouJiangMethod];
            
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

#pragma mark - 是否能抽奖
- (void)canChouJiangMethod {
    if ([_exchangeNumber isEqualToString:@"0"]) {
        [_centerButton setBackgroundImage:[UIImage imageNamed:@"btn_kscj_hui"] forState:UIControlStateNormal];
        _centerButton.userInteractionEnabled = NO;
    } else {
        [_centerButton setBackgroundImage:[UIImage imageNamed:@"btn_kscj_hong"] forState:UIControlStateNormal];
        _centerButton.userInteractionEnabled = YES;
    }
}

#pragma mark - 获取跑马灯信息
- (void)getPaoMaDengMessage {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    _paomadengArray = [[NSMutableArray alloc]init];
    [manager postDataWithUrlActionStr:@"Raffle/all" withParamDictionary:@{@"nihoa":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            NSArray *paomadengArray = obj[@"data"];
            for (int i=0; i<paomadengArray.count; i++) {
                NSDictionary *dic = paomadengArray[i];
                PaoMaDengModel *paomadengModel = [PaoMaDengModel mj_objectWithKeyValues:dic];
                [_paomadengArray addObject:paomadengModel];
            }
            //创建界面
            [self InitJieMian];
            
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

#pragma mark - 界面
- (void)InitJieMian {
    _ScrollViewMain = [[UIScrollView alloc]init];
    _ScrollViewMain.backgroundColor = [UIColor whiteColor];
    _ScrollViewMain.bounces = NO;
    [self.view addSubview:_ScrollViewMain];
    [_ScrollViewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _viewMain = [[UIView alloc]init];
    _viewMain.backgroundColor = [UIColor whiteColor];
    [_ScrollViewMain addSubview:_viewMain];
    [_viewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_ScrollViewMain);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    //上
    _topImageView = [[UIImageView alloc]init];
    _topImageView.image = [UIImage imageNamed:@"活动详情-上"];
    _topImageView.userInteractionEnabled = YES;
    [_viewMain addSubview:_topImageView];
    [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewMain.mas_top);
        make.left.equalTo(_viewMain.mas_left);
        make.right.equalTo(_viewMain.mas_right);
        make.height.mas_offset(SCREEN_WIDTH/375*583);
    }];
    
    //中
    _centerImageView = [[UIImageView alloc]init];
    _centerImageView.image = [UIImage imageNamed:@"活动详情-中"];
    _centerImageView.userInteractionEnabled = YES;
    [_viewMain addSubview:_centerImageView];
    [_centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topImageView.mas_bottom);
        make.left.equalTo(_viewMain.mas_left);
        make.right.equalTo(_viewMain.mas_right);
        make.height.mas_offset(SCREEN_WIDTH/375*385);
    }];
    
    //立即邀请
    UIButton *inviteButton = [[UIButton alloc]init];
    [inviteButton setBackgroundImage:[UIImage imageNamed:@"btn_ljyq"] forState:UIControlStateNormal];
    [inviteButton addTarget:self action:@selector(immediatelyInvite) forControlEvents:UIControlEventTouchUpInside];
    [_centerImageView addSubview:inviteButton];
    [inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerImageView.mas_top);
        make.centerX.equalTo(_centerImageView.mas_centerX);
        make.width.mas_offset(RESIZE_UI(105));
        make.height.mas_offset(RESIZE_UI(34));
    }];
    
    //还有几次抽奖机会
    _choujiangChanceLabel = [[UILabel alloc]init];
    _choujiangChanceLabel.textColor = RGBA(232, 84, 101, 1.0);
    _choujiangChanceLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    _choujiangChanceLabel.text = [NSString stringWithFormat:@"您还有%@次抽奖机会",_exchangeNumber];
    [_centerImageView addSubview:_choujiangChanceLabel];
    [_choujiangChanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_centerImageView.mas_centerX);
        make.bottom.equalTo(_centerImageView.mas_bottom).with.offset(-RESIZE_UI(26));
    }];
    
    //跑马灯
    [self setUpPaoMaDeng];
    
    //下
    _bottomImageView = [[UIImageView alloc]init];
    _bottomImageView.image = [UIImage imageNamed:@"活动详情-下"];
    _bottomImageView.userInteractionEnabled = YES;
    [_viewMain addSubview:_bottomImageView];
    [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerImageView.mas_bottom);
        make.left.equalTo(_viewMain.mas_left);
        make.right.equalTo(_viewMain.mas_right);
        make.height.mas_offset(SCREEN_WIDTH/375*469);
    }];
    
    //中奖纪录
    UIButton *prizeRecordButton = [[UIButton alloc]init];
    [prizeRecordButton setBackgroundImage:[UIImage imageNamed:@"btn_zjjl"] forState:UIControlStateNormal];
    [prizeRecordButton addTarget:self action:@selector(watchPrizeRecordMethod) forControlEvents:UIControlEventTouchUpInside];
    [_viewMain addSubview:prizeRecordButton];
    [prizeRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerImageView.mas_bottom);
        make.right.equalTo(_viewMain.mas_right).with.offset(-RESIZE_UI(30));
        make.width.mas_offset(RESIZE_UI(88));
        make.height.mas_offset(RESIZE_UI(27));
    }];
    
    //活动细则按钮
    UIButton *activityRuleButton = [[UIButton alloc]init];
    [activityRuleButton setBackgroundImage:[UIImage imageNamed:@"btn_xqqcj"] forState:UIControlStateNormal];
    [activityRuleButton addTarget:self action:@selector(watchActivityRule) forControlEvents:UIControlEventTouchUpInside];
    [_bottomImageView addSubview:activityRuleButton];
    [activityRuleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(RESIZE_UI(96));
        make.height.mas_offset(RESIZE_UI(13));
        make.bottom.equalTo(_bottomImageView.mas_bottom).with.offset(-RESIZE_UI(85));
        make.right.equalTo(_bottomImageView.mas_right).with.offset(-RESIZE_UI(45));
    }];
    
    //返回顶部按钮
    UIButton *backToTopButton = [[UIButton alloc]init];
    [backToTopButton addTarget:self action:@selector(backToTop) forControlEvents:UIControlEventTouchUpInside];
    [_viewMain addSubview:backToTopButton];
    [backToTopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_viewMain.mas_bottom).with.offset(RESIZE_UI(-20));
        make.width.mas_offset(RESIZE_UI(200));
        make.height.mas_offset(RESIZE_UI(40));
        make.centerX.equalTo(_viewMain.mas_centerX);
    }];
    
    [_viewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomImageView.mas_bottom);
    }];
    
    
    [self setUpLayoutZhuanPan];
    
}

#pragma mark - 立即邀请
//响应点击分享的方法
- (void)immediatelyInvite {
    //    NSLog(@"-------点击分享----");
    _invitationcode = [SingletonManager sharedManager].userModel.invitationcode;
    _popMenu = [[PopMenu alloc] init];
    _popMenu.dimBackground = YES;
    _popMenu.coverNavigationBar = YES;
    _sharedView = [[SharedView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-RESIZE_UI(168), SCREEN_WIDTH, RESIZE_UI(168))];
    [_popMenu addSubview:_sharedView];
    [_popMenu showInRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    _sharedView.center = _popMenu.center;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPopAction)];
    [_popMenu addGestureRecognizer:tap];
    
    [_sharedView callSharedBtnEventBlock:^(UIButton *sender) {
        [_popMenu dismissMenu];
        SharedManager *sharedManager = [[SharedManager alloc] init];
        if (![[SingletonManager convertNullString:_invitationcode] isEqualToString:@""]) {
            NSString *contentStr = [NSString stringWithFormat:@"旺马圣诞红包雨 财友奖励8%%+疯狂加息1%%！立即投资既可获得，快使用我的旺马财富推荐码 %@", _invitationcode];
            NSString *urlStr = [NSString stringWithFormat:@"http://m.wangmacaifu.com/#/register/wmcf-%@",[SingletonManager sharedManager].userModel.invitationcode];
            [sharedManager shareContent:sender withTitle:@"这是一个值得信赖的的投资理财平台" andContent:contentStr andUrl:urlStr];
            
        } else {
            [[SingletonManager sharedManager] alert1PromptInfo:@"推荐码获取失败,请重新分享"];
        }
    }];
}

/*遮盖消失*/
- (void)tapPopAction {
    [_popMenu dismissMenu];
}


#pragma mark - 查看活动细则
- (void)watchActivityRule {
    WatchActivityRuleViewController *watchActivityVC = [[WatchActivityRuleViewController alloc]init];
    [self.navigationController pushViewController:watchActivityVC animated:YES];
}

#pragma mark - 返回顶部
- (void)backToTop {
    [_ScrollViewMain setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - 跑马灯
- (void)setUpPaoMaDeng {
    /** Step1: 滚动文字 */
    NSMutableArray *titeArray = [[NSMutableArray alloc]init];
    for (int i=0; i<_paomadengArray.count; i++) {
        PaoMaDengModel *paomadengModel = _paomadengArray[i];
        NSString *mobileNumber = paomadengModel.mobile;
        mobileNumber = [mobileNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        NSString *type;//1.现金红包 2.全国流量 3.尊享积分
        if ([paomadengModel.type isEqualToString:@"1"]) {
            type = @"现金红包";
        } else if ([paomadengModel.type isEqualToString:@"2"]) {
            type = @"全国流量";
        } else {
            type = @"尊享积分";
        }
        NSString *tipMessage = [NSString stringWithFormat:@"恭喜%@获得%@%@",mobileNumber,paomadengModel.value,type];
//        NSLog(@"我的跑马灯:%@",tipMessage);
        [titeArray addObject:tipMessage];
    }
    NSArray *scrollTexts = [titeArray copy];
    
    /** Step2: 创建 ScrollLabelView */
    TXScrollLabelView *scrollLabelView = [TXScrollLabelView scrollWithTextArray:scrollTexts type:TXScrollLabelViewTypeLeftRight velocity:1 options:UIViewAnimationOptionCurveEaseInOut inset:UIEdgeInsetsZero];
    scrollLabelView.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
    scrollLabelView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    /** Step3: 设置代理进行回调(Optional) */
    scrollLabelView.scrollLabelViewDelegate = self;
    
    /** Step4: 布局(Required) */
    [_centerImageView addSubview:scrollLabelView];
    [scrollLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerImageView.mas_top).with.offset(RESIZE_UI(55));
        make.left.equalTo(_centerImageView.mas_left).with.offset(RESIZE_UI(135));
        make.right.equalTo(_centerImageView.mas_right).with.offset(-RESIZE_UI(70));
        make.height.mas_offset(RESIZE_UI(30));
    }];
    
    /** Step5: 开始滚动(Start scrolling!) */
    [scrollLabelView beginScrolling];
}

#pragma mark - 转盘
- (void)setUpLayoutZhuanPan {
    _zhuanPanView = [[UIView alloc]init];
    _zhuanPanView.backgroundColor = [UIColor whiteColor];
    [_centerImageView addSubview:_zhuanPanView];
    [_zhuanPanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerImageView.mas_top).with.offset(RESIZE_UI(120));
        make.left.equalTo(_centerImageView.mas_left).with.offset(RESIZE_UI(40));
        make.right.equalTo(_centerImageView.mas_right).with.offset(RESIZE_UI(-40));
        make.bottom.equalTo(_centerImageView.mas_bottom).with.offset(-RESIZE_UI(60));
    }];
    
    _centerButton = [[UIButton alloc]init];
    //抽奖按钮样式
    [self canChouJiangMethod];
    [_centerButton addTarget:self action:@selector(chouJiangInterfaceMethod) forControlEvents:UIControlEventTouchUpInside];
    [_zhuanPanView addSubview:_centerButton];
    [_centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_zhuanPanView.mas_centerY);
        make.centerX.equalTo(_zhuanPanView.mas_centerX);
        make.height.mas_offset(RESIZE_UI(ActivityButtonHeight));
        make.width.mas_offset(RESIZE_UI(ActivityButtonWidth));
    }];
    
    _button1 = [[UIButton alloc]init];
//    [_button1 setBackgroundImage:[UIImage imageNamed:@"btn_kscj"] forState:UIControlStateNormal];
    [_zhuanPanView addSubview:_button1];
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_centerButton.mas_left).with.offset(-RESIZE_UI(ActivityButtonDistance));
        make.top.equalTo(_centerButton.mas_bottom).with.offset(RESIZE_UI(ActivityButtonDistance));
        make.width.mas_offset(RESIZE_UI(ActivityButtonWidth));
        make.height.mas_offset(RESIZE_UI(ActivityButtonHeight));
    }];
    
    _button2 = [[UIButton alloc]init];
//    [_button2 setBackgroundImage:[UIImage imageNamed:@"btn_kscj"] forState:UIControlStateNormal];
    [_zhuanPanView addSubview:_button2];
    [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerButton.mas_centerY);
        make.right.equalTo(_centerButton.mas_left).with.offset(-RESIZE_UI(ActivityButtonDistance));
        make.width.mas_offset(RESIZE_UI(ActivityButtonWidth));
        make.height.mas_offset(RESIZE_UI(ActivityButtonHeight));
    }];
    
    _button3 = [[UIButton alloc]init];
//    [_button3 setBackgroundImage:[UIImage imageNamed:@"btn_kscj"] forState:UIControlStateNormal];
    [_zhuanPanView addSubview:_button3];
    [_button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_centerButton.mas_left).with.offset(-RESIZE_UI(ActivityButtonDistance));
        make.bottom.equalTo(_centerButton.mas_top).with.offset(-RESIZE_UI(ActivityButtonDistance));
        make.width.mas_offset(RESIZE_UI(ActivityButtonWidth));
        make.height.mas_offset(RESIZE_UI(ActivityButtonHeight));
    }];
    
    _button4 = [[UIButton alloc]init];
//    [_button4 setBackgroundImage:[UIImage imageNamed:@"btn_kscj"] forState:UIControlStateNormal];
    [_zhuanPanView addSubview:_button4];
    [_button4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_centerButton.mas_centerX);
        make.bottom.equalTo(_centerButton.mas_top).with.offset(-RESIZE_UI(ActivityButtonDistance));
        make.width.mas_offset(RESIZE_UI(ActivityButtonWidth));
        make.height.mas_offset(RESIZE_UI(ActivityButtonHeight));
    }];
    
    _button5 = [[UIButton alloc]init];
//    [_button5 setBackgroundImage:[UIImage imageNamed:@"btn_kscj"] forState:UIControlStateNormal];
    [_zhuanPanView addSubview:_button5];
    [_button5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerButton.mas_right).with.offset(RESIZE_UI(ActivityButtonDistance));
        make.bottom.equalTo(_centerButton.mas_top).with.offset(-RESIZE_UI(ActivityButtonDistance));
        make.width.mas_offset(RESIZE_UI(ActivityButtonWidth));
        make.height.mas_offset(RESIZE_UI(ActivityButtonHeight));
    }];
    
    _button6 = [[UIButton alloc]init];
//    [_button6 setBackgroundImage:[UIImage imageNamed:@"btn_kscj"] forState:UIControlStateNormal];
    [_zhuanPanView addSubview:_button6];
    [_button6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerButton.mas_centerY);
        make.left.equalTo(_centerButton.mas_right).with.offset(RESIZE_UI(ActivityButtonDistance));
        make.width.mas_offset(RESIZE_UI(ActivityButtonWidth));
        make.height.mas_offset(RESIZE_UI(ActivityButtonHeight));
    }];
    
    _button7 = [[UIButton alloc]init];
//    [_button7 setBackgroundImage:[UIImage imageNamed:@"btn_kscj"] forState:UIControlStateNormal];
    [_zhuanPanView addSubview:_button7];
    [_button7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerButton.mas_bottom).with.offset(RESIZE_UI(ActivityButtonDistance));
        make.left.equalTo(_centerButton.mas_right).with.offset(RESIZE_UI(ActivityButtonDistance));
        make.width.mas_offset(RESIZE_UI(ActivityButtonWidth));
        make.height.mas_offset(RESIZE_UI(ActivityButtonHeight));
    }];
    
    _button8 = [[UIButton alloc]init];
//    [_button8 setBackgroundImage:[UIImage imageNamed:@"btn_kscj"] forState:UIControlStateNormal];
    [_zhuanPanView addSubview:_button8];
    [_button8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerButton.mas_bottom).with.offset(RESIZE_UI(ActivityButtonDistance));
        make.centerX.equalTo(_centerButton.mas_centerX);
        make.width.mas_offset(RESIZE_UI(ActivityButtonWidth));
        make.height.mas_offset(RESIZE_UI(ActivityButtonHeight));
    }];
    
    //按钮数组
    _buttonArray = [[NSArray alloc]initWithObjects:_button1,_button2,_button3,
                    _button4,_button5,_button6,_button7,_button8, nil];
    _fugaiArray = [[NSMutableArray alloc]init];
    for (int i=0; i<_buttonArray.count; i++) {
        UIButton *buttonHa = _buttonArray[i];
        LotteryModel *lotteryModel = _lotteryArray[i];
        [buttonHa sd_setImageWithURL:[NSURL URLWithString:lotteryModel.icon] forState:UIControlStateNormal];
        UIImageView *redImageView = [[UIImageView alloc] init];
        redImageView.image = [UIImage imageNamed:@"image_zhezhao"];
        redImageView.hidden = YES;
        [self.view addSubview:redImageView];
        [redImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(buttonHa);
        }];
        [_fugaiArray addObject:redImageView];
    }
    
    
//    _randomSelectNumber = 6;
    
}

#pragma mark - 抽奖接口
- (void)chouJiangInterfaceMethod {
    NetManager *manager = [[NetManager alloc] init];
//    [SVProgressHUD showWithStatus:@"请稍后"];
    [_centerButton setUserInteractionEnabled:NO];
    [manager postDataWithUrlActionStr:@"Raffle/handle" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        [_centerButton setUserInteractionEnabled:YES];
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            NSDictionary *dic = obj[@"data"];
            NSString *lotteryId = dic[@"id"];
            _randomSelectNumber = [lotteryId integerValue];
            for (int i=0; i<_lotteryArray.count; i++) {
                LotteryModel *lotteryModel = _lotteryArray[i];
                if ([lotteryModel.lotteryId isEqualToString:lotteryId]) {
                    //抽中的第几个
//                    _randomSelectNumber = i+1;
                    _selectLotteryModel = lotteryModel;
                    NSLog(@"抽中的第:%ld个",(long)i+1);
                }
            }
            if ([_exchangeNumber isEqualToString:@"1"]) {
                _exchangeNumber = @"0";
                if (_choujiangChanceLabel) {
                    _choujiangChanceLabel.text = @"您还有0次抽奖机会";
                }
                [self canChouJiangMethod];
            }
            [self startChouJiangActivity];
            
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

#pragma mark - 开始抽奖
- (void)startChouJiangActivity {
    //更新可抽奖次数
    [self updateExchangeNumberMethod];
    _circleTime = 1;//第一次循环
    _count = 7;
    _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(circlationLayoutMethod) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    
}

- (void)circlationLayoutMethod {
    [self InitFuGaiViewMethod:7-_count];
    _count--;
    
    if (_circleTime == 4) {
        if (_count == 7-_randomSelectNumber) {
            [_timer invalidate];
            _timer = nil;
            //中奖框
            [self showRegardView];
        }
    } else {
        if (_count<0) {
            _circleTime++;
            if (_circleTime<5) {
                _count =7;
            } else {
                [_timer invalidate];
                _timer = nil;
            }
        }
        
    }
}

#pragma mark - 移动覆盖view
- (void)InitFuGaiViewMethod:(NSInteger)row {
    for (int i=0; i<_fugaiArray.count; i++) {
        UIView *fugaiHa = _fugaiArray[i];
        if (i == row) {
            fugaiHa.hidden = NO;
        } else {
            fugaiHa.hidden = YES;
        }
    }
}

#pragma mark - 移出覆盖view
- (void)RemoveFuGaiViewMethod {
    [_fugaiView removeFromSuperview];
    _fugaiView = nil;
}

#pragma mark - 弹出奖励框
- (void)showRegardView {
    NSLog(@"中奖啦");
    WinPrizeView *winprizeView = [[WinPrizeView alloc]initWithLotteryModel:_selectLotteryModel];
    [self.view addSubview:winprizeView];
    [winprizeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 查看中奖纪录
- (void)watchPrizeRecordMethod {
    
    NetManager *manager = [[NetManager alloc] init];
    _lotteryArray = [[NSMutableArray alloc]init];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableArray *prizeRecordArray = [[NSMutableArray alloc]init];
    [manager postDataWithUrlActionStr:@"Raffle/my" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            NSArray *prizeArray = obj[@"data"];
            [PrizeRecordModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"prizeRecordId" : @"id"};
            }];
            for (int i=0; i<prizeArray.count; i++) {
                NSDictionary *dic = prizeArray[i];
                PrizeRecordModel *prizeModel = [PrizeRecordModel mj_objectWithKeyValues:dic];
                [prizeRecordArray addObject:prizeModel];
            }
            PrizeRecordView *prizeRecordView = [[PrizeRecordView alloc]initWithPrizeRecordArray:prizeRecordArray];
            [self.view addSubview:prizeRecordView];
            [prizeRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            
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
