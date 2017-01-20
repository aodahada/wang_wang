//
//  NewProductDetailViewController.m
//  WmjrApp
//
//  Created by horry on 2017/1/15.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "NewProductDetailViewController.h"
#import "ProductModel.h"
#import "ShowBigImageView.h"
#import "ViewForNewYearProDetail.h"
#import "AgViewController.h"
#import "BaseNavigationController.h"

@interface NewProductDetailViewController ()

@property (nonatomic, strong) ProductModel *productModel;
@property (nonatomic, strong) UITableView *detailTablview;
@property (nonatomic, strong) ViewForNewYearProDetail *viewForShuoMing;

@end

@implementation NewProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"产品详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getDataWithNetManager];
}

#pragma mark - 界面布局
- (void)setUpLayout{
    
    UIButton *buyButton = [[UIButton alloc]init];
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(buyImmediately) forControlEvents:UIControlEventTouchUpInside];
    [buyButton setTitleColor:RGBA(158, 100, 93, 1.0) forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(18)];
    [buyButton setBackgroundColor:RGBA(255, 236, 200, 1.0)];
    [self.view addSubview:buyButton];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(RESIZE_UI(50));
    }];
    
    UIScrollView *mainscrollview = [[UIScrollView alloc]init];
    mainscrollview.bounces = NO;
    [self.view addSubview:mainscrollview];
    [mainscrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(buyButton.mas_top);
    }];
    
    UIView *mainView = [[UIView alloc]init];
    mainView.backgroundColor = [UIColor whiteColor];
    [mainscrollview addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainscrollview);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.image = [UIImage imageNamed:@"image_xiangqing_up"];
    [mainView addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView.mas_top);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_equalTo(RESIZE_UI(248));
    }];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGBA(238, 54, 46, 1.0).CGColor,(__bridge id)RGBA(114, 8, 1, 1.0).CGColor];
    gradientLayer.locations = @[@0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, RESIZE_UI(248), RESIZE_UI(18), 44*6+230+10);
    [mainView.layer addSublayer:gradientLayer];
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.colors = @[(__bridge id)RGBA(238, 54, 46, 1.0).CGColor,(__bridge id)RGBA(114, 8, 1, 1.0).CGColor];
    gradientLayer2.locations = @[@0.5, @1.0];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(0, 1.0);
    gradientLayer2.frame = CGRectMake(SCREEN_WIDTH-RESIZE_UI(18), RESIZE_UI(248), RESIZE_UI(18), 44*6+230+10);
    [mainView.layer addSublayer:gradientLayer2];
    
    _viewForShuoMing = [[ViewForNewYearProDetail alloc]initWithProductModel:_productModel];
    _viewForShuoMing.watchPic = ^(NSString *picStr){
        
        ShowBigImageView *showImgView = [[ShowBigImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [showImgView show];
        showImgView.imageArray = @[picStr];
        showImgView.titleNumberLabel.hidden = YES;
        
    };
    @weakify(self)
    _viewForShuoMing.watchContract = ^(){
        @strongify(self)
        AgViewController *agVC =[[AgViewController alloc] init];
        agVC.title = @"购买合同";
        agVC.webUrl = @"http://api.wmjr888.com/home/page/app/id/9";
        BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
        [self presentViewController:baseNa animated:YES completion:^{
        }];
        
    };
    [mainView addSubview:_viewForShuoMing];
    [_viewForShuoMing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageView.mas_bottom);
        make.left.equalTo(mainView.mas_left).with.offset(RESIZE_UI(18));
        make.right.equalTo(mainView.mas_right).with.offset(RESIZE_UI(-18));
        make.bottom.equalTo(mainView.mas_bottom);
        make.height.mas_offset(44*6+230+10);
    }];
    
}

#pragma mark - 获取详情
- (void)getDataWithNetManager {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSDictionary *paramDic = @{@"product_id":self.productId};
    [manager postDataWithUrlActionStr:@"Product/new_detail" withParamDictionary:paramDic withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [ProductModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"proIntro_id" : @"id"};
            }];
            _productModel = [ProductModel mj_objectWithKeyValues:obj[@"data"]];
            //主界面布局
            [self setUpLayout];
            
            [SVProgressHUD dismiss];
            
        } else {
            [SVProgressHUD showErrorWithStatus:[obj[@"data"] objectForKey:@"mes"]];
        }
    }];
}

#pragma mark - 立即购买
- (void)buyImmediately {
    [self.navigationController popViewControllerAnimated:YES];
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
