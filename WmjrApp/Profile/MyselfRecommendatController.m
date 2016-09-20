//
//  MyselfRecommendatController.m
//  wangmajinrong
//
//  Created by 1 & 0 on 15/6/25.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "MyselfRecommendatController.h"
#import "FRuleViewController.h"
#import "PopMenu.h"
#import "Shared1View.h"

@interface MyselfRecommendatController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    
    UILabel *_accumulateEarn;
    UILabel *_willGetReward;
    UILabel *_gotReward;
    UIButton *_clickSharedBtn;
    
    PopMenu *_popMenu;
    Shared1View *_sharedView;
}

@property (nonatomic, copy) NSString *invitationcode;

@end

@implementation MyselfRecommendatController

- (void)configNagationBar {
    self.title = @"我的推荐";
}

- (UIView *)configHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RESIZE_UI(200))];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *earnIntroLable = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(15, 15, 195, 15))];
    earnIntroLable.text = @"预计获得总收益";
    earnIntroLable.textColor = AUXILY_COLOR;
    earnIntroLable.textAlignment = NSTextAlignmentLeft;
    earnIntroLable.font = [UIFont systemFontOfSize:RESIZE_UI(14.0f)];
    [headView addSubview:earnIntroLable];
    
    _accumulateEarn = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(15, 35, 195, 50))];
    _accumulateEarn.textColor = BASECOLOR;
    _accumulateEarn.textAlignment = NSTextAlignmentLeft;
    _accumulateEarn.font = [UIFont systemFontOfSize:RESIZE_UI(40.0f)];
    [headView addSubview:_accumulateEarn];
    
    UILabel *ruleIntroLable = [[UILabel alloc] initWithFrame:CGRectMake(RESIZE_UI(190), RESIZE_UI(90), RESIZE_UI(180), RESIZE_UI(15))];
    ruleIntroLable.text = @"查看推荐好友奖励规则>>";
    ruleIntroLable.textAlignment = NSTextAlignmentRight;
    ruleIntroLable.textColor = AUXILY_COLOR;
    ruleIntroLable.font = [UIFont systemFontOfSize:RESIZE_UI(12.0f)];
    [headView addSubview:ruleIntroLable];
    ruleIntroLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRule = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRuleAction)];
    [ruleIntroLable addGestureRecognizer:tapRule];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(RESIZE_UI(0), RESIZE_UI(125), SCREEN_WIDTH, RESIZE_UI(1))];
    line1.backgroundColor = AUXILY_COLOR;
    line1.alpha = .4;
    [headView addSubview:line1];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, RESIZE_UI(125), RESIZE_UI(1), RESIZE_UI(75))];
    line2.backgroundColor = AUXILY_COLOR;
    line2.alpha = .4;
    [headView addSubview:line2];
    
    UILabel *reward1Intro = [[UILabel alloc] initWithFrame:CGRectMake(RESIZE_UI(30), RESIZE_UI(140), RESIZE_UI(132), RESIZE_UI(20))];
    reward1Intro.text = @"即将获得的奖励";
    reward1Intro.textAlignment = NSTextAlignmentCenter;
    reward1Intro.textColor = AUXILY_COLOR;
    reward1Intro.font = [UIFont systemFontOfSize:RESIZE_UI(15.0f)];
    [headView addSubview:reward1Intro];
    
    UILabel *reward2Intro = [[UILabel alloc] initWithFrame:CGRectMake(RESIZE_UI(210), RESIZE_UI(140), RESIZE_UI(133), RESIZE_UI(20))];
    reward2Intro.text = @"已经获得的奖励";
    reward2Intro.textAlignment = NSTextAlignmentCenter;
    reward2Intro.textColor = AUXILY_COLOR;
    reward2Intro.font = [UIFont systemFontOfSize:RESIZE_UI(15.0f)];
    [headView addSubview:reward2Intro];
    
    _willGetReward = [[UILabel alloc] initWithFrame:CGRectMake(RESIZE_UI(65), RESIZE_UI(170), RESIZE_UI(62), RESIZE_UI(20))];
    _willGetReward.textAlignment = NSTextAlignmentCenter;
    _willGetReward.textColor = ORANGE_COLOR;
    _willGetReward.font = [UIFont systemFontOfSize:RESIZE_UI(15.0f)];
    [headView addSubview:_willGetReward];
    
    _gotReward = [[UILabel alloc] initWithFrame:CGRectMake(RESIZE_UI(245), RESIZE_UI(170), RESIZE_UI(63), RESIZE_UI(20))];
    _gotReward.textAlignment = NSTextAlignmentCenter;
    _gotReward.textColor = ORANGE_COLOR;
    _gotReward.font = [UIFont systemFontOfSize:RESIZE_UI(15.0f)];
    [headView addSubview:_gotReward];
    
    return headView;
}

/*点击推荐好友奖励规则*/
- (void)tapRuleAction {
    FRuleViewController *frule = [[FRuleViewController alloc] init];
    [self.navigationController pushViewController:frule animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"User/que" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _invitationcode = [obj[@"data"] objectForKey:@"invitationcode"];
            
            [_tableView reloadData];
        }
    }];
    
    [manager postDataWithUrlActionStr:@"My/invitation" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _willGetReward.text = [NSString stringWithFormat:@"%@元", [obj[@"data"] objectForKey:@"invitation_future"]];
            _gotReward.text = [NSString stringWithFormat:@"%@元", [obj[@"data"] objectForKey:@"invitation_has"]];
            _accumulateEarn.text = [NSString stringWithFormat:@"%.2f", [_willGetReward.text floatValue] + [_gotReward.text floatValue]];
            [_tableView reloadData];
        }
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configNagationBar];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = [self configHeadView];
    
    _clickSharedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clickSharedBtn.frame = RESIZE_FRAME(CGRectMake(135, 370, 107, 27));
    _clickSharedBtn.layer.cornerRadius = 5;
    _clickSharedBtn.layer.masksToBounds = YES;
    [_clickSharedBtn setBackgroundColor:BASECOLOR];
    [_clickSharedBtn setTitle:@"点击分享" forState:UIControlStateNormal];
    _clickSharedBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_clickSharedBtn setTitleColor:VIEWBACKCOLOR forState:UIControlStateNormal];
    [_clickSharedBtn addTarget:self action:@selector(clickSharedBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clickSharedBtn];
    
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

#pragma mark - UITableView -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"推荐码：";
    cell.detailTextLabel.text = _invitationcode;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = TITLE_COLOR;
    cell.detailTextLabel.textColor = AUXILY_COLOR;
    cell.textLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14.0f)];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15.0f)];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return RESIZE_UI(5);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return RESIZE_UI(.1);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *introView = [[UIView alloc] init];
    UILabel *introLable = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(37, 15, 300, 60))];
    introLable.text = @"亲，向你推荐我最喜欢的理财平台“旺马财富”，项目起投门槛低，年化利率高。小伙伴快来围观吧！";
    introLable.textColor = AUXILY_COLOR;
    introLable.font = [UIFont systemFontOfSize:RESIZE_UI(12.0f)];
    introLable.textAlignment = NSTextAlignmentLeft;
    introLable.numberOfLines = 0;
    [introView addSubview:introLable];
    
    return introView;
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
