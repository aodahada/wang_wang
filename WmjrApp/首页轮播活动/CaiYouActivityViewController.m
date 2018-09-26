//
//  CaiYouActivityViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/4/9.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "CaiYouActivityViewController.h"
#import "PopMenu.h"
#import "SharedView.h"

@interface CaiYouActivityViewController (){
    PopMenu *_popMenu;
    SharedView *_sharedView;
}

@end

@implementation CaiYouActivityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"规则说明";
    
    UIScrollView *mainScrollView = [[UIScrollView alloc]init];
    mainScrollView.backgroundColor = [UIColor whiteColor];
    mainScrollView.bounces = NO;
    [self.view addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *mainView = [[UIView alloc]init];
    mainView.backgroundColor = [UIColor whiteColor];
    [mainScrollView addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"财友圈详情页"];
    [mainView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView.mas_top);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(SCREEN_WIDTH*3078/1242);
    }];
    
    [mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageView.mas_bottom);
    }];
    
    UIButton *ruleButton = [[UIButton alloc]init];
    [ruleButton addTarget:self action:@selector(inviteFriendMethod) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:ruleButton];
    [ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(mainView.mas_bottom).with.offset(-RESIZE_UI(10));
        make.right.equalTo(mainView.mas_right).with.offset(-RESIZE_UI(50));
        make.left.equalTo(mainView.mas_left).with.offset(RESIZE_UI(50));
        make.height.mas_offset(RESIZE_UI(70));
    }];
    
}

//- (void)viewWillDisappear:(BOOL)animated {
//    /*  设置颜色 */
//    self.navigationController.navigationBar.barTintColor = NAVBARCOLOR;
//    /*  设置字体颜色 */
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
//    /* 渲染颜色 */
//    self.navigationController.navigationBar.tintColor = NAVBARCOLOR;
//    /* 返回 */
//    UIImage *image = [[UIImage imageNamed:@"arrow_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
//    self.navigationItem.leftBarButtonItem = backButton;
//}

- (void)inviteFriendMethod {
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
            NSString *contentStr = [NSString stringWithFormat:@"使用我的旺马财富推荐码 %@", [SingletonManager sharedManager].userModel.invitationcode];
            NSString *urlStr = [NSString stringWithFormat:@"http://m.wangmacaifu.com/#/register/wmcf-%@",[SingletonManager sharedManager].userModel.invitationcode];
            [sharedManager shareContent:sender withTitle:@"这是一个值得信赖的的出借平台" andContent:contentStr andUrl:urlStr];
            
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
