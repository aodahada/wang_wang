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
#import "Shared1View.h"

@interface MyRecommendatViewController ()<UITableViewDelegate,UITableViewDataSource>{
    PopMenu *_popMenu;
    Shared1View *_sharedView;
}

@property (weak, nonatomic) IBOutlet UIView *viewForHead;
@property (weak, nonatomic) IBOutlet UIView *viewForMidOne;
@property (weak, nonatomic) IBOutlet UIView *viewForMidTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelForMidOne;
@property (weak, nonatomic) IBOutlet UILabel *labelForMidTwo;

@property (weak, nonatomic) IBOutlet UILabel *labelForGuessSum;/*预计总收益*/
@property (weak, nonatomic) IBOutlet UILabel *willHaveReward;/*即将获得的奖励*/
@property (weak, nonatomic) IBOutlet UILabel *haveHaveReward;/*已经获得的奖励*/
@property (weak, nonatomic) IBOutlet UILabel *myRecommandNumber;/*我的推荐码*/
@property (weak, nonatomic) IBOutlet UILabel *haveRecommandedNumebr;/*已经推荐的人数*/
@property (weak, nonatomic) IBOutlet UITableView *tableViewForList;/*推荐人列表*/
@property (nonatomic, strong) NSMutableArray *arrayForModel;
@property (nonatomic, copy) NSString *invitationcode;//我的推荐码
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yujishouyiHeight;//预计获得总收益距离顶部距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelJinHeight;//金额距离预计总收益距离

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForHeaderConstraint;//头部高度
@end

@implementation MyRecommendatViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    self.view.backgroundColor = RGBA(239, 239, 239, 1.0);
    /*  设置颜色 */
    self.navigationController.navigationBar.barTintColor = RGBA(0, 108, 175, 1.0);
    /*  设置字体颜色 */
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    /* 渲染颜色 */
    self.navigationController.navigationBar.tintColor = RGBA(0, 108, 175, 1.0);
    
    /*  去掉边线 */
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"piggy"] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *image = [[UIImage imageNamed:@"arrow_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    
    UIImage *shareImage = [[UIImage imageNamed:@"icon_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:shareImage style:UIBarButtonItemStylePlain target:self action:@selector(clickSharedBtnAction)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"My/invitation" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSString *invitationWill = [obj[@"data"] objectForKey:@"invitation_future"];
            _willHaveReward.text = [NSString stringWithFormat:@"￥%@",invitationWill];
            NSString *invitationHave = [obj[@"data"] objectForKey:@"invitation_has"];
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
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"User/invite" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _arrayForModel = [[NSMutableArray alloc]init];
            NSArray *arrayForList = obj[@"data"];
            _haveRecommandedNumebr.text = [NSString stringWithFormat:@"%ld人",(long)arrayForList.count];
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
    _heightForHeaderConstraint.constant = RESIZE_UI(240);
    _yujishouyiHeight.constant = RESIZE_UI(35);
    _labelJinHeight.constant = RESIZE_UI(30);
    self.view.backgroundColor = RGBA(238, 238, 238, 1.0);
    _viewForHead.backgroundColor = RGBA(0, 108, 175, 1.0);
    _viewForMidOne.backgroundColor = RGBA(0, 102, 166, 1.0);
    _viewForMidTwo.backgroundColor = RGBA(0, 102, 166, 1.0);
    _labelForMidOne.textColor = RGBA(171, 199, 214, 1.0);
    _labelForMidTwo.textColor = RGBA(171, 199, 214, 1.0);
    _invitationcode = [[NSUserDefaults standardUserDefaults] objectForKey:@"invitationcode"];
    _myRecommandNumber.text = _invitationcode;
    _tableViewForList.delegate = self;
    _tableViewForList.dataSource = self;
    [_tableViewForList registerNib:[UINib nibWithNibName:@"MyRecommandTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyRecommandTableViewCell"];
    _tableViewForList.separatorStyle = UITableViewCellSelectionStyleNone;
}

- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//响应点击分享的方法
- (void)clickSharedBtnAction {
    NSLog(@"-------点击分享----");
    _popMenu = [[PopMenu alloc] init];
    _popMenu.dimBackground = YES;
    _popMenu.coverNavigationBar = YES;
    _sharedView = [[Shared1View alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 75, RESIZE_UI(100))];
    _sharedView.layer.cornerRadius = 8;
    [_popMenu addSubview:_sharedView];
    [_popMenu showInRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _sharedView.center = _popMenu.center;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPopAction)];
    [_popMenu addGestureRecognizer:tap];
    
    [_sharedView callShared1BtnEventBlock:^(UIButton *sender) {
        [_popMenu dismissMenu];
        SharedManager *sharedManager = [[SharedManager alloc] init];
        if (_invitationcode) {
            NSString *contentStr = [NSString stringWithFormat:@"使用我的旺马财富推荐码 %@", _invitationcode];
            NSString *urlStr = [NSString stringWithFormat:@"http://wmjr888.com/home/download/app/code/%@", _invitationcode];
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
- (IBAction)checkRecommendRule:(id)sender {
    FRuleViewController *frule = [[FRuleViewController alloc] init];
    [self.navigationController pushViewController:frule animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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
    cell.myRecommandModel = _arrayForModel[row];
    return cell;
    
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
