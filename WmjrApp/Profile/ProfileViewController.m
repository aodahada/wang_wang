//
//  ProfileViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/6/17.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "ProfileViewController.h"
#import "MyselfManageFinanceController.h"
#import "MyRecommendatViewController.h"
#import "MyselfTransactionController.h"
#import "MyselfAccountController.h"
#import "MessageWViewController.h"
#import "LoginViewController.h"
#import "DrawalViewController.h"
#import "RechargeViewController.h"
#import "MMPopupWindow.h"
#import "RealNameCertificationViewController.h"
#import "MMPopupItem.h"
#import "MyRecommendatViewController.h"
#import "MyselfBankViewController.h"
#import "AddBankViewController.h"
#import "PersonalMessageViewController.h"
#import "NewMoreViewController.h"
#import "BaseNavigationController.h"
#import "MyselfTransactionController.h"
#import "PersonalCategoryCollectionViewCell.h"
#import "StoreClassCollectionReusableView.h"
#import "AccountAndPasswordViewController.h"
#import "MyRedPackageViewController.h"
#import "RedPackageModel.h"
#import "AppDelegate.h"
#import "IntegralShopViewController.h"

@interface ProfileViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSString *balanceValue;

@property (nonatomic, strong) UIImageView *imageViewForHead;

@property (nonatomic, strong) UILabel *labelForName;

@property (nonatomic, weak) UICollectionView *classCollectionView;
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)UIView *blackBottomView;//二维码黑背景
@property (nonatomic, strong)UIView *whiteBottomView;//二维码白背景
@property (nonatomic, strong)UIImageView *codeImageView;//二维码图片
@property (nonatomic, strong)UIImageView *codeHeadImage;//二维码中间头像
@property (nonatomic, strong)UITapGestureRecognizer *tapGes;//点击手势

@property (nonatomic, strong)UIView *naviView;

@property (nonatomic, strong)UILabel *numberLabel;//我的红包数字label

@property (nonatomic, strong)NSMutableArray *redPackageArray;

@property (nonatomic, strong)UILabel *integraLabel;//积分label

@end

@implementation ProfileViewController

//头视图
- (UIView *)setUpProfileHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,RESIZE_UI(187+49+12))];
    headView.backgroundColor = RGBA(237, 240, 242, 1.0);
//    headView.backgroundColor = [UIColor redColor];
    UIImageView *imageViewForBackground = [[UIImageView alloc]init];
    imageViewForBackground.image = [UIImage imageNamed:@"image_me_bg-2"];
    [headView addSubview:imageViewForBackground];
    [imageViewForBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top);
        make.left.equalTo(headView.mas_left);
        make.right.equalTo(headView.mas_right);
        make.height.mas_offset(RESIZE_UI(187));
    }];
    
    UIImageView *imageViewForLeft = [[UIImageView alloc]init];
    imageViewForLeft.image = [UIImage imageNamed:@"icon_more"];
    [headView addSubview:imageViewForLeft];
    [imageViewForLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).with.offset(RESIZE_UI(34));
        make.left.equalTo(headView.mas_left).with.offset(RESIZE_UI(15));
        make.height.mas_offset(RESIZE_UI(16));
        make.width.mas_offset(RESIZE_UI(6));
    }];
    
    UILabel *lableForMore = [[UILabel alloc] init];
    lableForMore.text = @"更多";
    lableForMore.textAlignment = NSTextAlignmentLeft;
    lableForMore.textColor = [UIColor whiteColor];
    lableForMore.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [headView addSubview:lableForMore];
    [lableForMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).with.offset(RESIZE_UI(34));
        make.left.equalTo(headView.mas_left).with.offset(RESIZE_UI(34));
        make.height.mas_offset(RESIZE_UI(16));
    }];
    
    UIButton *buttonForMore = [[UIButton alloc]init];
    buttonForMore.backgroundColor = [UIColor clearColor];
    [buttonForMore addTarget:self action:@selector(jumpToMoreMethod) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:buttonForMore];
    [buttonForMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageViewForLeft.mas_top).with.offset(-20);
        make.bottom.equalTo(imageViewForLeft.mas_bottom).with.offset(20);
        make.left.equalTo(headView.mas_left);
        make.right.equalTo(lableForMore.mas_right).with.offset(20);
    }];
    
    /*  消息  */
    UIButton *buttonForMessCenter = [[UIButton alloc]init];
//    [buttonForMessCenter setBackgroundImage:[UIImage imageNamed:@"notific"] forState:UIControlStateNormal];
    [buttonForMessCenter setImage:[UIImage imageNamed:@"icon_xx"] forState:UIControlStateNormal];
    [buttonForMessCenter addTarget:self action:@selector(messageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:buttonForMessCenter];
    [buttonForMessCenter mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(headView.mas_top).with.offset(RESIZE_UI(33));
        make.centerY.equalTo(lableForMore.mas_centerY);
        make.right.equalTo(headView.mas_right).with.offset(RESIZE_UI(-15));
        make.height.mas_offset(RESIZE_UI(30));
        make.width.mas_offset(RESIZE_UI(30));
    }];
    
