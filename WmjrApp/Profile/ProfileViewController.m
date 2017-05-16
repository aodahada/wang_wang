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
#import "AgViewController.h"
#import "BaseNavigationController.h"
#import "MyselfTransactionController.h"
#import "PersonalCategoryCollectionViewCell.h"


@interface ProfileViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    UITableView *_tableView;
}
@property (nonatomic, copy) NSString *balanceValue;

@property (nonatomic, strong) UIImageView *imageViewForHead;

@property (nonatomic, strong) UILabel *labelForName;

@property (nonatomic, weak) UICollectionView *classCollectionView;

@end

@implementation ProfileViewController

//头视图
- (UIView *)setUpProfileHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,RESIZE_UI(187+49))];
    headView.backgroundColor = RGBA(220, 223, 225, 1.0);
    UIImageView *imageViewForBackground = [[UIImageView alloc]init];
    imageViewForBackground.image = [UIImage imageNamed:@"image_me_bg"];
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
    [buttonForMessCenter setBackgroundImage:[UIImage imageNamed:@"notific"] forState:UIControlStateNormal];
    [buttonForMessCenter addTarget:self action:@selector(messageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:buttonForMessCenter];
    [buttonForMessCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).with.offset(RESIZE_UI(33));
        make.right.equalTo(headView.mas_right).with.offset(RESIZE_UI(-15));
        make.height.mas_offset(RESIZE_UI(19));
        make.width.mas_offset(RESIZE_UI(15));
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
    viewBottomForRecharge.backgroundColor = [UIColor clearColor];
    [viewForRecharge addSubview:viewBottomForRecharge];
    [viewBottomForRecharge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewForRecharge.mas_centerX);
        make.height.mas_offset(RESIZE_UI(27));
        make.width.mas_offset(RESIZE_UI(105));
        make.centerY.equalTo(viewForRecharge.mas_centerY);
    }];
    
//    UIImageView *rechargeImageView = [[UIImageView alloc]init];
//    rechargeImageView.image = [UIImage imageNamed:@"icon_chzh"];
//    [viewBottomForRecharge addSubview:rechargeImageView];
//    [rechargeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(viewBottomForRecharge.mas_left);
//        make.centerY.equalTo(viewForRecharge.mas_centerY);
//        make.height.width.mas_offset(RESIZE_UI(27));
//    }];
    
    UILabel *rechargeLabel = [[UILabel alloc]init];
    rechargeLabel.text = @"我要充值";
    rechargeLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    rechargeLabel.textColor = RGBA(20, 20, 23, 1.0);
    [viewBottomForRecharge addSubview:rechargeLabel];
    [rechargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(viewBottomForRecharge.mas_right);
        make.centerX.equalTo(viewForRecharge.mas_centerX);
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
    viewBottomForWithdraw.backgroundColor = [UIColor clearColor];
    [viewForWithdraw addSubview:viewBottomForWithdraw];
    [viewBottomForWithdraw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewForWithdraw.mas_centerX);
        make.height.mas_offset(RESIZE_UI(27));
        make.width.mas_offset(RESIZE_UI(105));
        make.centerY.equalTo(viewForWithdraw.mas_centerY);
    }];
    
    UILabel *withDrawLabel = [[UILabel alloc]init];
    withDrawLabel.text = @"我要提现";
    withDrawLabel.textColor = RGBA(20, 20, 23, 1.0);
    withDrawLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    [viewBottomForWithdraw addSubview:withDrawLabel];
    [withDrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewBottomForWithdraw.mas_centerY);
        make.centerX.equalTo(viewBottomForWithdraw.mas_centerX);
//        make.right.equalTo(viewBottomForWithdraw.mas_right);
        make.height.mas_offset(RESIZE_UI(24));
    }];
    
//    UIImageView *withDrawImageView = [[UIImageView alloc]init];
//    withDrawImageView.image = [UIImage imageNamed:@"icon_tixian"];
//    [viewBottomForWithdraw addSubview:withDrawImageView];
//    [withDrawImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(viewBottomForWithdraw.mas_left);
//        make.centerY.equalTo(viewBottomForWithdraw.mas_centerY);
//        make.width.height.mas_offset(RESIZE_UI(24));
//    }];
    
    UIButton *withDrawButton = [[UIButton alloc]init];
    [withDrawButton addTarget:self action:@selector(jumpToWithDrawMethod) forControlEvents:UIControlEventTouchUpInside];
    [viewForWithdraw addSubview:withDrawButton];
    [withDrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewForWithdraw);
    }];
    
    return headView;
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
    
