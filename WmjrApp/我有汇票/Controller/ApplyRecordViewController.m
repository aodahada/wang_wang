//
//  ApplyRecordViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/11/21.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "ApplyRecordViewController.h"
#import "ApplyRecordTableViewCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "ApplyDetailViewController.h"
#import "ApplyRocrdModel.h"

@interface ApplyRecordViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong)UIView *top1View;//状态栏
@property (nonatomic, strong)UIView *top2View;//navigationbar
@property (nonatomic, strong)UIView *top2ViewOne;//navigationbar
@property (nonatomic, strong)UIView *top2ViewSecond;//navigationbar
@property (nonatomic, strong)UIButton *changeState;//切换状态按钮
@property (nonatomic, strong)UIButton *checkContinueTitle;//审核中(上部)
@property (nonatomic, strong)UIButton *checkPassTitle;//审核通过(上部)
@property (nonatomic, strong)UIButton *checkFailTitle;//审核失败(上部)
@property (nonatomic, strong)UIImageView *checkContinueTitleImageView;//三角头(上部)
@property (nonatomic, strong)UIImageView *checkPassTitleImageView;//三角头(上部)
@property (nonatomic, strong)UIImageView *checkFailTitleImageView;//三角头(上部)
@property (nonatomic, strong)UIButton *checkContinue;//审核中
@property (nonatomic, strong)UIButton *checkPass;//审核通过
@property (nonatomic, strong)UIButton *checkFail;//审核失败
@property (nonatomic, strong)UIImageView *checkContinueImageView;//三角头
@property (nonatomic, strong)UIImageView *checkPassImageView;//三角头
@property (nonatomic, strong)UIImageView *checkFailImageView;//三角头
@property (nonatomic, strong)UIView *top3View;
@property (nonatomic, strong)UIView *viewMain;
@property (nonatomic, strong)UIScrollView *scrollViewMain;
@property (nonatomic, strong)UITableView *tableViewMain;

@property (nonatomic, strong)NSMutableArray *recordArray;



@end

@implementation ApplyRecordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请记录";
    self.view.backgroundColor = RGBA(238, 240, 242, 1.0);
    
    [self setUpLayout];
    [self getMessageMethod:@"0"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 网络请求
- (void)getMessageMethod:(NSString *)status {
    _recordArray = [[NSMutableArray alloc]init];
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Bill/lists" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid,@"status":status} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSArray *array = obj[@"data"];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic = array[i];
                ApplyRocrdModel *applyRecordModel = [ApplyRocrdModel mj_objectWithKeyValues:dic];
                [_recordArray addObject:applyRecordModel];
            }
            [SVProgressHUD dismiss];
            CGFloat height;
            if (_recordArray.count == 0) {
                height = RESIZE_UI(400);
            } else {
                height = RESIZE_UI(203+10)*_recordArray.count;
            }
            [_tableViewMain mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(height);
            }];
            [_tableViewMain reloadData];
            
            //重新处理界面
            if (_top2ViewSecond) {
                for(int i = 0;i<[_top2ViewSecond.subviews count];i++){
                    [_top2ViewSecond.subviews[i] removeFromSuperview];
                }
                [_top2ViewSecond removeFromSuperview];
                _top2ViewSecond = nil;
                [self setUpTop2ViewOne];
            }
            if (_top2ViewOne) {
                for(int i = 0;i<[_top2ViewOne.subviews count];i++){
                    _top2ViewOne.subviews[i].alpha = 1.0;
                }
            }
            
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

//navigationbar栏第一种
- (void)setUpTop2ViewOne {
    _top2ViewOne = [[UIView alloc]init];
    _top2ViewOne.backgroundColor = RGBA(0, 104, 178, 1.0);
    [self.view addSubview:_top2ViewOne];
    [_top2ViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_top1View.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(44));
    }];
    
    UIImageView *backImageViewOne = [[UIImageView alloc]init];
    backImageViewOne.image = [UIImage imageNamed:@"arrow_icon"];
    [_top2ViewOne addSubview:backImageViewOne];
    [backImageViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_top2ViewOne.mas_centerY);
        make.left.equalTo(_top2ViewOne.mas_left).with.offset(RESIZE_UI(12));
        make.width.mas_offset(RESIZE_UI(11.5));
        make.height.mas_offset(RESIZE_UI(21));
    }];
    
    UIButton *backButton = [[UIButton alloc]init];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton addTarget:self action:@selector(backViewMethod) forControlEvents:UIControlEventTouchUpInside];
    [_top2ViewOne addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_top2ViewOne.mas_top);
        make.left.equalTo(_top2ViewOne.mas_left);
        make.right.equalTo(backButton.mas_right).with.offset(RESIZE_UI(10));
        make.bottom.equalTo(_top2ViewOne.mas_bottom);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"申请记录";
    titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    titleLabel.textColor = [UIColor whiteColor];
    [_top2ViewOne addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_top2ViewOne.mas_centerY);
        make.centerX.equalTo(_top2ViewOne.mas_centerX);
    }];
    
