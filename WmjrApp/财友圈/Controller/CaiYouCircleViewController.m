//
//  CaiYouCircleViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/24.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "CaiYouCircleViewController.h"
#import "InvestCaiYouViewController.h"
#import "SortCaiYouViewController.h"
#import "CalculateShouYiView.h"

@interface CaiYouCircleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UIView *blackBottomView;//二维码黑背景
@property (nonatomic, strong)UIView *whiteBottomView;//二维码白背景
@property (nonatomic, strong)UIImageView *codeImageView;//二维码图片
@property (nonatomic, strong)UIImageView *codeHeadImage;//二维码中间头像
@property (nonatomic, strong)UITapGestureRecognizer *tapGes;//点击手势

@end

@implementation CaiYouCircleViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"财友圈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"规则说明" style:UIBarButtonItemStylePlain target:self action:@selector(ruleShowMethod)];
    [rightBarButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:RESIZE_UI(15)], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    [self setUpLayout];
    
}

#pragma mark - 规则说明
- (void)ruleShowMethod {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - 界面布局
- (void)setUpLayout {
    
    UIButton *bottomButton = [[UIButton alloc]init];
//    [bottomButton setBackgroundColor:NEWYEARCOLOR];
    [bottomButton setBackgroundImage:[UIImage imageNamed:@"icon_jjcc"] forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(calculateMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.width.height.mas_offset(RESIZE_UI(44));
    }];
    
    UIButton *bottomView = [[UIButton alloc]init];
    [bottomView setTitle:@"邀请财友" forState:UIControlStateNormal];
    [bottomView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomView.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [bottomView setBackgroundColor:YEARCOLOR];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(bottomButton.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(44));
    }];
    
    UIScrollView *mainScrollView = [[UIScrollView alloc]init];
    mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
    UIView *viewMain = [[UIView alloc]init];
    viewMain.backgroundColor = [UIColor redColor];
    [mainScrollView addSubview:viewMain];
    [viewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.image = [UIImage imageNamed:@"image_caiyou"];
    [viewMain addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewMain.mas_top);
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(322));
    }];
    
    UITableView *tableViewMain = [[UITableView alloc]init];
    tableViewMain.delegate = self;
    tableViewMain.dataSource = self;
    tableViewMain.scrollEnabled = NO;
    tableViewMain.tableFooterView = [[UIView alloc]init];
    [viewMain addSubview:tableViewMain];
    [tableViewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageView.mas_bottom);
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(60)*4);
    }];
    
    [viewMain mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tableViewMain.mas_bottom);
    }];
    
}

#pragma mark - calculate计算页面
- (void)calculateMethod {
    CalculateShouYiView *calculateView = [[CalculateShouYiView alloc]init];
    [self.view addSubview:calculateView];
    [calculateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(375));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier;
    switch (indexPath.row) {
        case 0:
            identifier = @"cell1";
            break;
        case 1:
            identifier = @"cell2";
            break;
        case 2:
            identifier = @"cell3";
            break;
        case 3:
            identifier = @"cell4";
            break;
            
        default:
            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"123456";
    tipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    [cell addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.mas_centerY);
        make.right.equalTo(cell.mas_right).with.offset(-RESIZE_UI(40));
    }];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.imageView.image = [UIImage imageNamed:@"icon_wdyqm"];
            cell.textLabel.text = @"我的邀请码";
            
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
            
            UIButton *codeImageView = [[UIButton alloc]init];
            UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:15];
            [codeImageView setBackgroundImage:image forState:UIControlStateNormal];
            [codeImageView addTarget:self action:@selector(watchCodeMethod) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:codeImageView];
            [codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell.mas_right).with.offset(-RESIZE_UI(15));
                make.width.height.mas_offset(RESIZE_UI(15));
            }];
            
            tipLabel.text = [SingletonManager sharedManager].userModel.invitationcode;
            
        }
            break;
        case 1:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageNamed:@"icon_ljcyjl"];
            cell.textLabel.text = @"累计财友奖励";
            tipLabel.text = [NSString stringWithFormat:@"%@元",[SingletonManager sharedManager].userModel.asset.invite_money];
        }
            
            break;
        case 2:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageNamed:@"icon_yqcyrs"];
            cell.textLabel.text = @"邀请财友人数";
            tipLabel.text = [NSString stringWithFormat:@"%@人",[SingletonManager sharedManager].userModel.asset.invite_count];
        }
            
            break;
        case 3:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageNamed:@"icon_cyphb"];
            cell.textLabel.text = @"财友排行榜";
            
            tipLabel.text = @"";
        }
            
            break;
            
        default:
            break;
    }
    
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
            InvestCaiYouViewController *investCaiYouVC = [[InvestCaiYouViewController alloc]init];
            [self.navigationController pushViewController:investCaiYouVC animated:YES];
        }
            break;
        case 3:
        {
            SortCaiYouViewController *sortCaiYouVC = [[SortCaiYouViewController alloc]init];
            [self.navigationController pushViewController:sortCaiYouVC animated:YES];
        }
            break;
            
        default:
            break;
    }
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
