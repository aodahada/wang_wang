//
//  SortCaiYouViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/28.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "SortCaiYouViewController.h"
#import "SortCaiYouTableViewCell.h"
#import "GetContactPersonList.h"
#import "SortContaceModel.h"
#import "PopMenu.h"
#import "SharedView.h"
#import <Contacts/Contacts.h>

@interface SortCaiYouViewController ()<UITableViewDelegate,UITableViewDataSource>{
    PopMenu *_popMenu;
    SharedView *_sharedView;
}

@property (nonatomic, strong)UIButton *leftButton;
@property (nonatomic, strong)UIButton *rightButton;
@property (nonatomic, strong)UITableView *mainTableView;
@property (nonatomic, copy) NSString *contactListString;
@property (nonatomic, strong)NSMutableArray *contactListArray;
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, strong)UILabel *timeTitleLabel;
@property (nonatomic, strong)UIButton *showWhenEmpty;
@property (nonatomic, strong)UIButton *showWhenReject;

@end

@implementation SortCaiYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"财友圈";
    self.view.backgroundColor = [UIColor whiteColor];
    _currentPage = 1;
    _type = 0;
    //获取通讯录
    _contactListString = [[GetContactPersonList sharedManager] getPeronListMethod];
//    [self setUpLayout];
    
    
    [self setUpLayout];
    [self qianchengBangMethod:1];
    
}

#pragma mark - 未授权获取通讯录
- (void)showWhenRejectMethod {
    _showWhenReject = [[UIButton alloc]init];
    [_showWhenReject setBackgroundImage:[UIImage imageNamed:@"您还未授权访问通讯录 无法查看 点击“立即授权”查看我的人脉榜吧～"] forState:UIControlStateNormal];
    [_showWhenReject addTarget:self action:@selector(getContactMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showWhenReject];
    [_showWhenReject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.mas_offset(RESIZE_UI(256.65));
        make.height.mas_offset(RESIZE_UI(58));
    }];
}

#pragma mark - 获取通讯录
- (void)getContactMethod {
    //获取通讯录
    _contactListString = [[GetContactPersonList sharedManager] getPeronListMethod];
    // 1.获取授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    // 2.判断授权状态,如果不是已经授权,则直接返回
    if (status == CNAuthorizationStatusAuthorized) {
        [_mainTableView.mj_header beginRefreshing];
    } else {
//        NSLog(@"还是没受权");
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"如若app要重新获得通讯录权限，需要您到设置-旺马财富-打开通讯录权限" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
    }
}