//    _changeState = [[UIButton alloc]init];
//    [_changeState setBackgroundImage:[UIImage imageNamed:@"btn_qhwqy"] forState:UIControlStateNormal];
//    [_top2ViewOne addSubview:_changeState];
//    [_changeState mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(_top2ViewOne.mas_centerY);
//        make.right.equalTo(_top2ViewOne.mas_right);
//        make.width.mas_offset(RESIZE_UI(92));
//        make.height.mas_offset(RESIZE_UI(24));
//    }];
}

//navigationbar栏第二种
- (void)setUpTop2ViewSecond {
    _top2ViewSecond = [[UIView alloc]init];
    _top2ViewSecond.backgroundColor = RGBA(0, 104, 178, 1.0);
    [self.view addSubview:_top2ViewSecond];
    [_top2ViewSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_top1View.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(44));
    }];
    
    UIImageView *backImageViewTwo = [[UIImageView alloc]init];
    backImageViewTwo.image = [UIImage imageNamed:@"arrow_icon"];
    [_top2ViewSecond addSubview:backImageViewTwo];
    [backImageViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_top2ViewSecond.mas_centerY);
        make.left.equalTo(_top2ViewSecond.mas_left).with.offset(RESIZE_UI(12));
        make.width.mas_offset(RESIZE_UI(11.5));
        make.height.mas_offset(RESIZE_UI(21));
    }];
    
    UIButton *backButton = [[UIButton alloc]init];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton addTarget:self action:@selector(backViewMethod) forControlEvents:UIControlEventTouchUpInside];
    [_top2ViewSecond addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_top2ViewSecond.mas_top);
        make.left.equalTo(_top2ViewSecond.mas_left);
        make.right.equalTo(backButton.mas_right).with.offset(RESIZE_UI(10));
        make.bottom.equalTo(_top2ViewSecond.mas_bottom);
    }];
    
    _checkContinueTitle = [[UIButton alloc]init];
    [_checkContinueTitle setTitle:@"审核中" forState:UIControlStateNormal];
    [_checkContinueTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _checkContinueTitle.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [_checkContinueTitle addTarget:self action:@selector(checkContinueTitleMethod) forControlEvents:UIControlEventTouchUpInside];
    [_top2ViewSecond addSubview:_checkContinueTitle];
    [_checkContinueTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_top2ViewSecond.mas_centerY);
        make.left.equalTo(_top2ViewSecond.mas_left).with.offset(RESIZE_UI(48));
        make.width.mas_offset(RESIZE_UI(62));
        make.height.mas_offset(RESIZE_UI(21));
    }];
    
    _checkContinueTitleImageView = [[UIImageView alloc]init];
    _checkContinueTitleImageView.image = [UIImage imageNamed:@"Triangle"];
    _checkContinueTitleImageView.hidden = NO;
    [_top2ViewSecond addSubview:_checkContinueTitleImageView];
    [_checkContinueTitleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_top2ViewSecond.mas_bottom);
        make.centerX.equalTo(_checkContinueTitle.mas_centerX);
        make.width.mas_offset(RESIZE_UI(16));
        make.height.mas_offset(RESIZE_UI(10));
    }];
    
    _checkPassTitle = [[UIButton alloc]init];
    [_checkPassTitle setTitle:@"审核通过" forState:UIControlStateNormal];
    [_checkPassTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _checkPassTitle.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [_checkPassTitle addTarget:self action:@selector(checkPassTitleMethod) forControlEvents:UIControlEventTouchUpInside];
    [_top2ViewSecond addSubview:_checkPassTitle];
    [_checkPassTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_top2ViewSecond.mas_centerY);
        make.centerX.equalTo(_top2ViewSecond.mas_centerX);
        make.width.mas_offset(RESIZE_UI(62));
        make.height.mas_offset(RESIZE_UI(21));
    }];
    
    _checkPassTitleImageView = [[UIImageView alloc]init];
    _checkPassTitleImageView.image = [UIImage imageNamed:@"Triangle"];
    _checkPassTitleImageView.hidden = YES;
    [_top2ViewSecond addSubview:_checkPassTitleImageView];
    [_checkPassTitleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_top2ViewSecond.mas_bottom);
        make.centerX.equalTo(_checkPassTitle.mas_centerX);
        make.width.mas_offset(RESIZE_UI(16));
        make.height.mas_offset(RESIZE_UI(10));
    }];
    
    _checkFailTitle = [[UIButton alloc]init];
    [_checkFailTitle setTitle:@"审核失败" forState:UIControlStateNormal];
    [_checkFailTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _checkFailTitle.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [_checkFailTitle addTarget:self action:@selector(checkFailTitleMethod) forControlEvents:UIControlEventTouchUpInside];
    [_top2ViewSecond addSubview:_checkFailTitle];
    [_checkFailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_top2ViewSecond.mas_centerY);
        make.right.equalTo(_top2ViewSecond.mas_right).with.offset(-RESIZE_UI(41));
        make.width.mas_offset(RESIZE_UI(62));
        make.height.mas_offset(RESIZE_UI(21));
    }];
    
    _checkFailTitleImageView = [[UIImageView alloc]init];
    _checkFailTitleImageView.image = [UIImage imageNamed:@"Triangle"];
    _checkFailTitleImageView.hidden = YES;
    [_top2ViewSecond addSubview:_checkFailTitleImageView];
    [_checkFailTitleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_top2ViewSecond.mas_bottom);
        make.centerX.equalTo(_checkFailTitle.mas_centerX);
        make.width.mas_offset(RESIZE_UI(16));
        make.height.mas_offset(RESIZE_UI(10));
    }];

}

