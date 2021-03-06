//
//  IntegralShopViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/14.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "IntegralShopViewController.h"
#import "StoreClassCollectionReusableView.h"
#import "IntegralProductCollectionViewCell.h"
#import "IntegralProductDetailViewController.h"
#import "IntegralProductModel.h"
#import "ExchangeRecordViewController.h"
#import "ScordRecordViewController.h"
#import "AgViewController.h"
#import "LoginViewController.h"

@interface IntegralShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *classCollectionView;
@property (nonatomic, strong) UIScrollView *scrollViewForCollect;
@property (nonatomic, strong) UIView *viewForScroll;
@property (nonatomic, strong) NSMutableArray *trueProductListArray;//实物array
@property (nonatomic, strong) NSMutableArray *falseProductListArray;//非实物array

@property (nonatomic, strong) UILabel *tip2Label;//剩余积分
@property (nonatomic, strong) UILabel *intergralNumber;//总积分

@end

@implementation IntegralShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"积分商城";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIImage *imageHelp = [[UIImage imageNamed:@"icon_guize"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:imageHelp style:UIBarButtonItemStylePlain target:self action:@selector(watchRuleMethod)];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"积分说明" style:UIBarButtonItemStyleDone target:self action:@selector(watchRuleMethod)];
//    [rightBarButton setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [rightBarButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:RESIZE_UI(15)], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"积分说明" style:UIBarButtonItemStyleDone target:self action:@selector(watchRuleMethod)];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self getDataWithLogin];
    [MobClick beginLogPageView:@"IntegralShopViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"IntegralShopViewController"];
    
}

- (void)watchRuleMethod {
    AgViewController *agVC =[[AgViewController alloc] init];
    agVC.title = @"积分规则";
    agVC.webUrl = @"http://api.wmjr888.com/home/page/app/id/15";
    [self.navigationController pushViewController:agVC animated:YES];
}

- (void)setUpViewSign {
    _scrollViewForCollect = [[UIScrollView alloc]init];
    _scrollViewForCollect.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollViewForCollect];
    [_scrollViewForCollect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _viewForScroll = [[UIView alloc]init];
    _viewForScroll.backgroundColor = RGBA(238, 240, 242, 1.0);
    [_scrollViewForCollect addSubview:_viewForScroll];
    [_viewForScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollViewForCollect);
        make.width.equalTo(self.view.mas_width);
        //        make.bottom.equalTo(self.classCollectionView.mas_bottom);
        //        make.height.mas_offset(2000);
    }];
    
    UIView *topView1 = [[UIView alloc]init];
    topView1.backgroundColor = [UIColor whiteColor];
    [_viewForScroll addSubview:topView1];
    [topView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewForScroll.mas_top);
        make.left.equalTo(_viewForScroll.mas_left);
        make.right.equalTo(_viewForScroll.mas_right);
        make.height.mas_offset(RESIZE_UI(74));
    }];
    
    //头像
    UIImageView *headImage = [[UIImageView alloc]init];
    [headImage sd_setImageWithURL:[NSURL URLWithString:[SingletonManager sharedManager].userModel.photourl] placeholderImage:[UIImage imageNamed:@"image_head"]];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = RESIZE_UI(37)/2;
    [topView1 addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView1.mas_centerY);
        make.left.equalTo(topView1.mas_left).with.offset(RESIZE_UI(15));
        make.width.height.mas_offset(RESIZE_UI(37));
    }];
    
    //昵称
    UILabel *nickLabel = [[UILabel alloc]init];
    nickLabel.text = [SingletonManager sharedManager].userModel.name;
    nickLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [topView1 addSubview:nickLabel];
    [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImage.mas_top);
        make.left.equalTo(headImage.mas_right).with.offset(RESIZE_UI(15));
    }];
    
    UILabel *tip1Label = [[UILabel alloc]init];
    tip1Label.text = @"您有";
    tip1Label.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    tip1Label.textColor = RGBA(153, 153, 153, 1.0);
    [topView1 addSubview:tip1Label];
    [tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickLabel.mas_left);
        make.bottom.equalTo(headImage.mas_bottom);
    }];
    
    _tip2Label = [[UILabel alloc]init];
    _tip2Label.text = [SingletonManager sharedManager].userModel.score_clear;
    _tip2Label.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    _tip2Label.textColor = RGBA(252, 64, 22, 1.0);
    [topView1 addSubview:_tip2Label];
    [_tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tip1Label.mas_right);
        make.bottom.equalTo(tip1Label.mas_bottom);
    }];
    
    UILabel *tip3Label = [[UILabel alloc]init];
    tip3Label.text = @"个积分即将在年底清空";
    tip3Label.textColor = RGBA(153, 153, 153, 1.0);
    tip3Label.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    [topView1 addSubview:tip3Label];
    [tip3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tip2Label.mas_right);
        make.bottom.equalTo(tip1Label.mas_bottom);
    }];
    
    UILabel *intergralTitle = [[UILabel alloc]init];
    intergralTitle.text = @"积分";
    intergralTitle.textColor = RGBA(153, 153, 153, 1.0);
    intergralTitle.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    [topView1 addSubview:intergralTitle];
    [intergralTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView1.mas_centerY);
        make.right.equalTo(topView1.mas_right).with.offset(-RESIZE_UI(15));
    }];
    
    _intergralNumber = [[UILabel alloc]init];
    _intergralNumber.text = [SingletonManager sharedManager].userModel.score;
    _intergralNumber.textColor = RGBA(255, 88, 26, 1.0);