#pragma mark - 布局
- (void)setUpLayout {
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = RGBA(242, 242, 242, 1.0);
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(55));
    }];
    
    UIView *buttonView = [[UIView alloc]init];
    buttonView.backgroundColor = RGBA(242, 242, 242, 1.0);
    [topView addSubview:buttonView];
    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.centerY.equalTo(topView.mas_centerY);
        make.width.mas_offset(RESIZE_UI(200));
        make.height.mas_offset(RESIZE_UI(30));
    }];
    
    _leftButton = [[UIButton alloc]init];
    [_leftButton setTitle:@"钱程榜" forState:UIControlStateNormal];
    _leftButton.tag = 0;
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
    _leftButton.layer.borderWidth = 2;
    _leftButton.layer.borderColor = NEWYEARCOLOR.CGColor;
    [_leftButton setBackgroundColor:NEWYEARCOLOR];
    [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(clickButtonType:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:_leftButton];
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonView.mas_top);
        make.left.equalTo(buttonView.mas_left);
        make.bottom.equalTo(buttonView.mas_bottom);
        make.width.mas_offset(RESIZE_UI(100));
    }];
    
    _rightButton = [[UIButton alloc]init];
    [_rightButton setTitle:@"富豪榜" forState:UIControlStateNormal];
    _rightButton.tag = 1;
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
    _rightButton.layer.borderWidth = 2;
    _rightButton.layer.borderColor = NEWYEARCOLOR.CGColor;
    [_rightButton setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    [_rightButton setTitleColor:NEWYEARCOLOR forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(clickButtonType:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:_rightButton];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonView.mas_top);
        make.right.equalTo(buttonView.mas_right);
        make.bottom.equalTo(buttonView.mas_bottom);
        make.left.equalTo(_leftButton.mas_right);
    }];
    
    UIView *titleView = [[UIView alloc]init];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(42));
    }];
    
    UILabel *indexTitleLabel = [[UILabel alloc]init];
    indexTitleLabel.text = @"排名";
    indexTitleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [titleView addSubview:indexTitleLabel];
    [indexTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.left.equalTo(titleView.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    UILabel *userTitleLabel = [[UILabel alloc]init];
    userTitleLabel.text = @"用户名";
    userTitleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [titleView addSubview:userTitleLabel];
    [userTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.left.equalTo(titleView.mas_left).with.offset(RESIZE_UI(113));
    }];
    
    _timeTitleLabel = [[UILabel alloc]init];
    _timeTitleLabel.text = @"累计奖励金额(元)";
    _timeTitleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _timeTitleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:_timeTitleLabel];
    [_timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.right.equalTo(titleView.mas_right).with.offset(-RESIZE_UI(30));
        make.width.mas_offset(RESIZE_UI(120));
    }];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = RGBA(242, 242, 242, 1.0);
    [self.view addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(1);
    }];
    
    _mainTableView = [[UITableView alloc]init];
    _mainTableView.tableFooterView = [[UIView alloc]init];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    _mainTableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        _currentPage = 1;
        _contactListArray = [[NSMutableArray alloc]init];
        if (_type == 0) {
            [self qianchengBangMethod:_currentPage];
        } else {
            [self renmaiBangMethod:_currentPage];
        }
    }];
    
    _mainTableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        _currentPage++;
        if (_type == 0) {
            [self qianchengBangMethod:_currentPage];
        } else {
            [self renmaiBangMethod:_currentPage];
        }
    }];
    
}