//    UIButton *buttonForMessCenter = [[UIButton alloc]init];
//    [buttonForMessCenter setTitle:@"消息中心" forState:UIControlStateNormal];
////    [buttonForMessCenter setBackgroundColor:[UIColor redColor]];
//    [buttonForMessCenter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    buttonForMessCenter.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
//    [buttonForMessCenter addTarget:self action:@selector(messageBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [headView addSubview:buttonForMessCenter];
//    [buttonForMessCenter mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(lableForMore.mas_centerY);
//        make.right.equalTo(headView.mas_right).with.offset(RESIZE_UI(-12));
//        make.width.mas_offset(RESIZE_UI(80));
//        make.height.mas_offset(RESIZE_UI(18));
//    }];
    
    //二维码
    UIButton *codeButton = [[UIButton alloc]init];
    [codeButton setBackgroundImage:[UIImage imageNamed:@"icon_ewm"] forState:UIControlStateNormal];
    [codeButton addTarget:self action:@selector(watchCodeMethod) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:codeButton];
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(buttonForMessCenter.mas_centerY);
        make.width.height.mas_offset(RESIZE_UI(30));
        make.right.equalTo(buttonForMessCenter.mas_left).with.offset(RESIZE_UI(-15));
    }];
    
    _imageViewForHead = [[UIImageView alloc]init];
    [_imageViewForHead sd_setImageWithURL:[NSURL URLWithString:[SingletonManager sharedManager].userModel.photourl] placeholderImage:[UIImage imageNamed:@"image_head"]];
    _imageViewForHead.layer.masksToBounds = YES;
    _imageViewForHead.layer.cornerRadius = RESIZE_UI(52)/2;
    [headView addSubview:_imageViewForHead];
    [_imageViewForHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).with.offset(RESIZE_UI(82));
        make.centerX.equalTo(headView.mas_centerX);
        make.width.height.mas_offset(RESIZE_UI(52));
    }];
    
    _labelForName = [[UILabel alloc]init];
    _labelForName.text = [SingletonManager sharedManager].userModel.name;
    _labelForName.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    _labelForName.textColor = [UIColor whiteColor];
    [headView addSubview:_labelForName];
    [_labelForName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageViewForHead.mas_bottom).with.offset(RESIZE_UI(6));
        make.centerX.equalTo(headView.mas_centerX);
        make.height.mas_offset(RESIZE_UI(14));
    }];
    
    UIButton *buttonForPersonal = [[UIButton alloc]init];
    buttonForPersonal.backgroundColor = [UIColor clearColor];
    [buttonForPersonal addTarget:self action:@selector(jumpToPersonalViewMethod) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:buttonForPersonal];
    [buttonForPersonal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageViewForHead.mas_top);
        make.left.equalTo(_imageViewForHead.mas_left);
        make.right.equalTo(_imageViewForHead.mas_right);
        make.bottom.equalTo(_labelForName.mas_bottom);
    }];
    
    UIView *viewForHeadButtom = [[UIView alloc]init];
    viewForHeadButtom.backgroundColor = RGBA(220, 223, 225, 1.0);
    [headView addSubview:viewForHeadButtom];
    [viewForHeadButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).with.offset(RESIZE_UI(187));
        make.left.equalTo(headView.mas_left);
        make.right.equalTo(headView.mas_right);
        make.height.mas_offset(RESIZE_UI(49));
    }];
    
    //我要充值
    UIView *viewForRecharge = [[UIView alloc]init];
    viewForRecharge.backgroundColor = [UIColor whiteColor];
    [viewForHeadButtom addSubview:viewForRecharge];
    [viewForRecharge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewForHeadButtom.mas_top);
        make.left.equalTo(viewForHeadButtom.mas_left);
        make.bottom.equalTo(viewForHeadButtom.mas_bottom);
        make.width.mas_offset(SCREEN_WIDTH/2-0.5);
    }];
    
    UIView *viewBottomForRecharge = [[UIView alloc]init];
    viewBottomForRecharge.backgroundColor = [UIColor whiteColor];
    [viewForRecharge addSubview:viewBottomForRecharge];
    [viewBottomForRecharge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewForRecharge.mas_centerY);
        make.height.mas_offset(RESIZE_UI(49));
        make.width.mas_offset(RESIZE_UI(110));
        make.centerX.equalTo(viewForRecharge.mas_centerX);
    }];
    
    UIImageView *rechargeImageView = [[UIImageView alloc]init];
    rechargeImageView.image = [UIImage imageNamed:@"icon_chzh"];
    [viewBottomForRecharge addSubview:rechargeImageView];
    [rechargeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewBottomForRecharge.mas_left);
        make.centerY.equalTo(viewForRecharge.mas_centerY);
        make.height.width.mas_offset(RESIZE_UI(28));
    }];
    
    UILabel *rechargeLabel = [[UILabel alloc]init];
    rechargeLabel.text = @"我要充值";
    rechargeLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    rechargeLabel.textColor = RGBA(20, 20, 23, 1.0);
    [viewBottomForRecharge addSubview:rechargeLabel];
    [rechargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rechargeImageView.mas_right).with.offset(RESIZE_UI(12));
        make.centerY.equalTo(viewForRecharge.mas_centerY);
        make.height.mas_offset(RESIZE_UI(24));
    }];
    
    UIButton *rechargeButton = [[UIButton alloc]init];
    [rechargeButton addTarget:self action:@selector(jumpToRechargeMethod) forControlEvents:UIControlEventTouchUpInside];
    [viewForRecharge addSubview:rechargeButton];
    [rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewForRecharge);
    }];
    
    //我要提现
    UIView *viewForWithdraw = [[UIView alloc]init];
    viewForWithdraw.backgroundColor = [UIColor whiteColor];
    [viewForHeadButtom addSubview:viewForWithdraw];
    [viewForWithdraw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewForHeadButtom.mas_top);
        make.right.equalTo(viewForHeadButtom.mas_right);
        make.bottom.equalTo(viewForHeadButtom.mas_bottom);
        make.width.mas_offset(SCREEN_WIDTH/2-0.5);
    }];
    
    UIView *viewBottomForWithdraw = [[UIView alloc]init];
    viewBottomForWithdraw.backgroundColor = [UIColor whiteColor];
    [viewForWithdraw addSubview:viewBottomForWithdraw];
    [viewBottomForWithdraw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewForWithdraw.mas_centerX);
        make.height.mas_offset(RESIZE_UI(49));
        make.width.mas_offset(RESIZE_UI(110));
        make.centerY.equalTo(viewForWithdraw.mas_centerY);
    }];
    
    UIImageView *withDrawImageView = [[UIImageView alloc]init];
    withDrawImageView.image = [UIImage imageNamed:@"icon_tixian"];
    [viewBottomForWithdraw addSubview:withDrawImageView];
    [withDrawImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewBottomForWithdraw.mas_left);
        make.centerY.equalTo(viewBottomForWithdraw.mas_centerY);
        make.width.mas_offset(RESIZE_UI(28));
        make.height.mas_offset(RESIZE_UI(23.2));
    }];
    
    UILabel *withDrawLabel = [[UILabel alloc]init];
    withDrawLabel.text = @"我要提现";
    withDrawLabel.textColor = RGBA(20, 20, 23, 1.0);
    withDrawLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    [viewBottomForWithdraw addSubview:withDrawLabel];
    [withDrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(withDrawImageView.mas_right).with.offset(RESIZE_UI(12));
        make.centerY.equalTo(viewBottomForWithdraw.mas_centerY);
        make.height.mas_offset(RESIZE_UI(24));
    }];
    
    UIButton *withDrawButton = [[UIButton alloc]init];
    [withDrawButton addTarget:self action:@selector(jumpToWithDrawMethod) forControlEvents:UIControlEventTouchUpInside];
    [viewForWithdraw addSubview:withDrawButton];
    [withDrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewForWithdraw);
    }];
    
    return headView;
}

