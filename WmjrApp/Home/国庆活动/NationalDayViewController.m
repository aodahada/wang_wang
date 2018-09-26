//
//  NationalDayViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/9/25.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "NationalDayViewController.h"

@interface NationalDayViewController ()

@end

@implementation NationalDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"国庆活动";
    
    UIScrollView *mainScrollView = [[UIScrollView alloc]init];
    mainScrollView.backgroundColor = [UIColor whiteColor];
    mainScrollView.bounces = NO;
    [self.view addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *mainView = [[UIView alloc]init];
    mainView.backgroundColor = [UIColor whiteColor];
    [mainScrollView addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"guoqing_xiangqingye"];
    imageView.userInteractionEnabled = YES;
    [mainView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView.mas_top);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(1066));
    }];
    
    UIButton *qiangButton = [[UIButton alloc]init];
    [qiangButton setBackgroundImage:[UIImage imageNamed:@"guoqing_button"] forState:UIControlStateNormal];
    [qiangButton addTarget:self action:@selector(likeqiangMethod) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:qiangButton];
    [qiangButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView.mas_top).with.offset(RESIZE_UI(238));
        make.centerX.equalTo(mainView.mas_centerX);
        make.width.mas_offset(RESIZE_UI(138));
        make.height.mas_offset(RESIZE_UI(42));
    }];
    
    [mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageView.mas_bottom);
    }];

}

#pragma mark - button方法
- (void)likeqiangMethod {
    NSLog(@"立刻抢");
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
