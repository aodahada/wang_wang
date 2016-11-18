//
//  SafeEnsureViewController.m
//  WmjrApp
//
//  Created by horry on 2016/11/16.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "SafeEnsureViewController.h"

#define selecColor [UIColor colorWithRed:29/255.0 green:98/255.0 blue:166/255.0 alpha:1.0]
#define unSelectColor [UIColor colorWithRed:165/255.0 green:165/255.0 blue:165/255.0 alpha:1.0]

@interface SafeEnsureViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *buttonForWangma;//旺马
@property (nonatomic, strong) UIButton *buttonForSina;//新浪

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, assign) BOOL isBottom;//有没有滑动到底部
@property (nonatomic, assign) NSInteger yDistance;//Y的距离

@end

@implementation SafeEnsureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isBottom = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *viewForNav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    
    _buttonForWangma = [[UIButton alloc]init];
    [_buttonForWangma setTitle:@"旺马平台" forState:UIControlStateNormal];
    [_buttonForWangma setTitleColor:selecColor forState:UIControlStateNormal];
    [_buttonForWangma.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(17)]];
    [_buttonForWangma addTarget:self action:@selector(buttonActionMethod:) forControlEvents:UIControlEventTouchUpInside];
    [viewForNav addSubview:_buttonForWangma];
    [_buttonForWangma mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(100);
        make.top.equalTo(viewForNav.mas_top);
        make.bottom.equalTo(viewForNav.mas_bottom);
        make.left.equalTo(viewForNav.mas_left);
    }];
    
    _buttonForSina = [[UIButton alloc]init];
    _buttonForSina = [[UIButton alloc]init];
    [_buttonForSina setTitle:@"新浪平台" forState:UIControlStateNormal];
    [_buttonForSina setTitleColor:unSelectColor forState:UIControlStateNormal];
    [_buttonForSina addTarget:self action:@selector(buttonActionMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonForSina.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(17)]];
    [viewForNav addSubview:_buttonForSina];
    [_buttonForSina mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_buttonForWangma.mas_width);
        make.top.equalTo(viewForNav.mas_top);
        make.bottom.equalTo(viewForNav.mas_bottom);
        make.right.equalTo(viewForNav.mas_right);
    }];
    
    self.navigationItem.titleView = viewForNav;
    
    
    _mainScrollView = [[UIScrollView alloc]init];
    _mainScrollView.backgroundColor = [UIColor orangeColor];
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = NO;
    [self.view addSubview:_mainScrollView];
    [_mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _mainView = [[UIView alloc]init];
    [_mainScrollView addSubview:_mainView];
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mainScrollView);
        make.width.equalTo(self.view.mas_width);
    }];
    
    _imageView1 = [[UIImageView alloc]init];
    _imageView1.image = [UIImage imageNamed:@"image_wangma1"];
    [_mainView addSubview:_imageView1];
    [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainView.mas_top);
        make.left.equalTo(_mainView.mas_left);
        make.right.equalTo(_mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(667));
    }];
    
    _imageView2 = [[UIImageView alloc]init];
    _imageView2.image = [UIImage imageNamed:@"image_wangma2"];
    [_mainView addSubview:_imageView2];
    [_imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView1.mas_bottom);
        make.left.equalTo(_mainView.mas_left);
        make.right.equalTo(_mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(667));
    }];
    
    _imageView3 = [[UIImageView alloc]init];
    _imageView3.image = [UIImage imageNamed:@"image_wangma3"];
    [_mainView addSubview:_imageView3];
    [_imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView2.mas_bottom);
        make.left.equalTo(_mainView.mas_left);
        make.right.equalTo(_mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(614));
        make.bottom.equalTo(_mainView.mas_bottom).with.offset(49);
    }];
    
}

- (void)buttonActionMethod:(UIButton *)btn {
    if (btn == _buttonForWangma) {
        [_buttonForWangma setTitleColor:selecColor forState:UIControlStateNormal];
        [_buttonForSina setTitleColor:unSelectColor forState:UIControlStateNormal];
        _imageView1.image = [UIImage imageNamed:@"image_wangma1"];
        _imageView2.image = [UIImage imageNamed:@"image_wangma2"];
        _imageView3.image = [UIImage imageNamed:@"image_wangma3"];
        [_imageView3 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(RESIZE_UI(614));
        }];
        [_mainScrollView setContentOffset:CGPointMake(0,0) animated:YES];
    } else {
        [_buttonForWangma setTitleColor:unSelectColor forState:UIControlStateNormal];
        [_buttonForSina setTitleColor:selecColor forState:UIControlStateNormal];
        _imageView1.image = [UIImage imageNamed:@"image_sina1"];
        _imageView2.image = [UIImage imageNamed:@"image_sina2"];
        _imageView3.image = [UIImage imageNamed:@"image_sina3"];
        [_imageView3 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(RESIZE_UI(447));
        }];
        if (_isBottom) {
            [_mainScrollView setContentOffset:CGPointMake(0,RESIZE_UI(614-447)-_yDistance) animated:YES];
        } else{
            [_mainScrollView setContentOffset:CGPointMake(0,0) animated:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    if (y>RESIZE_UI(667)+RESIZE_UI(667)-RESIZE_UI(1948-1345)) {
        _isBottom = YES;
        _yDistance = (RESIZE_UI(667)+RESIZE_UI(667)+RESIZE_UI(614)-RESIZE_UI(1948-1345))-y;
    } else {
        _isBottom = NO;
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