#pragma mark - 查看二维码
- (void)watchCodeMethod {
    
    //生成黑色背景
    _blackBottomView = [[UIView alloc]init];
    _blackBottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    UIWindow *windows =[[UIApplication sharedApplication].delegate window];
    [windows addSubview:_blackBottomView];
    [_blackBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(windows);
    }];
    
    _tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAll)];
    [_blackBottomView addGestureRecognizer:_tapGes];
    
    //生成白色背景
    _whiteBottomView = [[UIView alloc]init];
    _whiteBottomView.backgroundColor = [UIColor whiteColor];
    _whiteBottomView.layer.masksToBounds = YES;
    _whiteBottomView.layer.cornerRadius = 10.0f;
    [_blackBottomView addSubview:_whiteBottomView];
    [_whiteBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_blackBottomView.mas_centerX);
        make.centerY.equalTo(_blackBottomView.mas_centerY);
        make.height.mas_offset(RESIZE_UI(473));
        make.width.mas_offset(RESIZE_UI(316));
    }];

    //生成二维码
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认
    [filter setDefaults];
    
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    //http://m.wangmacaifu.com/#/register/wmcf-xxxxxx
//    NSString *dataString = [NSString stringWithFormat:@"http://m.wmjr888.com/?invitationcode=%@#login-register",[SingletonManager sharedManager].userModel.invitationcode];
        NSString *dataString = [NSString stringWithFormat:@"http://m.wangmacaifu.com/#/register/wmcf-%@",[SingletonManager sharedManager].userModel.invitationcode];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5.显示二维码
    self.codeImageView = [[UIImageView alloc]init];
    [_whiteBottomView addSubview:self.codeImageView];
    self.codeImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_whiteBottomView.mas_centerX);
        make.centerY.equalTo(_whiteBottomView.mas_centerY);
        make.width.height.mas_offset(RESIZE_UI(242));
    }];
    
    _codeHeadImage = [[UIImageView alloc]init];
    [_codeHeadImage sd_setImageWithURL:[NSURL URLWithString:[SingletonManager sharedManager].userModel.photourl]];
    [_whiteBottomView addSubview:_codeHeadImage];
    [_codeHeadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_whiteBottomView.mas_centerY);
        make.centerX.equalTo(_whiteBottomView.mas_centerX);
        make.height.width.mas_offset(RESIZE_UI(44));
    }];
    
    UIImageView *topHeadImage = [[UIImageView alloc]init];
    [topHeadImage sd_setImageWithURL:[NSURL URLWithString:[SingletonManager sharedManager].userModel.photourl]];
    [_whiteBottomView addSubview:topHeadImage];
    [topHeadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.codeImageView.mas_top).with.offset(-RESIZE_UI(27));
        make.left.equalTo(self.codeImageView.mas_left);
        make.height.width.mas_offset(RESIZE_UI(44));
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = [SingletonManager sharedManager].userModel.name;
    nameLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    [_whiteBottomView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topHeadImage.mas_top);
        make.left.equalTo(topHeadImage.mas_right).with.offset(RESIZE_UI(16));
    }];
    
    UILabel *inviteCodeLabel = [[UILabel alloc]init];
    inviteCodeLabel.text = [NSString stringWithFormat:@"推荐号 :%@",[SingletonManager sharedManager].userModel.invitationcode];
    inviteCodeLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    inviteCodeLabel.textColor = RGBA(153, 153, 153, 1.0);
    [_whiteBottomView addSubview:inviteCodeLabel];
    [inviteCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.bottom.equalTo(topHeadImage.mas_bottom);
    }];
    
    UILabel *tip1Label = [[UILabel alloc]init];
    tip1Label.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    tip1Label.text = @"扫描二维码";
    [_whiteBottomView addSubview:tip1Label];
    [tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_whiteBottomView.mas_centerX);
        make.top.equalTo(_codeImageView.mas_bottom).with.offset(RESIZE_UI(23));
    }];
    
    UILabel *tip2Label = [[UILabel alloc]init];
    tip2Label.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    tip2Label.text = @"下载旺马财富APP";
    [_whiteBottomView addSubview:tip2Label];
    [tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_whiteBottomView.mas_centerX);
        make.top.equalTo(tip1Label.mas_bottom).with.offset(2);
    }];
    
}