//    _tableView = [[UITableView alloc] init];
//    _tableView.backgroundColor = RGBA(237, 240, 242, 1.0);
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    _tableView.bounces = NO;
//    _tableView.showsVerticalScrollIndicator = NO;
//    _tableView.tableFooterView = [[UIView alloc]init];
//    [self.view addSubview:_tableView];
//    _tableView.tableHeaderView = [self setUpProfileHeadView];
//    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).with.offset(-20);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.bottom.equalTo(self.view.mas_bottom);
//    }];
    UIScrollView *mainScrollView = [[UIScrollView alloc]init];
    [self.view addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(-20);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    UIView *mainView = [[UIView alloc]init];
    mainScrollView.backgroundColor = RGBA(231, 234, 236, 1.0);
    [mainScrollView addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    UIView *headView = [self setUpProfileHeadView];
    [mainView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView.mas_top);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_equalTo(RESIZE_UI(187+49));
    }];
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    self.classCollectionView = collectionView;
    self.classCollectionView.scrollEnabled = NO;
    [self.classCollectionView registerNib:[UINib nibWithNibName:@"PersonalCategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PersonalCategoryCollectionViewCell"];
    self.classCollectionView.delegate = self;
    self.classCollectionView.dataSource = self;
    self.classCollectionView.backgroundColor = RGBA(231, 234, 236, 1.0);
    self.classCollectionView.showsVerticalScrollIndicator = NO;
    self.classCollectionView.showsHorizontalScrollIndicator = NO;
    [mainView addSubview:self.classCollectionView];
    [self.classCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headView.mas_bottom).with.offset(RESIZE_UI(13));
            make.left.equalTo(mainView.mas_left);
            make.right.equalTo(mainView.mas_right);
//            make.bottom.equalTo(mainView.mas_bottom);
            make.height.mas_equalTo(RESIZE_UI(80)*4);
    }];
    
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.classCollectionView.mas_bottom);
    }];
}

