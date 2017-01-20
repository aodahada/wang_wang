//
//  NewProductBuyViewController.m
//  WmjrApp
//
//  Created by horry on 2017/1/15.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "NewProductBuyViewController.h"
#import "NewProductDetailViewController.h"
#import "NewProductCollectionViewCell.h"
#import "LoginViewController.h"
#import "WebViewForPayViewController.h"
#import "ProductModel.h"
#import "NewProductDetailViewController.h"

@interface NewProductBuyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UITextField *inputMoneyLabel;
@property (nonatomic, strong) NSArray *yearProArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *estimateYearEarnLabel;//预计年化收益
@property (nonatomic, strong) ProductModel *productModel;

@end

@implementation NewProductBuyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /*  设置颜色 */
    self.navigationController.navigationBar.barTintColor = VIEWBACKCOLOR;
    //    /*  设置字体颜色 */
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:TITLE_COLOR};
    //    /* 渲染颜色 */
    self.navigationController.navigationBar.tintColor = TITLE_COLOR;
    
    /*  去掉边线 */
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"piggy"] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *image = [[UIImage imageNamed:@"arrow_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买金额";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    //获取产品数据
    [self getFinanceDataMethod];
}

/**
 获取产品数据
 */
- (void)getFinanceDataMethod {
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NetManager *manager = [[NetManager alloc] init];
    NSDictionary *paramDic = @{@"is_recommend":@"0", @"page":@"", @"size":@"",@"is_newyear":@"1"};
    [manager postDataWithUrlActionStr:@"Product/new_index" withParamDictionary:paramDic withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [ProductModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"proIntro_id" : @"id"};
            }];
            _yearProArray = [ProductModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            BOOL canBeFirst = true;
            for(int i=0;i<_yearProArray.count;i++){
                ProductModel *proModel = _yearProArray[i];
                if(![proModel.is_down isEqualToString:@"1"]){
                    if (canBeFirst) {
                        canBeFirst = false;
                        proModel.isSelect = true;
                        _productModel = proModel;
                    } else {
                        proModel.isSelect = false;
                    }
                } else {
                    proModel.isSelect = false;
                }
            }
            [SVProgressHUD dismiss];
            //界面布局
            [self setUpLayout];
            if(_productModel) {
                [self configEstimateYear];
            }
            
        } else {
            [SVProgressHUD dismiss];
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            [SVProgressHUD dismiss];
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
    }];
    
}

