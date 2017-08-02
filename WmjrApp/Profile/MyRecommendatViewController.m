//
//  MyRecommendatViewController.m
//  WmjrApp
//
//  Created by horry on 16/9/26.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "MyRecommendatViewController.h"
#import "MyReCommandModel.h"
#import "MyRecommandTableViewCell.h"
#import "FRuleViewController.h"
#import "PopMenu.h"
#import "SharedView.h"

@interface MyRecommendatViewController ()<UITableViewDelegate,UITableViewDataSource>{
    PopMenu *_popMenu;
    SharedView *_sharedView;
}

@property (strong, nonatomic) UIView *viewForHead;
@property (strong, nonatomic) UIView *viewForMidOne;
@property (strong, nonatomic) UIView *viewForMidTwo;
@property (strong, nonatomic) UILabel *labelForMidOne;
@property (strong, nonatomic) UILabel *labelForMidTwo;

@property (strong, nonatomic) UILabel *labelForGuessSum;/*预计总收益*/
@property (strong, nonatomic) UILabel *willHaveReward;/*即将获得的奖励*/
@property (strong, nonatomic) UILabel *haveHaveReward;/*已经获得的奖励*/
@property (strong, nonatomic) UILabel *myRecommandNumber;/*我的推荐码*/
@property (strong, nonatomic) UILabel *haveRecommandedNumebr;/*已经推荐的人数*/
@property (strong, nonatomic) UITableView *tableViewForList;/*推荐人列表*/
@property (nonatomic, strong) NSMutableArray *arrayForModel;
@property (nonatomic, copy) NSString *invitationcode;//我的推荐码
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yujishouyiHeight;//预计获得总收益距离顶部距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelJinHeight;//金额距离预计总收益距离

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForHeaderConstraint;//头部高度
@end

@implementation MyRecommendatViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MyRecommendatViewController"];
    self.tabBarController.tabBar.hidden = YES;
    
    UIImage *shareImage = [[UIImage imageNamed:@"icon_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:shareImage style:UIBarButtonItemStylePlain target:self action:@selector(clickSharedBtnAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MyRecommendatViewController"];
}

- (void)getNetDataMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"My/invitation" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSString *invitationWill = [obj[@"data"] objectForKey:@"invitation_future"];
            if ([self isNullString:invitationWill]) {
                invitationWill = @"0.00";
            }
            _willHaveReward.text = [NSString stringWithFormat:@"￥%@",invitationWill];
            NSString *invitationHave = [obj[@"data"] objectForKey:@"invitation_has"];
            if ([self isNullString:invitationHave]) {
                invitationHave = @"0.00";
            }
            _haveHaveReward.text = [NSString stringWithFormat:@"￥%@", invitationHave];
            _labelForGuessSum.text = [NSString stringWithFormat:@"%.2f", [invitationWill floatValue] + [invitationHave floatValue]];
            [self getHaveInvitatedList];
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