#pragma mark - 关闭全部
- (void)closeAll {
    
    [_codeHeadImage removeFromSuperview];
    _codeHeadImage = nil;
    [_codeImageView removeFromSuperview];
    _codeImageView = nil;
    [_whiteBottomView removeFromSuperview];
    _whiteBottomView = nil;
    [_blackBottomView removeGestureRecognizer:_tapGes];
    _tapGes = nil;
    [_blackBottomView removeFromSuperview];
    _blackBottomView = nil;
    
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


#pragma mark - 调到更多界面
- (void)jumpToMoreMethod {
    
    NewMoreViewController *moreVC = [[NewMoreViewController alloc]init];
    [moreVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:moreVC animated:YES];
    
}

#pragma mark - 跳转到个人信息界面
- (void)jumpToPersonalViewMethod {
    PersonalMessageViewController *personalVC = [[PersonalMessageViewController alloc]init];
    [personalVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:personalVC animated:YES];
}

#pragma mark - 跳转到充值界面
- (void)jumpToRechargeMethod {
    if ([[SingletonManager sharedManager].userModel.is_real_name isEqualToString:@"0"]) {
        MMPopupItemHandler block = ^(NSInteger index){
            if (index == 0) {
                return ;
            }
            if (index == 1) {
                /*  实名认证 */
                RealNameCertificationViewController *realNameAuth = [[RealNameCertificationViewController alloc] init];
                [self.navigationController pushViewController:realNameAuth animated:YES];
                return;
            }
        };
        NSArray *items =
        @[MMItemMake(@"取消", MMItemTypeNormal, block),
          MMItemMake(@"确定", MMItemTypeNormal, block)];
        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                             detail:@"你还未认证,请实名认证"
                                                              items:items];
        [alertView show];
    } else if ([[SingletonManager sharedManager].userModel.card_id isEqualToString:@"0"]) {
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
    } else {
        RechargeViewController *rechangeVC = [[RechargeViewController alloc] init];
        [self.navigationController pushViewController:rechangeVC animated:YES];
    }
}

#pragma mark - 跳转到提现界面
- (void)jumpToWithDrawMethod {
    /* 提现 */
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
    }
    /* 当前余额为零不可提现 */
    else if ([_balanceValue floatValue] == 0) {
        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
        alertConfig.defaultTextOK = @"确定";
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"没有可用的余额"];
        [alertView show];
    } else {
        [[MMPopupWindow sharedWindow] cacheWindow];
        DrawalViewController *drawalVC = [[DrawalViewController alloc] init];
        drawalVC.accountStr = _balanceValue;
        [self.navigationController pushViewController:drawalVC animated:YES];
    }
}

