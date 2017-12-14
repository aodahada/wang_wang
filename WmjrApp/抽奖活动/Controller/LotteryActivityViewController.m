//
//  LotteryActivityViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/12/11.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "LotteryActivityViewController.h"

#define ActivityButtonWidth 60
#define ActivityButtonDistance 20

@interface LotteryActivityViewController ()

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
    self.title = @"大转盘";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self setUpLayoutZhuanPan];
    [self InitJieMian];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LotteryActivityViewController"];
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
    
    [_viewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomImageView.mas_bottom);
    }];
    
    [self setUpLayoutZhuanPan];
    
}

#pragma mark - 转盘
- (void)setUpLayoutZhuanPan {
    _zhuanPanView = [[UIView alloc]init];
    _zhuanPanView.backgroundColor = [UIColor whiteColor];
    [_centerImageView addSubview:_zhuanPanView];
    [_zhuanPanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerImageView.mas_top).with.offset(RESIZE_UI(130));
        make.left.equalTo(_centerImageView.mas_left).with.offset(RESIZE_UI(40));
        make.right.equalTo(_centerImageView.mas_right).with.offset(RESIZE_UI(-40));
        make.bottom.equalTo(_centerImageView.mas_bottom).with.offset(-RESIZE_UI(60));
    }];
    
    _centerButton = [[UIButton alloc]init];
    [_centerButton setBackgroundImage:[UIImage imageNamed:@"btn_kscj"] forState:UIControlStateNormal];
    [_centerButton addTarget:self action:@selector(startChouJiangActivity) forControlEvents:UIControlEventTouchUpInside];
    [_zhuanPanView addSubview:_centerButton];
    [_centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_zhuanPanView.mas_centerY);
        make.centerX.equalTo(_zhuanPanView.mas_centerX);
        make.width.height.mas_offset(RESIZE_UI(ActivityButtonWidth));
    }];
    
    _button1 = [[UIButton alloc]init];
    [_button1 setBackgroundImage:[UIImage imageNamed:@"btn_kscj"] forState:UIControlStateNormal];
    [_zhuanPanView addSubview:_button1];
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_centerButton.mas_left).with.offset(-RESIZE_UI(ActivityButtonDistance));
        make.top.equalTo(_centerButton.mas_bottom).with.offset(RESIZE_UI(ActivityButtonDistance));
        make.width.height.mas_offset(RESIZE_UI(ActivityButtonWidth));
    }];
    
    _button2 = [[UIButton alloc]init];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"btn_kscj"] forState:UIControlStateNormal];
    [_zhuanPanView addSubview:_button2];
    [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerButton.mas_centerY);
        make.right.equalTo(_centerButton.mas_left).with.offset(-RESIZE_UI(ActivityButtonDistance));
        make.width.height.mas_offset(RESIZE_UI(ActivityButtonWidth));
    }];
    
    _button3 = [[UIButton alloc]init];
    [_button3 setBackgroundImage:[UIImage imageNamed:@"btn_kscj"] forState:UIControlStateNormal];
    [_zhuanPanView addSubview:_button3];
    [_button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_centerButton.mas_left).with.offset(-RESIZE_UI(ActivityButtonDistance));
        make.bottom.equalTo(_centerButton.mas_top).with.offset(-RESIZE_UI(ActivityButtonDistance));
        make.width.height.mas_offset(RESIZE_UI(ActivityButtonWidth));
    }];
    
    _button4 = [[UIButton alloc]init];
    [_button4 setBackgroundImage:[UIImage imageNamed:@"btn_kscj"] forState:UIControlStateNormal];
    [_zhuanPanView addSubview:_button4];
    [_button4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_centerButton.mas_centerX);
        make.bottom.equalTo(_centerButton.mas_top).with.offset(-RESIZE_UI(ActivityButtonDistance));
        make.width.height.mas_offset(RESIZE_UI(ActivityButtonWidth));
    }];
    
    _button5 = [[UIButton alloc]init];
    [_button5 setBackgroundImage:[UIImage imageNamed:@"btn_kscj"] forState:UIControlStateNormal];
    [_zhuanPanView addSubview:_button5];
    [_button5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerButton.mas_right).with.offset(RESIZE_UI(ActivityButtonDistance));
        make.bottom.equalTo(_centerButton.mas_top).with.offset(-RESIZE_UI(ActivityButtonDistance));
        make.width.height.mas_offset(RESIZE_UI(ActivityButtonWidth));
    }];
    
    _button6 = [[UIButton alloc]init];
    [_button6 setBackgroundImage:[UIImage imageNamed:@"btn_kscj"] forState:UIControlStateNormal];
    [_zhuanPanView addSubview:_button6];
    [_button6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerButton.mas_centerY);
        make.left.equalTo(_centerButton.mas_right).with.offset(RESIZE_UI(ActivityButtonDistance));
        make.width.height.mas_offset(RESIZE_UI(ActivityButtonWidth));
    }];
    
    _button7 = [[UIButton alloc]init];
    [_button7 setBackgroundImage:[UIImage imageNamed:@"btn_kscj"] forState:UIControlStateNormal];
    [_zhuanPanView addSubview:_button7];
    [_button7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerButton.mas_bottom).with.offset(RESIZE_UI(ActivityButtonDistance));
        make.left.equalTo(_centerButton.mas_right).with.offset(RESIZE_UI(ActivityButtonDistance));
        make.width.height.mas_offset(RESIZE_UI(ActivityButtonWidth));
    }];
    
    _button8 = [[UIButton alloc]init];
    [_button8 setBackgroundImage:[UIImage imageNamed:@"btn_kscj"] forState:UIControlStateNormal];
    [_zhuanPanView addSubview:_button8];
    [_button8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerButton.mas_bottom).with.offset(RESIZE_UI(ActivityButtonDistance));
        make.centerX.equalTo(_centerButton.mas_centerX);
        make.width.height.mas_offset(RESIZE_UI(ActivityButtonWidth));
    }];
    
    //按钮数组
    _buttonArray = [[NSArray alloc]initWithObjects:_button1,_button2,_button3,
                    _button4,_button5,_button6,_button7,_button8, nil];
    _fugaiArray = [[NSMutableArray alloc]init];
    for (int i=0; i<_buttonArray.count; i++) {
        UIButton *buttonHa = _buttonArray[i];
        UIImageView *redImageView = [[UIImageView alloc] init];
        redImageView.image = [UIImage imageNamed:@"image_zhezhao"];
        redImageView.hidden = YES;
        [self.view addSubview:redImageView];
        [redImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(buttonHa);
        }];
        [_fugaiArray addObject:redImageView];
    }
    
    
    _randomSelectNumber = 6;
    
}

#pragma mark - 开始抽奖
- (void)startChouJiangActivity {
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