#pragma mark - 界面布局
- (void)setUpLayout {
    
    UIImageView *imageViewBg = [[UIImageView alloc]init];
    imageViewBg.image = [UIImage imageNamed:@"image_bg_goumai"];
    [imageViewBg setUserInteractionEnabled:YES];
    [self.view addSubview:imageViewBg];
    [imageViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-52);
    }];
    
    //预计年化收益
    _estimateYearEarnLabel = [[UILabel alloc]init];
    _estimateYearEarnLabel.textColor = RGBA(255, 16, 28, 1.0);
    _estimateYearEarnLabel.textAlignment = NSTextAlignmentCenter;
    _estimateYearEarnLabel.attributedText =  [self changeStringWithString:@"0.00元" withFrontColor:RGBA(255, 16, 28, 1.0) WithBehindColor:RGBA(255, 16, 28, 1.0) withFrontFont:[UIFont systemFontOfSize:RESIZE_UI(30)] WithBehindFont:[UIFont systemFontOfSize:RESIZE_UI(16)]];
    [imageViewBg addSubview:_estimateYearEarnLabel];
    float topfloat;
    if (SCREEN_WIDTH==375) {
        topfloat = 137;
    } else if (SCREEN_WIDTH>375){
        topfloat = 140;
    } else {
        topfloat = 133;
    }
    [_estimateYearEarnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageViewBg.mas_top).with.offset(RESIZE_UI(topfloat));
        make.centerX.equalTo(imageViewBg.mas_centerX);
        make.height.mas_offset(RESIZE_UI(62));
    }];
    
    //查看产品详情
    UIButton *productDetailButton = [[UIButton alloc]init];
    [productDetailButton setBackgroundColor:[UIColor clearColor]];
    productDetailButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    [productDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [productDetailButton addTarget:self action:@selector(watchProductDetailMethod) forControlEvents:UIControlEventTouchUpInside];
    [imageViewBg addSubview:productDetailButton];
    [productDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageViewBg.mas_top).with.offset(RESIZE_UI(230));
        make.width.mas_offset(RESIZE_UI(100));
        make.height.mas_offset(RESIZE_UI(50));
        make.right.equalTo(imageViewBg.mas_right).with.offset(RESIZE_UI(-55));
    }];
    
    
    UIView *bottomview = [[UIView alloc]init];
    bottomview.backgroundColor = RGBA(255, 248, 235, 1.0);
    [self.view addSubview:bottomview];
    [bottomview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageViewBg.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        
    }];
    
    UIButton *payButton = [[UIButton alloc]init];
    [payButton setBackgroundColor:RGBA(255, 236, 200, 1.0)];
    [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [payButton setTitleColor:RGBA(158, 100, 93, 1.0) forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(payButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    payButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    [bottomview addSubview:payButton];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomview.mas_right);
        make.centerY.equalTo(bottomview.mas_centerY);
        make.top.equalTo(bottomview.mas_top);
        make.width.mas_offset(RESIZE_UI(111));
    }];
    
    ProductModel *promodel = self.yearProArray[0];
    _inputMoneyLabel = [[UITextField alloc]init];
    _inputMoneyLabel.backgroundColor = RGBA(255, 248, 235, 1.0);
    _inputMoneyLabel.font = [UIFont systemFontOfSize:RESIZE_UI(18)];
    _inputMoneyLabel.keyboardType = UIKeyboardTypeDecimalPad;
    _inputMoneyLabel.placeholder = [NSString stringWithFormat:@"当前剩余可购:%@",promodel.balance];
    [_inputMoneyLabel addTarget:self action:@selector(configEstimateYear) forControlEvents:UIControlEventEditingChanged];
    [bottomview addSubview:_inputMoneyLabel];
    [_inputMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomview.mas_top);
        make.left.equalTo(bottomview.mas_left).with.offset(RESIZE_UI(12));
        make.bottom.equalTo(bottomview.mas_bottom);
        make.right.equalTo(payButton.mas_left);
    }];
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    [_collectionView registerClass:[NewProductCollectionViewCell class] forCellWithReuseIdentifier:@"NewProductCollectionViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomview.mas_top).with.offset(-10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(240));
    }];
    
}

#pragma mark - 计算预计年收益
- (void)configEstimateYear {
    
    float inputMoney;
    if([self.inputMoneyLabel.text isEqualToString:@""]){
        inputMoney = 0.0;
    } else {
        inputMoney = self.inputMoneyLabel.text.floatValue;
    }
    ProductModel *model;
    for (int i=0; i<self.yearProArray.count; i++) {
        ProductModel *haha = self.yearProArray[i];
        if (haha.isSelect) {
            model = haha;
        }
    }
    float yearRate = model.returnrate.floatValue;
    float date = model.day.floatValue;
    float estimateYearEarnFloat = inputMoney*yearRate/365*date;
    NSString *estimateString = [NSString stringWithFormat:@"%.2f元",estimateYearEarnFloat];
    _estimateYearEarnLabel.attributedText =  [self changeStringWithString:estimateString withFrontColor:RGBA(255, 16, 28, 1.0) WithBehindColor:RGBA(255, 16, 28, 1.0) withFrontFont:[UIFont systemFontOfSize:RESIZE_UI(30)] WithBehindFont:[UIFont systemFontOfSize:RESIZE_UI(16)]];
    
}

#pragma mark - collectionview - delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 4;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"NewProductCollectionViewCell";
    NewProductCollectionViewCell *cell = (NewProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.model = _yearProArray[indexPath.row];
    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(SCREEN_WIDTH/2 ,collectionView.frame.size.height/2);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

// 定义cell间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductModel *selectModel = self.yearProArray[indexPath.row];
    if(![selectModel.is_down isEqualToString:@"1"]){
        for (int i=0; i<self.yearProArray.count; i++) {
            ProductModel *segment = self.yearProArray[i];
            segment.isSelect = false;
        }
        selectModel.isSelect = true;
        _productModel = selectModel;
        [self.collectionView reloadData];
        _inputMoneyLabel.placeholder = [NSString stringWithFormat:@"当前剩余可购:%@",selectModel.balance];
        //计算预期年化收益
        [self configEstimateYear];
    }
    
}

