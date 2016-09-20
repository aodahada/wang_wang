//
//  TodayEarnViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/7/13.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "TodayEarnViewController.h"

@interface TodayEarnViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *todayEarn;
@property (weak, nonatomic) IBOutlet UIImageView *avatorImg;
@property (weak, nonatomic) IBOutlet UILabel *earnOfMonth;
@property (weak, nonatomic) IBOutlet UILabel *dayHighOfMonth;
@property (weak, nonatomic) IBOutlet UILabel *dayLowOfMonth;


@property (weak, nonatomic) IBOutlet UIButton *makeEarnBtn;

@end

@implementation TodayEarnViewController

- (void)configNagationBar {
    self.title = @"晒收益";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_btn_up.png"] style:UIBarButtonItemStyleDone target:self action:@selector(backBtnAction)];
    self.navigationItem.leftBarButtonItem = backBtn;
    self.navigationController.navigationBar.barTintColor = BASECOLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)backBtnAction {
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNagationBar];
    
//    self.view = [[[NSBundle mainBundle] loadNibNamed:@"TodayEarnViewController" owner:self options:nil] lastObject];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TodayEarnViewController" owner:self options:nil];
    UIView *nibView = [nib lastObject];
    ((UIScrollView *)self.view).contentSize = CGSizeMake(self.view.frame.size.width, nibView.frame.size.height);
    self.view.backgroundColor = BASECOLOR;
    _makeEarnBtn.layer.cornerRadius = 15;
    _makeEarnBtn.layer.masksToBounds = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