- (void)clickButtonType:(UIButton *)btn {
    switch (btn.tag) {
        case 0:
        {
            _type = 0;
            _timeTitleLabel.text = @"累计奖励金额(元)";
            [_leftButton setBackgroundColor:NEWYEARCOLOR];
            [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_rightButton setBackgroundColor:RGBA(242, 242, 242, 1.0)];
            [_rightButton setTitleColor:NEWYEARCOLOR forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            _type = 1;
            _timeTitleLabel.text = @"邀请好友人数(人)";
            [_rightButton setBackgroundColor:NEWYEARCOLOR];
            [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_leftButton setBackgroundColor:RGBA(242, 242, 242, 1.0)];
            [_leftButton setTitleColor:NEWYEARCOLOR forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    [_mainTableView.mj_header beginRefreshing];
}

#pragma mark - 钱程榜
- (void)qianchengBangMethod:(NSInteger)qianchengPage {
    NetManager *manager = [[NetManager alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"member_id"] = [SingletonManager sharedManager].uid;
    dict[@"contact"] = _contactListString;
    dict[@"page"] = @(qianchengPage);
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Focus/prospect" withParamDictionary:dict withBlock:^(id obj) {
        [SVProgressHUD dismiss];
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _contactListArray = [SortContaceModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            [_mainTableView reloadData];
            // 1.获取授权状态
            CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
            
            // 2.判断授权状态,如果不是已经授权,则直接返回
            if (status == CNAuthorizationStatusAuthorized) {
                if (_showWhenReject) {
                    [_showWhenReject removeFromSuperview];
                    _showWhenReject = nil;
                }
                if (_contactListArray.count == 0) {
                    [self showWhenEmptyMethod];
                } else {
                    if (_showWhenEmpty) {
                        [_showWhenEmpty removeFromSuperview];
                        _showWhenEmpty = nil;
                    }
                }
            } else {
                [self showWhenRejectMethod];
            }
        } else {
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
        [_mainTableView.mj_header endRefreshing];
        [_mainTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 富豪榜
- (void)renmaiBangMethod:(NSInteger)renmaiPage {
    NetManager *manager = [[NetManager alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"member_id"] = [SingletonManager sharedManager].uid;
    dict[@"contact"] = _contactListString;
    dict[@"page"] = @(renmaiPage);
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Focus/rich" withParamDictionary:dict withBlock:^(id obj) {
        [SVProgressHUD dismiss];
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _contactListArray = [SortContaceModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            [_mainTableView reloadData];
            // 1.获取授权状态
            CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
            
            // 2.判断授权状态,如果不是已经授权,则直接返回
            if (status == CNAuthorizationStatusAuthorized) {
                if (_showWhenReject) {
                    [_showWhenReject removeFromSuperview];
                    _showWhenReject = nil;
                }
                if (_contactListArray.count == 0) {
                    [self showWhenEmptyMethod];
                } else {
                    if (_showWhenEmpty) {
                        [_showWhenEmpty removeFromSuperview];
                        _showWhenEmpty = nil;
                    }
                }
            } else {
                [self showWhenRejectMethod];
            }
        } else {
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
        [_mainTableView.mj_header endRefreshing];
        [_mainTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 当没数据时显示的图片
- (void)showWhenEmptyMethod {
    _showWhenEmpty = [[UIButton alloc]init];
    [_showWhenEmpty setBackgroundImage:[UIImage imageNamed:@"您当前的财友圈为空 赶紧点击“邀请财友”扩大财友圈吧！"] forState:UIControlStateNormal];
    [_showWhenEmpty addTarget:self action:@selector(clickSharedBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showWhenEmpty];
    [_showWhenEmpty mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.mas_offset(RESIZE_UI(249.5));
        make.height.mas_offset(RESIZE_UI(37));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contactListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SortContaceModel *sortModel = _contactListArray[indexPath.row];
    SortCaiYouTableViewCell *cell = [[SortCaiYouTableViewCell alloc]initWithType:_type withRow:indexPath.row WithModel:sortModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 邀请好友
//响应点击分享的方法
- (void)clickSharedBtnAction {
    //    NSLog(@"-------点击分享----");
    _popMenu = [[PopMenu alloc] init];
    _popMenu.dimBackground = YES;
    _popMenu.coverNavigationBar = YES;
    _sharedView = [[SharedView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-RESIZE_UI(168), SCREEN_WIDTH, RESIZE_UI(168))];
    [_popMenu addSubview:_sharedView];
    [_popMenu showInRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    _sharedView.center = _popMenu.center;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPopAction)];
    [_popMenu addGestureRecognizer:tap];
    
    [_sharedView callSharedBtnEventBlock:^(UIButton *sender) {
        [_popMenu dismissMenu];
        SharedManager *sharedManager = [[SharedManager alloc] init];
        if ([SingletonManager sharedManager].userModel.invitationcode) {
            NSString *contentStr = [NSString stringWithFormat:@"大吉大利，春节来“息”！工资不够，年终来凑！快快使用我的旺马财富推荐码%@立即出借吧！", [SingletonManager sharedManager].userModel.invitationcode];
            //            NSString *urlStr = [NSString stringWithFormat:@"http://m.wmjr888.com/?invitationcode=%@#login-register",_invitationcode];
            NSString *urlStr = [NSString stringWithFormat:@"http://m.wangmacaifu.com/#/register/wmcf-%@",[SingletonManager sharedManager].userModel.invitationcode];
            [sharedManager shareContent:sender withTitle:@"速来！你的年终奖已到达战场！" andContent:contentStr andUrl:urlStr];
            
        } else {
            [[SingletonManager sharedManager] alert1PromptInfo:@"推荐码获取失败,请重新分享"];
        }
    }];
}

/*遮盖消失*/
- (void)tapPopAction {
    [_popMenu dismissMenu];
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