//    intergralNumber.font = [UIFont systemFontOfSize:RESIZE_UI(22)];
    _intergralNumber.font = [UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(22)];
    [topView1 addSubview:_intergralNumber];
    [_intergralNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView1.mas_centerY);
        make.right.equalTo(intergralTitle.mas_left).with.offset(-RESIZE_UI(7));
    }];
    
    UIView *top2LeftView = [[UIView alloc]init];
    top2LeftView.backgroundColor = [UIColor whiteColor];
    [_viewForScroll addSubview:top2LeftView];
    [top2LeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView1.mas_bottom).with.offset(1);
        make.left.mas_equalTo(_viewForScroll.mas_left);
        make.height.mas_offset(RESIZE_UI(74));
        make.width.mas_offset((SCREEN_WIDTH/2)-0.5);
    }];
    
    UILabel *integralRecordLabel = [[UILabel alloc]init];
    integralRecordLabel.text = @"积分记录";
    integralRecordLabel.textColor = RGBA(20, 20, 23, 1.0);
    integralRecordLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(14)];
    [top2LeftView addSubview:integralRecordLabel];
    [integralRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(top2LeftView.mas_top).with.offset(RESIZE_UI(19));
        make.right.equalTo(top2LeftView.mas_right).with.offset(-RESIZE_UI(29));
    }];
    
    UIImageView *leftImageView = [[UIImageView alloc]init];
    leftImageView.image = [UIImage imageNamed:@"Group 3"];
    [top2LeftView addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(integralRecordLabel.mas_top).with.offset(-RESIZE_UI(6));
        make.right.equalTo(integralRecordLabel.mas_left).with.offset(-RESIZE_UI(5));
        make.width.mas_offset(RESIZE_UI(91));
        make.height.mas_offset(RESIZE_UI(42));
    }];
    
    UILabel *watchIntegralLabel = [[UILabel alloc]init];
    watchIntegralLabel.text = @"看看积分的来源";
    watchIntegralLabel.textColor = RGBA(153, 153, 153, 1.0);
    watchIntegralLabel.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
    [top2LeftView addSubview:watchIntegralLabel];
    [watchIntegralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(integralRecordLabel.mas_bottom).with.offset(RESIZE_UI(4));
        make.left.mas_equalTo(integralRecordLabel.mas_left);
    }];
    
    UIButton *watchScoreRecordButton = [[UIButton alloc]init];
    [watchScoreRecordButton setBackgroundColor:[UIColor clearColor]];
    [watchScoreRecordButton addTarget:self action:@selector(watchScoreRecordMethod) forControlEvents:UIControlEventTouchUpInside];
    [top2LeftView addSubview:watchScoreRecordButton];
    [watchScoreRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(top2LeftView);
    }];
    
    UIView *top2RightView = [[UIView alloc]init];
    top2RightView.backgroundColor = [UIColor whiteColor];
    [_viewForScroll addSubview:top2RightView];
    [top2RightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(top2LeftView.mas_top);
        make.right.equalTo(_viewForScroll.mas_right);
        make.height.mas_equalTo(top2LeftView.mas_height);
        make.width.mas_offset((SCREEN_WIDTH/2)-0.5);
    }];
    
    UILabel *exchangeRecordLabel = [[UILabel alloc]init];
    exchangeRecordLabel.text = @"兑换记录";
    exchangeRecordLabel.textColor = RGBA(20, 20, 23, 1.0);
    exchangeRecordLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(14)];
    [top2RightView addSubview:exchangeRecordLabel];
    [exchangeRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(top2RightView.mas_top).with.offset(RESIZE_UI(19));
        make.right.equalTo(top2RightView.mas_right).with.offset(-RESIZE_UI(29));
    }];
    
    UIImageView *rightImageView = [[UIImageView alloc]init];
    rightImageView.image = [UIImage imageNamed:@"image_lihe"];
    [top2RightView addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(exchangeRecordLabel.mas_top).with.offset(-1);
        make.right.equalTo(exchangeRecordLabel.mas_left).with.offset(-RESIZE_UI(20));
        make.width.mas_equalTo(RESIZE_UI(58));
        make.height.mas_equalTo(RESIZE_UI(39));
    }];
    
    UILabel *watchExchangeLabel = [[UILabel alloc]init];
    watchExchangeLabel.text = @"看看你都换了啥";
    watchExchangeLabel.textColor = RGBA(153, 153, 153, 1.0);
    watchExchangeLabel.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
    [top2RightView addSubview:watchExchangeLabel];
    [watchExchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(exchangeRecordLabel.mas_bottom).with.offset(RESIZE_UI(4));
        make.left.equalTo(exchangeRecordLabel.mas_left);
    }];
    
    UIButton *watchExchangeRecordButton = [[UIButton alloc]init];
    [watchExchangeRecordButton setBackgroundColor:[UIColor clearColor]];
    [watchExchangeRecordButton addTarget:self action:@selector(watchExchangeRecordMethod) forControlEvents:UIControlEventTouchUpInside];
    [top2RightView addSubview:watchExchangeRecordButton];
    [watchExchangeRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(top2RightView);
    }];
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    self.classCollectionView = collectionView;
    self.classCollectionView.scrollEnabled = NO;
    [self.classCollectionView registerClass:[IntegralProductCollectionViewCell class] forCellWithReuseIdentifier:@"IntegralProductCollectionViewCell"];
    [self.classCollectionView registerNib:[UINib nibWithNibName:@"IntegralProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"IntegralProductCollectionViewCell"];
    //    [self.classCollectionView registerNib:[UINib nibWithNibName:@"StoreClassCollectionReusableView" bundle:nil]
    //               forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
    //                      withReuseIdentifier:@"StoreClassCollectionReusableView"];//header注册
    [self.classCollectionView registerClass:[StoreClassCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StoreClassCollectionReusableView"];
    self.classCollectionView.delegate = self;
    self.classCollectionView.dataSource = self;
    self.classCollectionView.backgroundColor = RGBA(243, 244, 246, 1.0);
    self.classCollectionView.showsVerticalScrollIndicator = NO;
    self.classCollectionView.showsHorizontalScrollIndicator = NO;
    self.classCollectionView.scrollEnabled = NO;
    [self.viewForScroll addSubview:self.classCollectionView];
    NSInteger count1 = _trueProductListArray.count/2;
    if (_trueProductListArray.count%2>0) {
        count1++;
    }
    NSInteger count2 = _falseProductListArray.count/2;
    if (_falseProductListArray.count%2>0) {
        count2++;
    }
    NSInteger count = count1+count2;
    [self.classCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(top2LeftView.mas_bottom);
        make.left.equalTo(self.viewForScroll.mas_left);
        make.right.equalTo(self.viewForScroll.mas_right);
        //        make.bottom.equalTo(self.viewForScroll.mas_bottom);
        make.height.mas_offset(RESIZE_UI(43)*2+RESIZE_UI(205)*count);
    }];
    
    [_viewForScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.classCollectionView.mas_bottom);
    }];
}

