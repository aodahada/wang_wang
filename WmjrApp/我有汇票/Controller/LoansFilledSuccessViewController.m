//
//  LoansFilledSuccessViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/11/21.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "LoansFilledSuccessViewController.h"
#import "ApplyRecordViewController.h"

@interface LoansFilledSuccessViewController ()

@end

@implementation LoansFilledSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"借款信息填写";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpLayout];
}

- (void)setUpLayout {
    UIImageView *rightImageView = [[UIImageView alloc]init];
    rightImageView.image = [UIImage imageNamed:@"icon_done_blue"];
    [self.view addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(RESIZE_UI(64));
        make.width.height.mas_offset(RESIZE_UI(100));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"您的借款申请已经提交成功";
    tipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(22)];
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightImageView.mas_bottom).with.offset(RESIZE_UI(29));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UILabel *bottomTipLabel = [[UILabel alloc]init];
    bottomTipLabel.text = @"平台工作人员近期会与您联系，请保持电话畅通。";
    bottomTipLabel.textColor  = RGBA(153, 153, 153, 1.0);
    bottomTipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    bottomTipLabel.numberOfLines = 2;
    bottomTipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomTipLabel];
    [bottomTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).with.offset(RESIZE_UI(15));
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_offset(RESIZE_UI(233));
    }];
    
    UIButton *backButton = [[UIButton alloc]init];
    [backButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [backButton setTitleColor:RGBA(255, 88, 26, 1.0) forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    backButton.layer.borderColor = RGBA(255, 88, 26, 1.0).CGColor;
    backButton.layer.borderWidth = 1.0f;
    [backButton addTarget:self action:@selector(backToShouYe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-RESIZE_UI(40));
        make.left.equalTo(self.view.mas_left).with.offset(RESIZE_UI(40));
        make.width.mas_offset(RESIZE_UI(130));
        make.height.mas_offset(RESIZE_UI(48));
    }];
    
    UIButton *watchApplyRecordButton = [[UIButton alloc]init];
    [watchApplyRecordButton setTitle:@"查看申请记录" forState:UIControlStateNormal];
    [watchApplyRecordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    watchApplyRecordButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    [watchApplyRecordButton setBackgroundColor:RGBA(255, 88, 26, 1.0)];
    [watchApplyRecordButton addTarget:self action:@selector(jumpToApplyRecordMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:watchApplyRecordButton];
    [watchApplyRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backButton.mas_top);
        make.right.equalTo(self.view.mas_right).with.offset(-RESIZE_UI(48));
        make.width.mas_offset(RESIZE_UI(130));
        make.height.mas_offset(RESIZE_UI(48));
    }];
    
}

- (void)backToShouYe {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)jumpToApplyRecordMethod {
    ApplyRecordViewController *applyRecordVC = [[ApplyRecordViewController alloc]init];
    [self.navigationController pushViewController:applyRecordVC animated:YES];
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
