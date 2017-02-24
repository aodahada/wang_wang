//
//  MessageWViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/20.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "MessageWViewController.h"
#import "MessageViewCell.h"
#import "MessageModel.h"
#import "AgViewController.h"
#import "BaseNavigationController.h"

@interface MessageWViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *messTbale;
@property (nonatomic, strong) NSMutableArray *messArray;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UILabel *tipLable;

@end

@implementation MessageWViewController

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.currentPage = 1;
    _messArray = [NSMutableArray array];
    
    [_messTbale registerNib:[UINib nibWithNibName:@"MessageViewCell" bundle:nil] forCellReuseIdentifier:@"messCell"];
    _messTbale.tableFooterView = [[UIView alloc]init];
    
    //下拉刷新
    _messTbale.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self getDataWithNetManager:self.currentPage];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _messTbale.mj_header.automaticallyChangeAlpha = YES;
    
    _messTbale.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage ++;
        [self getDataWithNetManager:self.currentPage];
    }];
    
    [_messTbale.mj_header beginRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - 数据处理 －
- (void)getDataWithNetManager:(NSInteger)currentPage {
    NetManager *manager = [[NetManager alloc] init];
//    [SVProgressHUD showWithStatus:@"消息获取中"];
    [manager postDataWithUrlActionStr:@"User/message" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"page":@(currentPage), @"size":@""} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSDictionary *dic = obj[@"data"];
            NSArray *array = [MessageModel mj_keyValuesArrayWithObjectArray:obj[@"data"]];
            if(currentPage == 1) {
                _messArray = [[NSMutableArray alloc]init];
            }
            for (NSDictionary *dic in array) {
                MessageModel *messageModel = [[MessageModel alloc] init];
                [messageModel mj_setKeyValues:dic];
                [_messArray addObject:messageModel];
            }
            [_messTbale reloadData];
            if (_messArray.count == 0) {
                [self tipLable];
            } else {
                [_tipLable removeFromSuperview];
                _tipLable = nil;
            }
            [_messTbale.mj_header endRefreshing];
            [_messTbale.mj_footer endRefreshing];
        } else {
            [_messTbale.mj_header endRefreshing];
            [_messTbale.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }
    }];
}

- (UILabel *)tipLable {
    if (!_tipLable) {
        _tipLable =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        _tipLable.center = self.view.center;
        _tipLable.textColor = [UIColor grayColor];
        _tipLable.text = @"暂无消息";
        _tipLable.textAlignment = NSTextAlignmentCenter;
        _tipLable.font = [UIFont systemFontOfSize:15.0f];
        [self.view addSubview:_tipLable];
    }
    return _tipLable;
}

#pragma mark - uitableView -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = _messArray[indexPath.row];
    MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    NSString *typeColor = [NSString stringWithFormat:@"#%@",model.type_color];
//    UIColor *realColor = [self hexStringToColor:typeColor];
//    cell.cerType.textColor = realColor;
    cell.cerType.text = model.type_name;
    cell.cerLab.text = model.message_title;
    cell.introLab.text = model.message_intro;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageModel *model = _messArray[indexPath.row];
    AgViewController *agVC =[[AgViewController alloc] init];
    agVC.title = model.message_title;
    agVC.webUrl = model.url;
    BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
    [self presentViewController:baseNa animated:YES completion:^{
    }];
    
}

- (UIColor *)hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 charactersif ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appearsif ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
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