#pragma mark - 获取个人信息
- (void)getDataWithLogin {
    NetManager *manager = [[NetManager alloc] init];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [userDefault objectForKey:@"mobile"];
    NSString *pwd = [userDefault objectForKey:@"passWord"];
    [manager postDataWithUrlActionStr:@"User/login" withParamDictionary:@{@"mobile":mobile, @"pwd":pwd} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSDictionary *dataDic = obj[@"data"];
                [UserInfoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"user_id" : @"id"};
                }];
                UserInfoModel *userModel = [UserInfoModel mj_objectWithKeyValues:dataDic];
                [SingletonManager sharedManager].userModel = userModel;
                [self getProductListMethod];
                
            } else {
                [SVProgressHUD showInfoWithStatus:@"账号密码有误,请重新登录"];
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                loginVC.loginIden = @"login";
                loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                UINavigationController *loginNa = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNa animated:YES completion:nil];
            }
        }
    }];
}

#pragma mark - 获取商品列表
- (void)getProductListMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Goods/lists" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSArray *twoArray = obj[@"data"];
            _trueProductListArray = [[NSMutableArray alloc]init];
            _falseProductListArray = [[NSMutableArray alloc]init];
            if (twoArray.count == 2) {
                for (int j=0; j<twoArray.count; j++) {
                    NSDictionary *dic = twoArray[j];
                    if ([dic[@"type_id"] isEqualToString:@"1"]) {
                        NSArray *trueArray = dic[@"goods"];
                        for (int i=0; i<trueArray.count; i++) {
                            NSDictionary *productDic = trueArray[i];
                            IntegralProductModel *integralProductModel = [IntegralProductModel mj_objectWithKeyValues:productDic];
                            [_trueProductListArray addObject:integralProductModel];
                        }
                    } else {
                        NSArray *falseArray = dic[@"goods"];
                        for (int i=0; i<falseArray.count; i++) {
                            NSDictionary *productDic = falseArray[i];
                            IntegralProductModel *integralProductModel = [IntegralProductModel mj_objectWithKeyValues:productDic];
                            [_falseProductListArray addObject:integralProductModel];
                        }
                    }
                }
            }
            if (_scrollViewForCollect) {
                _tip2Label.text = [SingletonManager sharedManager].userModel.score_clear;
                _intergralNumber.text = [SingletonManager sharedManager].userModel.score;
                [_classCollectionView reloadData];
            } else {
                [self setUpViewSign];
            }
            [SVProgressHUD dismiss];
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