/* 消息页面 */
- (void)messageBtnAction {
    MessageWViewController *messageVC = [[MessageWViewController alloc] initWithNibName:@"MessageWViewController" bundle:nil];
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccessMethod) name:@"loginSuccess" object:nil];
    
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = RGBA(237, 240, 242, 1.0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = [self setUpProfileHeadView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(-20);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self setHeadView];
    
    
//    UIScrollView *mainScrollView = [[UIScrollView alloc]init];
//    [self.view addSubview:mainScrollView];
//    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).with.offset(-20);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.bottom.equalTo(self.view.mas_bottom);
//    }];
//    
//    UIView *mainView = [[UIView alloc]init];
//    mainScrollView.backgroundColor = RGBA(231, 234, 236, 1.0);
//    [mainScrollView addSubview:mainView];
//    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(mainScrollView);
//        make.width.mas_equalTo(self.view.mas_width);
//    }];
//    
//    UIView *headView = [self setUpProfileHeadView];
//    [mainView addSubview:headView];
//    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(mainView.mas_top);
//        make.left.equalTo(mainView.mas_left);
//        make.right.equalTo(mainView.mas_right);
//        make.height.mas_equalTo(RESIZE_UI(187+76));
//    }];
//    
//    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
//    self.classCollectionView = collectionView;
//    self.classCollectionView.scrollEnabled = NO;
//    [self.classCollectionView registerNib:[UINib nibWithNibName:@"PersonalCategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PersonalCategoryCollectionViewCell"];
//    [self.classCollectionView registerClass:[StoreClassCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StoreClassCollectionReusableView"];
//    self.classCollectionView.delegate = self;
//    self.classCollectionView.dataSource = self;
//    self.classCollectionView.backgroundColor = RGBA(231, 234, 236, 1.0);
////    self.classCollectionView.backgroundColor = [UIColor whiteColor];
//    self.classCollectionView.showsVerticalScrollIndicator = NO;
//    self.classCollectionView.showsHorizontalScrollIndicator = NO;
//    [mainView addSubview:self.classCollectionView];
//    [self.classCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(headView.mas_bottom).with.offset(0);
//            make.left.equalTo(mainView.mas_left);
//            make.right.equalTo(mainView.mas_right);
////            make.bottom.equalTo(mainView.mas_bottom);
//            make.height.mas_equalTo(RESIZE_UI(80)*4+RESIZE_UI(24));
//    }];
//    
//    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.classCollectionView.mas_bottom);
//    }];
}

- (void)loginSuccessMethod {
    [_imageViewForHead sd_setImageWithURL:[NSURL URLWithString:[SingletonManager sharedManager].userModel.photourl]];
    _labelForName.text = [SingletonManager sharedManager].userModel.name;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ProfileViewController"];
    
    self.tabBarController.tabBar.hidden = NO;
    
    if ([[SingletonManager sharedManager].uid isEqualToString:@""]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.loginIden = @"login";
        loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController *loginNa = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNa animated:YES completion:nil];
        return;
    }
