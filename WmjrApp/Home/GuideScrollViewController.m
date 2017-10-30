//
//  GuideScrollViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/9/15.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "GuideScrollViewController.h"

@interface GuideScrollViewController ()

@end

@implementation GuideScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIScrollView *mainScrollView = [[UIScrollView alloc]init];
    mainScrollView.backgroundColor = [UIColor redColor];
    mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*4, SCREEN_HEIGHT);
    mainScrollView.pagingEnabled = YES;
    mainScrollView.bounces = NO;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.image = [UIImage imageNamed:@"引导1"];
    imageView1.userInteractionEnabled = YES;
    imageView1.exclusiveTouch = YES;
    [mainScrollView addSubview:imageView1];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainScrollView.mas_top);
        make.left.equalTo(mainScrollView.mas_left);
        make.width.mas_offset(SCREEN_WIDTH);
        make.height.mas_offset(SCREEN_HEIGHT);
    }];
    
    UIImageView *imageView2 = [[UIImageView alloc]init];
    imageView2.image = [UIImage imageNamed:@"引导2"];
    imageView2.userInteractionEnabled = YES;
    imageView2.exclusiveTouch = YES;
    [mainScrollView addSubview:imageView2];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainScrollView.mas_top);
        make.left.equalTo(mainScrollView.mas_left).with.offset(SCREEN_WIDTH);
        make.width.mas_offset(SCREEN_WIDTH);
        make.height.mas_offset(SCREEN_HEIGHT);
    }];
    
    UIImageView *imageView3 = [[UIImageView alloc]init];
    imageView3.image = [UIImage imageNamed:@"引导3"];
    imageView3.userInteractionEnabled = YES;
    imageView3.exclusiveTouch = YES;
    [mainScrollView addSubview:imageView3];
    [imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainScrollView.mas_top);
        make.left.equalTo(mainScrollView.mas_left).with.offset(SCREEN_WIDTH*2);
        make.width.mas_offset(SCREEN_WIDTH);
        make.height.mas_offset(SCREEN_HEIGHT);
    }];
    
    UIImageView *imageView4 = [[UIImageView alloc]init];
    imageView4.image = [UIImage imageNamed:@"引导4"];
    imageView4.userInteractionEnabled = YES;
    imageView4.exclusiveTouch = YES;
    [mainScrollView addSubview:imageView4];
    [imageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainScrollView.mas_top);
        make.left.equalTo(mainScrollView.mas_left).with.offset(SCREEN_WIDTH*3);
        make.width.mas_offset(SCREEN_WIDTH);
        make.height.mas_offset(SCREEN_HEIGHT);
    }];
    
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeGuideMethod) forControlEvents:UIControlEventTouchUpInside];
    [imageView4 addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageView4.mas_bottom).with.offset(-RESIZE_UI(60));
        make.width.mas_offset(RESIZE_UI(157));
        make.height.mas_offset(RESIZE_UI(50));
        make.centerX.equalTo(imageView4.mas_centerX);
    }];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nihao)];
//    [self.view addGestureRecognizer:tap];

}

- (void)closeGuideMethod {
//    NSLog(@"你好");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeGuide" object:nil];
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