#pragma mark - 返回上一页
- (void)backViewMethod {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 上方三个按钮的点击方法
- (void)checkContinueTitleMethod {
    _checkContinueTitleImageView.hidden = NO;
    _checkPassTitleImageView.hidden = YES;
    _checkFailTitleImageView.hidden = YES;
    _checkContinueImageView.hidden = NO;
    _checkPassImageView.hidden = YES;
    _checkFailImageView.hidden = YES;
    [self getMessageMethod:@"0"];
}

- (void)checkPassTitleMethod {
    _checkContinueTitleImageView.hidden = YES;
    _checkPassTitleImageView.hidden = NO;
    _checkFailTitleImageView.hidden = YES;
    _checkContinueImageView.hidden = YES;
    _checkPassImageView.hidden = NO;
    _checkFailImageView.hidden = YES;
    [self getMessageMethod:@"1"];
}

- (void)checkFailTitleMethod {
    _checkContinueTitleImageView.hidden = YES;
    _checkPassTitleImageView.hidden = YES;
    _checkFailTitleImageView.hidden = NO;
    _checkContinueImageView.hidden = YES;
    _checkPassImageView.hidden = YES;
    _checkFailImageView.hidden = NO;
    [self getMessageMethod:@"2"];
}

- (void)setUpLayout {
    
    _top1View = [[UIView alloc]init];
    _top1View.backgroundColor = RGBA(0, 104, 178, 1.0);
    [self.view addSubview:_top1View];
    [_top1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(20));
    }];

    //navgationbar栏
    [self setUpTop2ViewOne];
    
    _scrollViewMain = [[UIScrollView alloc]init];
    _scrollViewMain.bounces = NO;
    _scrollViewMain.backgroundColor = RGBA(238, 240, 242, 1.0);
    _scrollViewMain.delegate = self;
    [self.view addSubview:_scrollViewMain];
    [_scrollViewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(RESIZE_UI(64));
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    _viewMain = [[UIView alloc]init];
    _viewMain.backgroundColor = RGBA(238, 240, 242, 1.0);
    [_scrollViewMain addSubview:_viewMain];
    [_viewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollViewMain);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    //三个分类按钮的部分
    _top3View = [[UIView alloc]init];
    _top3View.backgroundColor = RGBA(0, 104, 178, 1.0);
    [_viewMain addSubview:_top3View];
    [_top3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewMain.mas_top);
        make.left.equalTo(_viewMain.mas_left);
        make.right.equalTo(_viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(125));
    }];
    
    _checkContinue = [[UIButton alloc]init];
    [_checkContinue setBackgroundImage:[UIImage imageNamed:@"icon_shz"] forState:UIControlStateNormal];
    [_checkContinue addTarget:self action:@selector(checkContinueMethod) forControlEvents:UIControlEventTouchUpInside];
    [_top3View addSubview:_checkContinue];
    [_checkContinue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_top3View.mas_bottom).with.offset(-RESIZE_UI(20));
        make.height.mas_offset(RESIZE_UI(62));
        make.width.mas_offset(RESIZE_UI(47));
        make.left.equalTo(_top3View.mas_left).with.offset(RESIZE_UI(48));
    }];
    
    _checkContinueImageView = [[UIImageView alloc]init];
    _checkContinueImageView.image = [UIImage imageNamed:@"Triangle"];
    _checkContinueImageView.hidden = NO;
    [_top3View addSubview:_checkContinueImageView];
    [_checkContinueImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_top3View.mas_bottom);
        make.centerX.equalTo(_checkContinue.mas_centerX);
        make.width.mas_offset(RESIZE_UI(16));
        make.height.mas_offset(RESIZE_UI(10));
    }];
    
    _checkPass = [[UIButton alloc]init];
    [_checkPass setBackgroundImage:[UIImage imageNamed:@"icon_shtg"] forState:UIControlStateNormal];
    [_checkPass addTarget:self action:@selector(checkPassMethod) forControlEvents:UIControlEventTouchUpInside];
    [_top3View addSubview:_checkPass];
    [_checkPass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_top3View.mas_centerX);
        make.bottom.equalTo(_top3View.mas_bottom).with.offset(-RESIZE_UI(20));
        make.height.width.mas_offset(RESIZE_UI(62));
    }];
    
    _checkPassImageView = [[UIImageView alloc]init];
    _checkPassImageView.image = [UIImage imageNamed:@"Triangle"];
    _checkPassImageView.hidden = YES;
    [_top3View addSubview:_checkPassImageView];
    [_checkPassImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_top3View.mas_bottom);
        make.centerX.equalTo(_checkPass.mas_centerX);
        make.width.mas_offset(RESIZE_UI(16));
        make.height.mas_offset(RESIZE_UI(10));
    }];
    
    _checkFail = [[UIButton alloc]init];
    [_checkFail setBackgroundImage:[UIImage imageNamed:@"icon_shbh"] forState:UIControlStateNormal];
    [_checkFail addTarget:self action:@selector(checkFailMethod) forControlEvents:UIControlEventTouchUpInside];
    [_top3View addSubview:_checkFail];
    [_checkFail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_top3View.mas_right).with.offset(-RESIZE_UI(41));
        make.bottom.equalTo(_top3View.mas_bottom).with.offset(-RESIZE_UI(20));
        make.height.width.mas_offset(RESIZE_UI(62));
    }];
    
    _checkFailImageView = [[UIImageView alloc]init];
    _checkFailImageView.image = [UIImage imageNamed:@"Triangle"];
    _checkFailImageView.hidden = YES;
    [_top3View addSubview:_checkFailImageView];
    [_checkFailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_top3View.mas_bottom);
        make.centerX.equalTo(_checkFail.mas_centerX);
        make.width.mas_offset(RESIZE_UI(16));
        make.height.mas_offset(RESIZE_UI(10));
    }];
    
    _tableViewMain = [[UITableView alloc]init];
    _tableViewMain.delegate = self;
    _tableViewMain.dataSource = self;
    _tableViewMain.emptyDataSetSource = self;
    _tableViewMain.emptyDataSetDelegate = self;
    _tableViewMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewMain.scrollEnabled = NO;
    _tableViewMain.bounces = NO;
    _tableViewMain.backgroundColor = RGBA(238, 240, 242, 1.0);
    [_tableViewMain registerClass:[ApplyRecordTableViewCell class] forCellReuseIdentifier:@"ApplyRecordTableViewCell"];
    [_viewMain addSubview:_tableViewMain];
    [_tableViewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_top3View.mas_bottom);
        make.left.equalTo(_viewMain.mas_left).with.offset(RESIZE_UI(5));
        make.right.equalTo(_viewMain.mas_right).with.offset(-RESIZE_UI(5));
        make.height.mas_offset(RESIZE_UI(400));
    }];
    
    [_viewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_tableViewMain.mas_bottom);
    }];
    
}