#pragma mark - 查看积分记录
- (void)watchScoreRecordMethod {
    ScordRecordViewController *scoreRecordVC = [[ScordRecordViewController alloc]init];
    [self.navigationController pushViewController:scoreRecordVC animated:YES];
}

#pragma mark - 查看兑换记录
- (void)watchExchangeRecordMethod {
    ExchangeRecordViewController *exchangeRecordVC = [[ExchangeRecordViewController alloc]init];
    [self.navigationController pushViewController:exchangeRecordVC animated:YES];
}

#pragma mark - collectionview - delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        return _falseProductListArray.count;
    } else {
        return _trueProductListArray.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"IntegralProductCollectionViewCell";
    IntegralProductCollectionViewCell *cell = (IntegralProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.integralProductModel = _falseProductListArray[indexPath.row];
    } else {
        cell.integralProductModel = _trueProductListArray[indexPath.row];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = SCREEN_WIDTH/2-0.5;
    return CGSizeMake(width , RESIZE_UI(205));
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1,0,1,0);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0f;
}

// 定义cell间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5f;
}

//Header 方法
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.classCollectionView.frame.size.width, RESIZE_UI(43));
}

//Header布局
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        StoreClassCollectionReusableView *headerView = (StoreClassCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StoreClassCollectionReusableView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.headerLabel.text = @"虚拟兑换区";
        } else {
            headerView.headerLabel.text = @"实物兑换区";
        }
        return headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    IntegralProductDetailViewController *integralProductDetailVC = [[IntegralProductDetailViewController alloc]init];
    IntegralProductModel *integralProductModel;
    if (indexPath.section == 0) {
        integralProductModel = _falseProductListArray[indexPath.row];
    } else {
        integralProductModel = _trueProductListArray[indexPath.row];
    }
    integralProductDetailVC.integralProductModel = integralProductModel;
    [self.navigationController pushViewController:integralProductDetailVC animated:YES];
    
}

//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
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
