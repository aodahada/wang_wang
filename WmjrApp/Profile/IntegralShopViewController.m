//
//  IntegralShopViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/14.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "IntegralShopViewController.h"
#import "StoreClassCollectionReusableView.h"

@interface IntegralShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *classCollectionView;
@property (nonatomic, strong) UIScrollView *scrollViewForCollect;
@property (nonatomic, strong) UIView *viewForScroll;

@end

@implementation IntegralShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"积分商城";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollViewForCollect = [[UIScrollView alloc]init];
    _scrollViewForCollect.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollViewForCollect];
    [_scrollViewForCollect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _viewForScroll = [[UIView alloc]init];
    _viewForScroll.backgroundColor = RGBA(238, 240, 242, 1.0);
    [_scrollViewForCollect addSubview:_viewForScroll];
    [_viewForScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollViewForCollect);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    UIView *topView1 = [[UIView alloc]init];
    topView1.backgroundColor = [UIColor whiteColor];
    [_viewForScroll addSubview:topView1];
    [topView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewForScroll.mas_top);
        make.left.equalTo(_viewForScroll.mas_left);
        make.right.equalTo(_viewForScroll.mas_right);
        make.height.mas_equalTo(RESIZE_UI(148));
    }];
    
    //头像
    UIImageView *headImage = [[UIImageView alloc]init];
    [headImage sd_setImageWithURL:[NSURL URLWithString:[SingletonManager sharedManager].userModel.photourl] placeholderImage:[UIImage imageNamed:@"image_head"]];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = RESIZE_UI(50)/2;
    [topView1 addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView1.mas_centerY);
        make.left.equalTo(topView1.mas_left).with.offset(RESIZE_UI(30));
        make.width.height.mas_equalTo(RESIZE_UI(50));
    }];
    
    //昵称
    UILabel *nickLabel = [[UILabel alloc]init];
    nickLabel.text = [SingletonManager sharedManager].userModel.name;
    nickLabel.font = [UIFont systemFontOfSize:RESIZE_UI(20)];
    [topView1 addSubview:nickLabel];
    [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView1.mas_centerY);
        make.left.equalTo(headImage.mas_right).with.offset(RESIZE_UI(10));
    }];
    
    UILabel *intergralTitle = [[UILabel alloc]init];
    intergralTitle.text = @"积分";
    intergralTitle.textColor = RGBA(153, 153, 153, 1.0);
    intergralTitle.font = [UIFont systemFontOfSize:RESIZE_UI(20)];
    [topView1 addSubview:intergralTitle];
    [intergralTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView1.mas_centerY);
        make.right.equalTo(topView1.mas_right).with.offset(-RESIZE_UI(10));
    }];
    
    UILabel *intergralNumber = [[UILabel alloc]init];
    intergralNumber.text = @"365";
    intergralNumber.textColor = RGBA(255, 88, 26, 1.0);
    intergralNumber.font = [UIFont systemFontOfSize:RESIZE_UI(24)];
    [topView1 addSubview:intergralNumber];
    [intergralNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView1.mas_centerY);
        make.right.equalTo(intergralTitle.mas_left).with.offset(-RESIZE_UI(14));
    }];
    
    UIView *topView2 = [[UIView alloc]init];
    topView2.backgroundColor = [UIColor whiteColor];
    [_viewForScroll addSubview:topView2];
    [topView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView1.mas_bottom);
        make.left.equalTo(_viewForScroll.mas_left);
        make.right.equalTo(_viewForScroll.mas_right);
        make.height.mas_equalTo(RESIZE_UI(148));
    }];
    
    UIView *top2LeftView = [[UIView alloc]init];
    top2LeftView.backgroundColor = [UIColor whiteColor];
    [topView2 addSubview:top2LeftView];
    [top2LeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView2.mas_top);
        make.left.equalTo(topView2.mas_left);
        make.bottom.equalTo(topView2.mas_bottom);
        make.width.mas_offset(RESIZE_UI(SCREEN_WIDTH/2));
    }];
    
//    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
//    self.classCollectionView = collectionView;
//    self.classCollectionView.scrollEnabled = NO;
//    self.classCollectionView.backgroundColor = [UIColor whiteColor];
//    [self.classCollectionView registerClass:[ProductClassCollectionViewCell class] forCellWithReuseIdentifier:@"ProductClassCollectionViewCell"];
//    [self.classCollectionView registerNib:[UINib nibWithNibName:@"ProductClassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProductClassCollectionViewCell"];
//    //    [self.classCollectionView registerNib:[UINib nibWithNibName:@"StoreClassCollectionReusableView" bundle:nil]
//    //               forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//    //                      withReuseIdentifier:@"StoreClassCollectionReusableView"];//header注册
//    [self.classCollectionView registerClass:[StoreClassCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StoreClassCollectionReusableView"];
//    self.classCollectionView.delegate = self;
//    self.classCollectionView.dataSource = self;
//    self.classCollectionView.backgroundColor = [UIColor whiteColor];
//    self.classCollectionView.showsVerticalScrollIndicator = NO;
//    self.classCollectionView.showsHorizontalScrollIndicator = NO;
//    [self.viewForScroll addSubview:self.classCollectionView];
//    [self.classCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.viewForScroll.mas_left);
//        make.top.equalTo(self.headPhotoImageView.mas_bottom);
//        make.right.equalTo(self.viewForScroll.mas_right);
//        make.bottom.equalTo(self.viewForScroll.mas_bottom);
//    }];
    
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
