//
//  FRuleViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 16/1/28.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "FRuleViewController.h"

@interface FRuleViewController ()

@end

@implementation FRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"奖励规则";
    self.tabBarController.tabBar.hidden = YES;
    UIImageView *imageViewForMess = [[UIImageView alloc]init];
    imageViewForMess.image = [UIImage imageNamed:@"image_guize"];
    [self.view addSubview:imageViewForMess];
    [imageViewForMess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(10);
        make.height.mas_offset(SCREEN_WIDTH/375*600);
        make.width.mas_offset(SCREEN_WIDTH);
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
