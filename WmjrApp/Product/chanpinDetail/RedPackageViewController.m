//
//  RedPackageViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/8/22.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "RedPackageViewController.h"
#import "RedPackageModel.h"
#import "MyRedPackageTableViewCell.h"

@interface RedPackageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *mainTableView;
@property (nonatomic, strong)NSMutableArray *redPackageArray;

@end

@implementation RedPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"可用红包";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *mainScrollView = [[UIScrollView alloc]init];
    [self.view addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = RGBA(243, 244, 246, 1.0);
    [mainScrollView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    UIButton *noRedPackageButton = [[UIButton alloc]init];
    [noRedPackageButton setTitle:@"不使用红包" forState:UIControlStateNormal];
    noRedPackageButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    [noRedPackageButton setTitleColor:RGBA(153, 153, 153, 1.0) forState:UIControlStateNormal];
    [noRedPackageButton addTarget:self action:@selector(selecNoRedPackageMethod) forControlEvents:UIControlEventTouchUpInside];
    [noRedPackageButton setBackgroundColor:[UIColor whiteColor]];
    [bottomView addSubview:noRedPackageButton];
    [noRedPackageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).with.offset(RESIZE_UI(15));
        make.left.equalTo(bottomView.mas_left).with.offset(RESIZE_UI(8));
        make.right.equalTo(bottomView.mas_right).with.offset(-RESIZE_UI(8));
        make.height.mas_equalTo(RESIZE_UI(49));
    }];
    
    _mainTableView = [[UITableView alloc]init];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.scrollEnabled = NO;
    _mainTableView.tableFooterView = [[UIView alloc]init];
    [bottomView addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noRedPackageButton.mas_bottom).with.offset(RESIZE_UI(15));
        make.left.equalTo(bottomView.mas_left).with.offset(RESIZE_UI(7));
        make.right.equalTo(bottomView.mas_right).with.offset(-RESIZE_UI(7));
        make.height.mas_equalTo(1000);
        make.bottom.equalTo(bottomView.mas_bottom);
    }];
    
    [self getRedPackageMethod];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"RedPackageViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RedPackageViewController"];
}

#pragma mark - 获取红包信息
- (void)getRedPackageMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Redpacket/my" withParamDictionary:@{@"member_id":@"90221",@"product_id":_productId,@"status":@"2"} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSArray *dataArray = obj[@"data"];
                _redPackageArray = [[NSMutableArray alloc]init];
                for (int i=0; i<dataArray.count; i++) {
                    NSDictionary *dict = dataArray[i];
                    RedPackageModel *redPackageModel = [RedPackageModel mj_objectWithKeyValues:dict];
                    [_redPackageArray addObject:redPackageModel];
                }
                NSInteger row = _redPackageArray.count;
                [_mainTableView reloadData];
                [_mainTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_offset(RESIZE_UI(140)*row);
                }];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger row = _redPackageArray.count;
    return _redPackageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(130);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return RESIZE_UI(10);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = RGBA(243, 244, 246, 1.0);
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RedPackageModel *redPackageModel = _redPackageArray[indexPath.row];
    MyRedPackageTableViewCell *cell = [[MyRedPackageTableViewCell alloc]initWithModel:redPackageModel andIsOut:NO];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 不选择红包
- (void)selecNoRedPackageMethod {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selecNoRedPackage)]) {
        [self.delegate selecNoRedPackage];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RedPackageModel *redPackageModel = _redPackageArray[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectRedPackage:)]) {
        [self.delegate selectRedPackage:redPackageModel];
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