#pragma mark - 下方三个按钮方法
- (void)checkContinueMethod {
    _checkContinueImageView.hidden = NO;
    _checkPassImageView.hidden = YES;
    _checkFailImageView.hidden = YES;
    _checkContinueTitleImageView.hidden = NO;
    _checkPassTitleImageView.hidden = YES;
    _checkFailTitleImageView.hidden = YES;
    _checkContinueImageView.hidden = NO;
    [self getMessageMethod:@"0"];
}

- (void)checkPassMethod {
    _checkContinueImageView.hidden = YES;
    _checkPassImageView.hidden = NO;
    _checkFailImageView.hidden = YES;
    _checkContinueTitleImageView.hidden = YES;
    _checkPassTitleImageView.hidden = NO;
    _checkFailTitleImageView.hidden = YES;
    [self getMessageMethod:@"1"];
}

- (void)checkFailMethod {
    _checkContinueImageView.hidden = YES;
    _checkPassImageView.hidden = YES;
    _checkFailImageView.hidden = NO;
    _checkContinueTitleImageView.hidden = YES;
    _checkPassTitleImageView.hidden = YES;
    _checkFailTitleImageView.hidden = NO;
    [self getMessageMethod:@"2"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _recordArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(203);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return RESIZE_UI(10);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = RGBA(238, 240, 242, 1.0);
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApplyRecordTableViewCell *cell = [[ApplyRecordTableViewCell alloc]initWithApplyRecordModel:_recordArray[indexPath.section]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.layer setMasksToBounds:YES];
    cell.layer.cornerRadius = 5.0f;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ApplyDetailViewController *applyDetailVC = [[ApplyDetailViewController alloc]init];
    applyDetailVC.applyRecordModel = _recordArray[indexPath.section];
    [self.navigationController pushViewController:applyDetailVC animated:YES];
}

#pragma mark  -scrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //处理上部隐藏问题
    CGFloat scrollviewY = scrollView.contentOffset.y;
//    NSLog(@"我的值:%.2f",scrollviewY);
    CGFloat alpha = (RESIZE_UI(100)-RESIZE_UI(scrollviewY)) / 100;
    if (alpha>0) {
        alpha = alpha;
    } else {
        alpha = 0;
    }
    _checkContinue.alpha = alpha;
    _checkContinueImageView.alpha = alpha;
    _checkPass.alpha = alpha;
    _checkPassImageView.alpha = alpha;
    _checkFail.alpha = alpha;
    _checkFailImageView.alpha = alpha;
    
    CGFloat topAlphe = 1-alpha;
    if (topAlphe>=1) {
        topAlphe = 1;
    } else {
        topAlphe = 1-alpha;
    }
    
    //当navigationbarOne存在时
    if (_top2ViewOne) {
        if (alpha<=0.5) {
            for(int i = 0;i<[_top2ViewOne.subviews count];i++){
                [_top2ViewOne.subviews[i] removeFromSuperview];
            }
            [_top2ViewOne removeFromSuperview];
            _top2ViewOne = nil;
            [self setUpTop2ViewSecond];
            for(int i = 0;i<[_top2ViewSecond.subviews count];i++){
                _top2ViewSecond.subviews[i].alpha = alpha;
            }
//            _top2ViewSecond.alpha = topAlphe;
        } else {
//            _top2ViewOne.alpha = alpha;
            for(int i = 0;i<[_top2ViewOne.subviews count];i++){
                _top2ViewOne.subviews[i].alpha = alpha;
            }
        }
    }

    //当navigationbarSecond存在时
    if (_top2ViewSecond) {
        if (topAlphe<=0.5) {
            for(int i = 0;i<[_top2ViewSecond.subviews count];i++){
                [_top2ViewSecond.subviews[i] removeFromSuperview];
            }
            [_top2ViewSecond removeFromSuperview];
            _top2ViewSecond = nil;
            [self setUpTop2ViewOne];
            for(int i = 0;i<[_top2ViewOne.subviews count];i++){
                _top2ViewOne.subviews[i].alpha = topAlphe;
            }
        } else {
            for(int i = 0;i<[_top2ViewSecond.subviews count];i++){
                _top2ViewSecond.subviews[i].alpha = topAlphe;
            }
        }
    }
    
}

#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"icon_zwjl"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无记录";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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