//    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //获取当前余额
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"User/queryBalance" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"account_type":@"SAVING_POT"} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _balanceValue = [obj[@"data"] objectForKey:@"available_balance"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }
    }];
    //每次进入这个界面更新一下头像和昵称
    if (_imageViewForHead) {
        [_imageViewForHead sd_setImageWithURL:[NSURL URLWithString:[SingletonManager sharedManager].userModel.photourl]];
    }
    if (_labelForName) {
        _labelForName.text = [SingletonManager sharedManager].userModel.name;
    }
    
    NSString *ballNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"redBallNumber"];
    NSInteger redBall = [ballNumber integerValue];
    if (redBall == 0) {
        _numberLabel.hidden = YES;
    } else {
        _numberLabel.hidden = NO;
    }
    
    [self getRedBallMethod];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
    
    [[[AppDelegate sharedInstance] redView] removeFromSuperview];
    [AppDelegate sharedInstance].redView = nil;
    [MobClick endLogPageView:@"ProfileViewController"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - 获取红包信息
- (void)getRedBallMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Redpacket/my" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid,@"status":@"2",@"is_new":@"2"} withBlock:^(id obj) {
        _redPackageArray = [[NSMutableArray alloc]init];
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSArray *dataArray = obj[@"data"];
                _redPackageArray = [[NSMutableArray alloc]init];
                for (int i=0; i<dataArray.count; i++) {
                    NSDictionary *dict = dataArray[i];
                    RedPackageModel *redPackageModel = [RedPackageModel mj_objectWithKeyValues:dict];
                    [_redPackageArray addObject:redPackageModel];
                }
                [self.tableView reloadData];
                if (_redPackageArray.count>0) {
                    [[AppDelegate sharedInstance] redView];
                } else {
                    [[[AppDelegate sharedInstance] redView] removeFromSuperview];
                    [AppDelegate sharedInstance].redView = nil;
                }
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


#pragma mark - UITableView dataSource delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return RESIZE_UI(12);
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return RESIZE_UI(60);
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UIView *viewForHeader = [[UIView alloc]init];
//    viewForHeader.backgroundColor = RGBA(237, 240, 242, 1.0);
//    if (section == 1) {
//        UILabel *labelForLine = [[UILabel alloc]init];
//        labelForLine.backgroundColor = RGBA(255, 82, 37, 1.0);
//        [viewForHeader addSubview:labelForLine];
//        [labelForLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(viewForHeader.mas_centerY);
//            make.left.equalTo(viewForHeader.mas_left);
//            make.height.mas_offset(17);
//            make.width.mas_offset(5);
//        }];
//        
//        UILabel *labelForTitle = [[UILabel alloc]init];
//        labelForTitle.text = @"新浪账户中心";
//        labelForTitle.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
//        labelForTitle.textColor = RGBA(153, 153, 153, 1.0);
//        [viewForHeader addSubview:labelForTitle];
//        [labelForTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(viewForHeader.mas_centerY);
//            make.left.equalTo(viewForHeader.mas_left).with.offset(13);
//        }];
//    }
//    return viewForHeader;
//    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier  = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
        switch (indexPath.row) {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"icon_licai"];
                cell.textLabel.text = @"我的理财";
                break;
            case 1:{
                cell.imageView.image = [UIImage imageNamed:@"icon_wdhb"];
                cell.textLabel.text = @"我的红包";
                NSInteger redBall = _redPackageArray.count;
                if (redBall == 0) {
                    [_numberLabel removeFromSuperview];
                    _numberLabel = nil;
                } else {
                    _numberLabel = [[UILabel alloc]init];
                    _numberLabel.text = [NSString stringWithFormat:@"%ld",redBall];
                    _numberLabel.textColor = [UIColor whiteColor];
                    _numberLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
                    _numberLabel.textAlignment = NSTextAlignmentCenter;
                    _numberLabel.backgroundColor = RGBA(255, 60, 8, 1.0);
                    _numberLabel.layer.masksToBounds = YES;
                    _numberLabel.layer.cornerRadius = RESIZE_UI(10);
                    [cell addSubview:_numberLabel];
                    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(cell.mas_right).with.offset(-RESIZE_UI(38));
                        make.centerY.equalTo(cell.mas_centerY);
                        make.width.height.mas_offset(RESIZE_UI(20));
                    }];
                }
            }
                break;
            case 2:{
                cell.imageView.image = [UIImage imageNamed:@"icon_jfsc"];
                cell.textLabel.text = @"积分商城";
                _integraLabel = [[UILabel alloc]init];
                _integraLabel.text = [NSString stringWithFormat:@"%@积分",[SingletonManager sharedManager].userModel.score];
                _integraLabel.textColor = RGBA(255, 88, 26, 1.0);
                _integraLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
                [cell addSubview:_integraLabel];
                [_integraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.mas_right).with.offset(-RESIZE_UI(38));
                    make.centerY.equalTo(cell.mas_centerY);
                }];
            }
                break;
            case 3:
                cell.imageView.image = [UIImage imageNamed:@"icon_haoyou"];
                cell.textLabel.text = @"好友推荐";
                break;
            case 4:
                cell.imageView.image = [UIImage imageNamed:@"icon_yhk"];
                cell.textLabel.text = @"我的银行卡";
                break;
            case 5:
                cell.imageView.image = [UIImage imageNamed:@"icon_zhmm"];
                cell.textLabel.text = @"账号和密码";
                break;
            case 6:
                cell.imageView.image = [UIImage imageNamed:@"icon_jyjl"];
                cell.textLabel.text = @"交易记录";
                break;
            case 7:
            {
                cell.imageView.image = [UIImage imageNamed:@"icon_lxkf"];
                cell.textLabel.text = @"联系客服";
                cell.accessoryType = UITableViewCellAccessoryNone;
                UILabel *labelForPhone = [[UILabel alloc]init];
                labelForPhone.text = [SingletonManager sharedManager].companyTel;
                labelForPhone.textColor = RGBA(255, 88, 26, 1.0);
                labelForPhone.font = [UIFont systemFontOfSize:15];
                [cell addSubview:labelForPhone];
                [labelForPhone mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.mas_right).with.offset(-12);
                    make.centerY.equalTo(cell.mas_centerY);
                }];
            }
            default:
                break;
        }
    cell.textLabel.textColor = TITLE_COLOR;

    cell.textLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:{
            /* 我的理财 */
            MyselfManageFinanceController *myselfMFVC = [[MyselfManageFinanceController alloc] init];
            [self.navigationController pushViewController:myselfMFVC animated:YES];
            break;
        }
        case 1:{
            /* 我的红包 */
            MyRedPackageViewController *myRedVC = [[MyRedPackageViewController alloc] init];
            [self.navigationController pushViewController:myRedVC animated:YES];
            break;
        }
        case 2: {
            /* 积分商城 */
            IntegralShopViewController *integralShopVC = [[IntegralShopViewController alloc]init];
            [self.navigationController pushViewController:integralShopVC animated:YES];
            break;
        }
        case 3: {
            /* 我的推荐 */
            MyRecommendatViewController *myrecommendVC = [[MyRecommendatViewController alloc]init];
            [self.navigationController pushViewController:myrecommendVC animated:YES];
            break;
        }
        case 4: {
            /* 我的银行卡 */
            if ([[SingletonManager sharedManager].userModel.card_id isEqualToString:@"0"]) {
                /*  我的银行卡 */
                UIStoryboard *addbank = [UIStoryboard storyboardWithName:@"AddBankViewController" bundle:[NSBundle mainBundle]];
                AddBankViewController *addBankVC = [addbank instantiateViewControllerWithIdentifier:@"AddBank"];
                addBankVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:addBankVC animated:YES];
            } else {
                MyselfBankViewController *myselfBankVC = [[MyselfBankViewController alloc] init];
                myselfBankVC.card_id = [SingletonManager sharedManager].userModel.card_id;
                [self.navigationController pushViewController:myselfBankVC animated:YES];
            }
            break;
        }
        case 5: {
            /* 账号和密码 */
            AccountAndPasswordViewController *accountAndPassVC = [[AccountAndPasswordViewController alloc]init];
            [self.navigationController pushViewController:accountAndPassVC animated:YES];
            break;
        }
        case 6: {
            /** 交易记录*/
            MyselfTransactionController *mySelfTrans = [[MyselfTransactionController alloc]init];
            [self.navigationController pushViewController:mySelfTrans animated:YES];
            break;
        }
        case 7:{
            //联系客服
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[SingletonManager sharedManager].companyTel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
            
        default:
            break;
    }

}

