//
//  AliGesturePasswordViewController.m
//  WmjrApp
//
//  Created by horry on 16/9/6.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "AliGesturePasswordViewController.h"
#import "AliPayViews.h"
#import "KeychainData.h"
#import "ModifyGesPassView.h"

@interface AliGesturePasswordViewController ()

@property (nonatomic, strong) UIView *viewForBack;
@property (nonatomic, strong) ModifyGesPassView *viewForModify;
@property (nonatomic, strong) UITapGestureRecognizer *tapGes;

@end

@implementation AliGesturePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AliPayViews *alipay = [[AliPayViews alloc] initWithFrame:self.view.bounds andType:_type];
    
    if ([self.string isEqualToString:@"验证密码"]) {
        alipay.gestureModel = ValidatePwdModel;
    } else if ([self.string isEqualToString:@"修改密码"]) {
        alipay.gestureModel = AlertPwdModel;
    } else if ([self.string isEqualToString:@"重置密码"]) {
        alipay.gestureModel = SetPwdModel;
    } else {
        alipay.gestureModel = NoneModel;
    }
    @weakify(self)
    alipay.block = ^(NSString *pswString) {
        @strongify(self)
        NSLog(@"设置密码成功-----你的密码为 = 【%@】\n\n", pswString);
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"backToRoot" object:nil];
        }];
    };
    
    alipay.buHaBlock = ^(){
        @strongify(self)
        [self buttonHaMethod];
    };
    
    [self.view addSubview:alipay];
    
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 64, 64);
//    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backBtn];
    
}

- (void)buttonHaMethod {
    
    if ([_type isEqualToString:@"更多"]) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } else if ([_type isEqualToString:@"注册"]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"backToRoot" object:nil];
        }];
    } else {
        
        _viewForBack = [[UIView alloc]init];
        UIColor *color = [UIColor grayColor];
        _viewForBack.backgroundColor = [color colorWithAlphaComponent:0.8];
        [self.view addSubview:_viewForBack];
        [_viewForBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        _tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesMethod)];
        [_viewForBack addGestureRecognizer:_tapGes];
        
        _viewForModify = [[ModifyGesPassView alloc]init];
        @weakify(self)
        _viewForModify.cancelModifyView = ^(){
            @strongify(self)
            [self tapGesMethod];
            
        };
        _viewForModify.canThroughPass = ^(){
            @strongify(self)
            //        [self dismissViewControllerAnimated:YES completion:^{
            //
            //        }];
            //要求跳转到手势绘制模块
            [self tapGesMethod];
            [[SingletonManager sharedManager] removeHandGestureInfoDefault];
            [self dismissViewControllerAnimated:YES completion:^{
                [SVProgressHUD showInfoWithStatus:@"请去更多模块中重置手势密码"];
            }];
            
        };
        _viewForModify.layer.masksToBounds = YES;
        _viewForModify.layer.cornerRadius = 15;
        [_viewForBack addSubview:_viewForModify];
        [_viewForModify mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.height.mas_offset(199);
            make.width.mas_offset(300);
        }];
        
    }
}

- (void)tapGesMethod {
    
    [_viewForModify removeFromSuperview];
    [_viewForBack removeGestureRecognizer:_tapGes];
    [_viewForBack removeFromSuperview];
    
}

- (void)back  {
    [self dismissViewControllerAnimated:YES completion:nil];
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