- (void)loginSuccessMethod {
    [_imageViewForHead sd_setImageWithURL:[NSURL URLWithString:[SingletonManager sharedManager].userModel.photourl]];
    _labelForName.text = [SingletonManager sharedManager].userModel.name;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//#pragma mark - UITableView dataSource delegate -
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 5;
//    } else {
//        return 3;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 12;
//    } else {
//        return 27;
//    }
//}
//
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
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *identifier  = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
//    }
//    if (indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 0:
//                cell.imageView.image = [UIImage imageNamed:@"icon_licai"];
//                cell.textLabel.text = @"我的理财";
//                break;
//            case 1:
//                cell.imageView.image = [UIImage imageNamed:@"icon_haoyou"];
//                cell.textLabel.text = @"好友推荐";
//                break;
//            case 2:
//                cell.imageView.image = [UIImage imageNamed:@"icon_yhk"];
//                cell.textLabel.text = @"我的银行卡";
//                break;
//            case 3:
//                cell.imageView.image = [UIImage imageNamed:@"icon_jifen"];
//                cell.textLabel.text = @"我的积分";
//                break;
//            case 4:
//                cell.imageView.image = [UIImage imageNamed:@"icon_jiaoyi"];
//                cell.textLabel.text = @"交易记录";
//                break;
//            default:
//                break;
//        }
//    } else {
//        switch (indexPath.row) {
//            case 0:
//                cell.imageView.image = [UIImage imageNamed:@"icon_zhanghu"];
//                cell.textLabel.text = @"账户管理";
//                break;
//            case 1:
//                cell.imageView.image = [UIImage imageNamed:@"icon_anquan"];
//                cell.textLabel.text = @"安全中心";
//                break;
//            case 2:
//                cell.imageView.image = [UIImage imageNamed:@"icon_shouquan"];
//                cell.textLabel.text = @"我的授权";
//                break;
//                
//            default:
//                break;
//        }
//    }
//    cell.textLabel.textColor = TITLE_COLOR;
//
//    cell.textLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
//                MyRecommendatViewController *myrecommendVC = [[MyRecommendatViewController alloc]initWithNibName:@"MyRecommendatViewController" bundle:nil];
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
//                /* 我的积分 */
//                [[[UIAlertView alloc]initWithTitle:@"该功能正在开发中" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil]show];
//                break;
//            }
//            case 4: {
//                /** 交易记录*/
//                MyselfTransactionController *mySelfTrans = [[MyselfTransactionController alloc]init];
//                [self.navigationController pushViewController:mySelfTrans animated:YES];
//                break;
//            }
//                
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
//
//}

#pragma mark - collectionview - delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 8;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PersonalCategoryCollectionViewCell";
    PersonalCategoryCollectionViewCell *cell = (PersonalCategoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.headImageView.image = [UIImage imageNamed:@"icon_licai"];
            cell.titleLabel.text = @"我的理财";
            break;
        case 1:
            cell.headImageView.image = [UIImage imageNamed:@"icon_haoyou"];
            cell.titleLabel.text = @"好友推荐";
            break;
        case 2:
            cell.headImageView.image = [UIImage imageNamed:@"icon_yhk"];
            cell.titleLabel.text = @"我的银行卡";
            break;
        case 3:
            cell.headImageView.image = [UIImage imageNamed:@"icon_jiaoyi"];
            cell.titleLabel.text = @"交易记录";
            break;
        case 4:
            cell.headImageView.image = [UIImage imageNamed:@"icon_jifen"];
            cell.titleLabel.text = @"我的积分";
            break;
        case 5:
            cell.headImageView.image = [UIImage imageNamed:@"icon_zhanghu"];
            cell.titleLabel.text = @"账户管理";
            break;
        case 6:
            cell.headImageView.image = [UIImage imageNamed:@"icon_anquan"];
            cell.titleLabel.text = @"安全中心";
            break;
        case 7:
            cell.headImageView.image = [UIImage imageNamed:@"icon_wdsq"];
            cell.titleLabel.text = @"我的授权";
            break;

        default:
            break;
    }
    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = (collectionView.frame.size.width-1)/2;
    return CGSizeMake(width , RESIZE_UI(80));
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0f;
}

// 定义cell间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:{
            /* 我的理财 */
            MyselfManageFinanceController *myselfMFVC = [[MyselfManageFinanceController alloc] init];
            [self.navigationController pushViewController:myselfMFVC animated:YES];
            break;
        }
        case 1: {
            /* 我的推荐 */
            MyRecommendatViewController *myrecommendVC = [[MyRecommendatViewController alloc]initWithNibName:@"MyRecommendatViewController" bundle:nil];
            [self.navigationController pushViewController:myrecommendVC animated:YES];
            break;
        }
        case 2: {
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
        case 3: {
            /** 交易记录*/
            MyselfTransactionController *mySelfTrans = [[MyselfTransactionController alloc]init];
            [self.navigationController pushViewController:mySelfTrans animated:YES];
            break;
        }
        case 4: {
            /* 我的积分 */
            [[[UIAlertView alloc]initWithTitle:@"该功能正在开发中" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil]show];
            break;
        }
        case 5:{
            //账户管理
            [self jumpToXinLangMethod:@"DEFAULT" andTitle:@"账户管理"];
        }
            break;
        case 6:{
            //安全中心
            [self jumpToXinLangMethod:@"SAFETY_CENTER" andTitle:@"安全中心"];
        }
            break;
        case 7:{
            //我的授权
            [self jumpToXinLangMethod:@"WITHHOLD" andTitle:@"我的授权"];
        }
            break;
            
        default:
            break;
    }
    
}

//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (void)jumpToXinLangMethod:(NSString *)default_page andTitle:(NSString *)title{
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"请稍后"];
    [manager postDataWithUrlActionStr:@"Sina/index" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"default_page":default_page} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSDictionary *dic = obj[@"data"];
            AgViewController *agVC =[[AgViewController alloc] init];
            agVC.title = title;
            agVC.webUrl = dic[@"redirect_url"];
            BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
            [SVProgressHUD dismiss];
            [self presentViewController:baseNa animated:YES completion:^{
            }];
        }else {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
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