//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - 查看产品详情
- (void)watchProductDetailMethod{
    BOOL canwatch = false;
    for (int i=0; i<self.yearProArray.count; i++) {
        ProductModel *model = self.yearProArray[i];
        if (model.isSelect) {
            canwatch = true;
        }
    }
    if (canwatch) {
        NewProductDetailViewController *newProDetailVC = [[NewProductDetailViewController alloc]init];
        newProDetailVC.productId = _productModel.proIntro_id;
        [self.navigationController pushViewController:newProDetailVC animated:YES];
    } else {
        [[[UIAlertView alloc]initWithTitle:@"当前没有可购买的产品" message:@"" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
    }
    
}

#pragma mark - 支付按钮
- (void)payButtonMethod {
    
    ProductModel *model;
    for (int i=0; i<self.yearProArray.count; i++) {
        
        ProductModel *haha = self.yearProArray[i];
        if (haha.isSelect) {
            model = haha;
        }
    }
    float restInvest = model.balance.floatValue;
    float lowInvest = model.lowpurchase.floatValue;
    float investmoney = _inputMoneyLabel.text.floatValue;
    if([_inputMoneyLabel.text isEqualToString:@""]){
        [SVProgressHUD showInfoWithStatus:@"请输入购买金额"];
    } else if ([[self convertNullString:[SingletonManager sharedManager].uid] isEqualToString:@""]) {
        [_inputMoneyLabel resignFirstResponder];
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.loginIden = @"login";
        loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController *loginNa = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNa animated:YES completion:nil];
    } else if(investmoney>restInvest) {
        NSString *tip = [NSString stringWithFormat:@"投资金额不能超过%.2f元",restInvest];
        [[[UIAlertView alloc]initWithTitle:tip message:@"" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil]show];
    } else if (investmoney<lowInvest){
        NSString *tip = [NSString stringWithFormat:@"产品起购金额为%.2f元",lowInvest];
        [[[UIAlertView alloc]initWithTitle:tip message:@"" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil]show];
    } else {
        NetManager *manager = [[NetManager alloc] init];
        [SVProgressHUD showWithStatus:@"加载中"];
        [manager postDataWithUrlActionStr:@"Trade/new_collect" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"product_id":model.proIntro_id,@"product_name":model.name,@"money":_inputMoneyLabel.text} withBlock:^(id obj) {
            if (obj) {
                if ([obj[@"result"] isEqualToString:@"1"]) {
                    NSDictionary *dataDic = obj[@"data"];
                    WebViewForPayViewController *webViewForPayVC = [[WebViewForPayViewController alloc]initWithNibName:@"WebViewForPayViewController" bundle:nil];
                    webViewForPayVC.htmlString = dataDic[@"html"];
                    webViewForPayVC.title = @"支付界面";
                    [self.navigationController pushViewController:webViewForPayVC animated:YES];
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
}

#pragma mark - 判断字符串是否为空
- (NSString*)convertNullString:(NSString*)oldString{
    if (oldString!=nil && (NSNull *)oldString != [NSNull null]) {
        if ([oldString length]!=0) {
            if ([oldString isEqualToString:@"(null)"]) {
                return @"";
            }
            return  oldString;
        }else{
            return @"";
        }
    }
    else{
        return @"";
    }
}


- (NSAttributedString *)changeStringWithString:(NSString *)string withFrontColor:(UIColor *)frontColor WithBehindColor:(UIColor *)behindColor withFrontFont:(UIFont *)frontFont WithBehindFont:(UIFont *)behindFont {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:frontColor range:NSMakeRange(0, [string length])];
    [str addAttribute:NSForegroundColorAttributeName value:behindColor range:NSMakeRange([string length] - 1, 1)];
    [str addAttribute:NSFontAttributeName value:frontFont range:NSMakeRange(0, [string length])];
    [str addAttribute:NSFontAttributeName value:behindFont range:NSMakeRange([string length] - 1, 1)];
    return str;
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
