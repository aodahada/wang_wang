//
//  MainRedBallView.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/9/26.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "MainRedBallView.h"
#import "MainRedTableViewCell.h"

@interface MainRedBallView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *watchRedBallButton;
@property (nonatomic, strong) UITableView *redBallTableView;
@property (nonatomic, strong) NSMutableArray *redPackageArray;

@end

@implementation MainRedBallView

- (instancetype)initWithRow:(NSMutableArray *)redBallArray {
    self = [super init];
    if (self) {
        _redPackageArray = [[NSMutableArray alloc]init];
        _redPackageArray = redBallArray;
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"恭喜您获得新的红包!"];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(RESIZE_UI(287));
            make.height.mas_offset(RESIZE_UI(36));
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(25));
        }];
        
        NSInteger tableHeight;
        NSInteger row = _redPackageArray.count;
        if (row == 1) {
            tableHeight = RESIZE_UI(131);
        } else if (row == 2) {
            tableHeight = RESIZE_UI(252);
        } else {
            tableHeight = RESIZE_UI(300);
        }
        
        UIView *tableBackView = [[UIView alloc]init];
        tableBackView.backgroundColor = RGBA(225, 64, 11, 1.0);
        [self addSubview:tableBackView];
        [tableBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(tableHeight);
            make.top.equalTo(_imageView.mas_bottom).with.offset(RESIZE_UI(17));
            make.centerX.equalTo(self.mas_centerX);
            make.width.mas_equalTo(self.mas_width);
        }];
        
        _redBallTableView = [[UITableView alloc]init];
        _redBallTableView.backgroundColor = RGBA(225, 64, 11, 1.0);
        _redBallTableView.delegate = self;
        _redBallTableView.dataSource = self;
        [tableBackView addSubview:_redBallTableView];
        [_redBallTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tableBackView.mas_top).with.offset(RESIZE_UI(10));
            make.left.equalTo(tableBackView.mas_left).with.offset(RESIZE_UI(13));
            make.right.equalTo(tableBackView.mas_right).with.offset(-RESIZE_UI(13));
            make.bottom.equalTo(tableBackView.mas_bottom);
        }];
        
        _watchRedBallButton = [[UIButton alloc]init];
        [_watchRedBallButton setBackgroundColor:RGBA(245, 166, 35, 1.0)];
        [_watchRedBallButton setTitle:@"查看红包" forState:UIControlStateNormal];
        [_watchRedBallButton addTarget:self action:@selector(watchRedBall) forControlEvents:UIControlEventTouchUpInside];
        _watchRedBallButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        [self addSubview:_watchRedBallButton];
        [_watchRedBallButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).with.offset(RESIZE_UI(-23));
            make.centerX.equalTo(self.mas_centerX);
            make.width.mas_offset(RESIZE_UI(282));
            make.height.mas_offset(RESIZE_UI(49));
        }];
    }
    return self;
}

- (void)watchRedBall {
    if (self.jumpToMyRed) {
        self.jumpToMyRed();
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _redPackageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(111);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = RGBA(225, 64, 11, 1.0);;
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RedPackageModel *redPackageModel = _redPackageArray[indexPath.section];
    MainRedTableViewCell *cell = [[MainRedTableViewCell alloc]initWithModel:redPackageModel andIsOut:NO];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