//#pragma mark - collectionview - delegate
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    
//    return 2;
//    
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    
//    if (section == 0) {
//        return 4;
//    } else {
//        return 4;
//    }
//    
//}
//
////Header 方法
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(self.classCollectionView.frame.size.width, RESIZE_UI(12));
//}
//
////Header布局
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
//        StoreClassCollectionReusableView *headerView = (StoreClassCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StoreClassCollectionReusableView" forIndexPath:indexPath];
//        return headerView;
//    }
//    return nil;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *CellIdentifier = @"PersonalCategoryCollectionViewCell";
//    PersonalCategoryCollectionViewCell *cell = (PersonalCategoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    if (indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 0:
//                cell.headImageView.image = [UIImage imageNamed:@"icon_licai"];
//                cell.titleLabel.text = @"我的理财";
//                break;
//            case 1:
//                cell.headImageView.image = [UIImage imageNamed:@"icon_haoyou"];
//                cell.titleLabel.text = @"好友推荐";
//                break;
//            case 2:
//                cell.headImageView.image = [UIImage imageNamed:@"icon_yhk"];
//                cell.titleLabel.text = @"我的银行卡";
//                break;
//            case 3:
//                cell.headImageView.image = [UIImage imageNamed:@"icon_jiaoyi"];
//                cell.titleLabel.text = @"交易记录";
//                break;
//                
//            default:
//                break;
//        }
//    } else {
//        switch (indexPath.row) {
//            case 0:
//                cell.headImageView.image = [UIImage imageNamed:@"icon_zhanghu"];
//                cell.titleLabel.text = @"账户管理";
//                break;
//            case 1:
//                cell.headImageView.image = [UIImage imageNamed:@"icon_anquan"];
//                cell.titleLabel.text = @"安全中心";
//                break;
//            case 2:
//                cell.headImageView.image = [UIImage imageNamed:@"icon_wdsq"];
//                cell.titleLabel.text = @"我的授权";
//                break;
//                
//            default:
//                break;
//        }
//    }
//    return cell;
//    
//}
//
//#pragma mark --UICollectionViewDelegateFlowLayout
////定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    float width = (collectionView.frame.size.width-1)/2;
//    if (indexPath.section == 1) {
//        if (indexPath.row>2) {
//            width = collectionView.frame.size.width/2;
//        }
//    }
//    return CGSizeMake(width , RESIZE_UI(80));
//}
//
////定义每个UICollectionView 的 margin
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0,0,0,0);
//}
//
//// 定义上下cell的最小间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 1.0f;
//}
//
//// 定义cell间的最小间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 0.0f;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 0:{
//                /* 我的理财 */
//                MyselfManageFinanceController *myselfMFVC = [[MyselfManageFinanceController alloc] init];
//                [self.navigationController pushViewController:myselfMFVC animated:YES];
//                break;
//            }
//            case 1: {
//                /* 我的推荐 */
//                MyRecommendatViewController *myrecommendVC = [[MyRecommendatViewController alloc]init];
//                [self.navigationController pushViewController:myrecommendVC animated:YES];
//                break;
//            }
//            case 2: {
//                /* 我的银行卡 */
//                if ([[SingletonManager sharedManager].userModel.card_id isEqualToString:@"0"]) {
//                    /*  我的银行卡 */
//                    UIStoryboard *addbank = [UIStoryboard storyboardWithName:@"AddBankViewController" bundle:[NSBundle mainBundle]];
//                    AddBankViewController *addBankVC = [addbank instantiateViewControllerWithIdentifier:@"AddBank"];
//                    addBankVC.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:addBankVC animated:YES];
//                } else {
//                    MyselfBankViewController *myselfBankVC = [[MyselfBankViewController alloc] init];
//                    myselfBankVC.card_id = [SingletonManager sharedManager].userModel.card_id;
//                    [self.navigationController pushViewController:myselfBankVC animated:YES];
//                }
//                break;
//            }
//            case 3: {
//                /** 交易记录*/
//                MyselfTransactionController *mySelfTrans = [[MyselfTransactionController alloc]init];
//                [self.navigationController pushViewController:mySelfTrans animated:YES];
//                break;
//            }
//            default:
//                break;
//        }
//    } else {
//        switch (indexPath.row) {
//            case 0:{
//                //账户管理
//                [self jumpToXinLangMethod:@"DEFAULT" andTitle:@"账户管理"];
//            }
//                break;
//            case 1:{
//                //安全中心
//                [self jumpToXinLangMethod:@"SAFETY_CENTER" andTitle:@"安全中心"];
//            }
//                break;
//            case 2:{
//                //我的授权
//                [self jumpToXinLangMethod:@"WITHHOLD" andTitle:@"我的授权"];
//            }
//                break;
//                
//            default:
//                break;
//        }
//    }
//}
//
////返回这个UICollectionView是否可以被选择
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//