- (void)getHaveInvitatedList {
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];//8996
    [manager postDataWithUrlActionStr:@"User/invite" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _arrayForModel = [[NSMutableArray alloc]init];
            NSArray *arrayForList = obj[@"data"];
            _haveRecommandedNumebr.text = [NSString stringWithFormat:@"%ld人",(long)arrayForList.count];
            [_tableViewForList mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(RESIZE_UI(60)*arrayForList.count);
            }];
            for (int i=0; i<arrayForList.count; i++) {
                NSDictionary *dicForModel = arrayForList[i];
                MyReCommandModel *myRecommandModel = [MyReCommandModel mj_objectWithKeyValues:dicForModel];
                [_arrayForModel addObject:myRecommandModel];
            }
            [_tableViewForList reloadData];
            [SVProgressHUD dismiss];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的推荐";
    
    self.view.backgroundColor = RGBA(238, 238, 238, 1.0);
    
    UIScrollView *mainScrollView = [[UIScrollView alloc]init];
    mainScrollView.bounces = NO;
    [self.view addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(49);
    }];
    
    UIView *mainView = [[UIView alloc]init];
    mainView.backgroundColor = RGBA(238, 238, 238, 1.0);
    [mainScrollView addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    _viewForHead = [[UIView alloc]init];
    _viewForHead.backgroundColor = RGBA(0, 108, 175, 1.0);
    [mainView addSubview:_viewForHead];
    [_viewForHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView.mas_top);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_equalTo(RESIZE_UI(190));
    }];
    
    UILabel *guessGetLabel = [[UILabel alloc]init];
    guessGetLabel.text = @"预计获得总收益(元)";
    guessGetLabel.textColor = [UIColor whiteColor];
    guessGetLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    [_viewForHead addSubview:guessGetLabel];
    [guessGetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewForHead.mas_top).with.offset(RESIZE_UI(14));
        make.centerX.equalTo(_viewForHead.mas_centerX);
    }];
    
    _labelForGuessSum = [[UILabel alloc]init];
    _labelForGuessSum.font = [UIFont systemFontOfSize:RESIZE_UI(64)];
    _labelForGuessSum.text = @"0";
    _labelForGuessSum.textColor = [UIColor whiteColor];
    [_viewForHead addSubview:_labelForGuessSum];
    [_labelForGuessSum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(guessGetLabel.mas_bottom).with.offset(RESIZE_UI(14));
        make.centerX.equalTo(_viewForHead.mas_centerX);
    }];
    
    UIButton *checkRuleButton = [[UIButton alloc]init];
    [checkRuleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkRuleButton setTitle:@"查看推荐好友奖励规则" forState:UIControlStateNormal];
    checkRuleButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    [checkRuleButton addTarget:self action:@selector(checkRecommendRule) forControlEvents:UIControlEventTouchUpInside];
    [_viewForHead addSubview:checkRuleButton];
    [checkRuleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labelForGuessSum.mas_bottom).with.offset(RESIZE_UI(28));
        make.right.equalTo(_viewForHead.mas_right).with.offset(RESIZE_UI(-12));
        make.width.mas_offset(RESIZE_UI(123));
        make.height.mas_offset(RESIZE_UI(12));
    }];
    
    UIView *middleView = [[UIView alloc]init];
    middleView.backgroundColor = RGBA(0, 80, 134, 1.0);
    [mainView addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewForHead.mas_bottom);
        make.height.mas_offset(RESIZE_UI(64));
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
    }];
    
    _viewForMidOne = [[UIView alloc]init];
    _viewForMidOne.backgroundColor = [UIColor clearColor];
    [middleView addSubview:_viewForMidOne];
    [_viewForMidOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView.mas_top);
        make.left.equalTo(middleView.mas_left);
        make.width.mas_offset(SCREEN_WIDTH/2-0.5);
        make.bottom.equalTo(middleView.mas_bottom);
    }];
    
    _labelForMidOne = [[UILabel alloc]init];
    _labelForMidOne.text = @"即将获得的奖励";
    _labelForMidOne.textColor = RGBA(129, 170, 197, 1.0);
    _labelForMidOne.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    [_viewForMidOne addSubview:_labelForMidOne];
    [_labelForMidOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewForMidOne.mas_top).with.offset(RESIZE_UI(11));
        make.centerX.equalTo(_viewForMidOne.mas_centerX);
    }];
    
    _willHaveReward = [[UILabel alloc]init];
    _willHaveReward.textColor = [UIColor whiteColor];
    _willHaveReward.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    [_viewForMidOne addSubview:_willHaveReward];
    [_willHaveReward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labelForMidOne.mas_bottom).with.offset(RESIZE_UI(9));
        make.centerX.equalTo(_viewForMidOne);
    }];
    
    UILabel *labelLine = [[UILabel alloc]init];
    labelLine.backgroundColor = RGBA(99, 163, 204, 1.0);
    [middleView addSubview:labelLine];
    [labelLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(middleView.mas_centerX);
        make.centerY.equalTo(middleView.mas_centerY);
        make.height.mas_offset(RESIZE_UI(50));
        make.width.mas_offset(1);
    }];
    
    _viewForMidTwo = [[UIView alloc]init];
    _viewForMidTwo.backgroundColor = [UIColor clearColor];
    [middleView addSubview:_viewForMidTwo];
    [_viewForMidTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView.mas_top);
        make.bottom.equalTo(middleView.mas_bottom);
        make.right.equalTo(middleView.mas_right);
        make.width.mas_offset(RESIZE_UI(SCREEN_WIDTH/2-0.5));
    }];
    
    _labelForMidTwo = [[UILabel alloc]init];
    _labelForMidTwo.text = @"已经获得的奖励";
    _labelForMidTwo.textColor = RGBA(129, 170, 197, 1.0);
    _labelForMidTwo.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    [_viewForMidTwo addSubview:_labelForMidTwo];
    [_labelForMidTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewForMidTwo.mas_top).with.offset(RESIZE_UI(11));
        make.centerX.equalTo(_viewForMidTwo.mas_centerX);
    }];
    
    _haveHaveReward = [[UILabel alloc]init];
    _haveHaveReward.textColor = [UIColor whiteColor];
    _haveHaveReward.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    [_viewForMidTwo addSubview:_haveHaveReward];
    [_haveHaveReward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labelForMidTwo.mas_bottom).with.offset(RESIZE_UI(9));
        make.centerX.equalTo(_viewForMidTwo);
    }];
    
    UIView *myCodeView = [[UIView alloc]init];
    myCodeView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:myCodeView];
    [myCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView.mas_bottom).with.offset(RESIZE_UI(6));
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(45));
    }];
    
    UILabel *myCodeLabel = [[UILabel alloc]init];
    myCodeLabel.text = @"我的推荐码:";
    myCodeLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    myCodeLabel.textColor = RGBA(102, 102, 102, 1.0);
    [myCodeView addSubview:myCodeLabel];
    [myCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(myCodeView);
        make.left.equalTo(myCodeView.mas_left).with.offset(RESIZE_UI(12));
    }];

    _invitationcode = [SingletonManager sharedManager].userModel.invitationcode;
    _myRecommandNumber = [[UILabel alloc]init];
    _myRecommandNumber.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    _myRecommandNumber.text = _invitationcode;
    [myCodeView addSubview:_myRecommandNumber];
    [_myRecommandNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(myCodeView.mas_centerY);
        make.right.equalTo(myCodeView.mas_right).with.offset(RESIZE_UI(-12));
    }];
    
    UIView *haveRecommendedView = [[UIView alloc]init];
    haveRecommendedView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:haveRecommendedView];
    [haveRecommendedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myCodeView.mas_bottom).with.offset(RESIZE_UI(6));
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(45));
    }];
    
    UILabel *recommendLabel = [[UILabel alloc]init];
    recommendLabel.text = @"已推荐人数:";
    recommendLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    recommendLabel.textColor = RGBA(102, 102, 102, 1.0);
    [haveRecommendedView addSubview:recommendLabel];
    [recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(haveRecommendedView);
        make.left.equalTo(haveRecommendedView.mas_left).with.offset(RESIZE_UI(12));
    }];
    
    _haveRecommandedNumebr = [[UILabel alloc]init];
    [haveRecommendedView addSubview:_haveRecommandedNumebr];
    [_haveRecommandedNumebr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(haveRecommendedView.mas_centerY);
        make.right.equalTo(haveRecommendedView.mas_right).with.offset(RESIZE_UI(-12));
    }];
    
    _tableViewForList = [[UITableView alloc]init];
    _tableViewForList.tableFooterView = [[UIView alloc]init];
    _tableViewForList.delegate = self;
    _tableViewForList.dataSource = self;
    [_tableViewForList registerNib:[UINib nibWithNibName:@"MyRecommandTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyRecommandTableViewCell"];
    _tableViewForList.separatorStyle = UITableViewCellSelectionStyleNone;
    [mainView addSubview:_tableViewForList];
    [_tableViewForList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(haveRecommendedView.mas_bottom);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.bottom.equalTo(mainView.mas_bottom).with.offset(-1);
    }];
    
    [self getNetDataMethod];
}

- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

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
        if (_invitationcode) {
            NSString *contentStr = [NSString stringWithFormat:@"使用我的旺马财富推荐码 %@", _invitationcode];
            NSString *urlStr = [NSString stringWithFormat:@"http://m.wmjr888.com/?invitationcode=%@#login-register",_invitationcode];
            [sharedManager shareContent:sender withTitle:@"这是一个值得信赖的的投资理财平台" andContent:contentStr andUrl:urlStr];
            
        } else {
            [[SingletonManager sharedManager] alert1PromptInfo:@"推荐码获取失败,请重新分享"];
        }
    }];
}

/*遮盖消失*/
- (void)tapPopAction {
    [_popMenu dismissMenu];
}

#pragma mark - 查看推荐好友规则
- (void)checkRecommendRule {
    FRuleViewController *frule = [[FRuleViewController alloc] init];
    [self.navigationController pushViewController:frule animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(60);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayForModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyRecommandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRecommandTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    if (row%2 == 0) {
        cell.backgroundColor = RGBA(242, 242, 242, 1.0);
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
//    cell.myRecommandModel = _arrayForModel[row];
    cell.myRecommandModel = [_arrayForModel objectAtIndexCheck:row];
    return cell;
    
}

- (BOOL) isNullString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
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