- (void)setHeadView {
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = RGBA(0, 104, 178, 1.0);
//    topView.backgroundColor = [UIColor redColor];
    topView.alpha = 1.0;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(64);
    }];
    
    UIImageView *imageViewForLeft = [[UIImageView alloc]init];
    imageViewForLeft.image = [UIImage imageNamed:@"icon_more"];
    [topView addSubview:imageViewForLeft];
    [imageViewForLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).with.offset(RESIZE_UI(34));
        make.left.equalTo(topView.mas_left).with.offset(RESIZE_UI(15));
        make.height.mas_offset(RESIZE_UI(16));
        make.width.mas_offset(RESIZE_UI(6));
    }];
    
    UILabel *lableForMore = [[UILabel alloc] init];
    lableForMore.text = @"更多";
    lableForMore.textAlignment = NSTextAlignmentLeft;
    lableForMore.textColor = [UIColor whiteColor];
    lableForMore.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [topView addSubview:lableForMore];
    [lableForMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).with.offset(RESIZE_UI(34));
        make.left.equalTo(topView.mas_left).with.offset(RESIZE_UI(34));
        make.height.mas_offset(RESIZE_UI(16));
    }];
    
    UIButton *buttonForMore = [[UIButton alloc]init];
    buttonForMore.backgroundColor = [UIColor clearColor];
    [buttonForMore addTarget:self action:@selector(jumpToMoreMethod) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:buttonForMore];
    [buttonForMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageViewForLeft.mas_top).with.offset(-20);
        make.bottom.equalTo(imageViewForLeft.mas_bottom).with.offset(20);
        make.left.equalTo(topView.mas_left);
        make.right.equalTo(lableForMore.mas_right).with.offset(20);
    }];
    
    /*  消息  */
    UIButton *buttonForMessCenter = [[UIButton alloc]init];
    //    [buttonForMessCenter setBackgroundImage:[UIImage imageNamed:@"notific"] forState:UIControlStateNormal];
    [buttonForMessCenter setImage:[UIImage imageNamed:@"icon_xx"] forState:UIControlStateNormal];
    [buttonForMessCenter addTarget:self action:@selector(messageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:buttonForMessCenter];
    [buttonForMessCenter mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(topView.mas_top).with.offset(RESIZE_UI(33));
        make.centerY.equalTo(lableForMore.mas_centerY);
        make.right.equalTo(topView.mas_right).with.offset(RESIZE_UI(-15));
        make.height.mas_offset(RESIZE_UI(30));
        make.width.mas_offset(RESIZE_UI(30));
    }];
    
    //二维码
    UIButton *codeButton = [[UIButton alloc]init];
    [codeButton setBackgroundImage:[UIImage imageNamed:@"icon_ewm"] forState:UIControlStateNormal];
    [codeButton addTarget:self action:@selector(watchCodeMethod) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:codeButton];
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(buttonForMessCenter.mas_centerY);
        make.width.height.mas_offset(RESIZE_UI(30));
        make.right.equalTo(buttonForMessCenter.mas_left).with.offset(RESIZE_UI(-15));
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
