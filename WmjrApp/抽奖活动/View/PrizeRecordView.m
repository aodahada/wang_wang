//
//  PrizeRecordView.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/12/14.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "PrizeRecordView.h"
#import "PrizeRecordTableViewCell.h"
#import "PrizeRecordModel.h"

@interface PrizeRecordView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *prizeRecordBottomView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *prizeWhiteView;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UITableView *recordTableView;

@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UILabel *xuhao;
@property (nonatomic, strong) UILabel *prizeName;
@property (nonatomic, strong) UILabel *prizeTime;

@property (nonatomic, strong) NSArray *prizeArray;

@end

@implementation PrizeRecordView

- (instancetype)initWithPrizeRecordArray:(NSMutableArray *)prizeRecordArray {
    self = [super init];
    if (self) {
        _prizeArray = [prizeRecordArray copy];
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAllMethod)];
        [_backView addGestureRecognizer:_tap];
        
        _prizeRecordBottomView = [[UIView alloc]init];
        _prizeRecordBottomView.backgroundColor = RGBA(232, 84, 102, 1.0);
        _prizeRecordBottomView.layer.cornerRadius = RESIZE_UI(20);
        [_backView addSubview:_prizeRecordBottomView];
        [_prizeRecordBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_backView.mas_centerX);
            make.centerY.equalTo(_backView.mas_centerY);
            make.width.height.mas_offset(RESIZE_UI(280));
        }];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"中奖纪录";
        [_titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(20)]];
        _titleLabel.textColor = [UIColor whiteColor];
        [_prizeRecordBottomView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_prizeRecordBottomView.mas_top).with.offset(RESIZE_UI(20));
            make.centerX.equalTo(_prizeRecordBottomView.mas_centerX);
        }];
        
        _prizeWhiteView = [[UIView alloc]init];
        _prizeWhiteView.backgroundColor = [UIColor whiteColor];
        _prizeWhiteView.layer.cornerRadius = RESIZE_UI(10);
        [_prizeRecordBottomView addSubview:_prizeWhiteView];
        [_prizeWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).with.offset(RESIZE_UI(20));
            make.bottom.equalTo(_prizeRecordBottomView.mas_bottom).with.offset(-RESIZE_UI(40));
            make.left.equalTo(_prizeRecordBottomView.mas_left).with.offset(RESIZE_UI(20));
            make.right.equalTo(_prizeRecordBottomView.mas_right).with.offset(-RESIZE_UI(20));
        }];
        
        _xuhao = [[UILabel alloc]init];
        _xuhao.text = @"序号";
        _xuhao.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        [_prizeWhiteView addSubview:_xuhao];
        [_xuhao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_prizeWhiteView.mas_top).with.offset(RESIZE_UI(10));
            make.left.equalTo(_prizeWhiteView.mas_left).with.offset(RESIZE_UI(5));
        }];
        
        _prizeName = [[UILabel alloc]init];
        _prizeName.text = @"奖品名称";
        _prizeName.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        [_prizeWhiteView addSubview:_prizeName];
        [_prizeName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_xuhao.mas_centerY);
            make.left.equalTo(_xuhao.mas_right).with.offset(RESIZE_UI(15));
        }];
        
        _prizeTime = [[UILabel alloc]init];
        _prizeTime.text = @"中奖时间";
        _prizeTime.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        [_prizeWhiteView addSubview:_prizeTime];
        [_prizeTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_xuhao.mas_centerY);
            make.left.equalTo(_prizeName.mas_right).with.offset(RESIZE_UI(30));
        }];
        
        if (prizeRecordArray.count == 0) {
            UILabel *noRecordLabel = [[UILabel alloc]init];
            noRecordLabel.text = @"暂无记录";
            [noRecordLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(25)]];
            [_prizeWhiteView addSubview:noRecordLabel];
            [noRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_prizeWhiteView.mas_centerX);
                make.centerY.equalTo(_prizeWhiteView.mas_centerY);
            }];
        } else {
            _recordTableView = [[UITableView alloc]init];
            _recordTableView.delegate = self;
            _recordTableView.dataSource = self;
            [_recordTableView registerClass:[PrizeRecordTableViewCell class] forCellReuseIdentifier:@"PrizeRecordTableViewCell"];
            [_prizeWhiteView addSubview:_recordTableView];
            [_recordTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_xuhao.mas_bottom);
                make.left.equalTo(_prizeWhiteView.mas_left);
                make.right.equalTo(_prizeWhiteView.mas_right);
                make.bottom.equalTo(_prizeWhiteView.mas_bottom).with.offset(-RESIZE_UI(10));
            }];
        }
        
        _closeButton = [[UIButton alloc]init];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"icon_guanbi"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeAllMethod) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_prizeRecordBottomView.mas_bottom).with.offset(RESIZE_UI(60));
            make.centerX.equalTo(_prizeRecordBottomView.mas_centerX);
            make.width.height.mas_offset(RESIZE_UI(38));
        }];
        
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _prizeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PrizeRecordTableViewCell *cell = [[PrizeRecordTableViewCell alloc]initWithPrizeRecordModel:_prizeArray[indexPath.row]];
    @weakify(self);
    cell.exchangePrize = ^(NSString *prizeId) {
        @strongify(self);
        [self exchangePrizeMethod:prizeId];
    };
    return cell;
}

#pragma mark - 兑换奖品
- (void)exchangePrizeMethod:(NSString *)prizeId {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Raffle/my" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid,@"id":prizeId} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                
            } title:@"兑换成功!" message:@"" cancelButtonName:@"好的" otherButtonTitles:nil, nil];
            
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

- (void)closeAllMethod {
    [_recordTableView removeFromSuperview];
    _recordTableView = nil;
    [_xuhao removeFromSuperview];
    _xuhao = nil;
    [_prizeName removeFromSuperview];
    _prizeName = nil;
    [_prizeTime removeFromSuperview];
    _prizeTime = nil;
    [_titleLabel removeFromSuperview];
    _titleLabel = nil;
    [_prizeWhiteView removeFromSuperview];
    _prizeWhiteView = nil;
    [_prizeRecordBottomView removeFromSuperview];
    _prizeRecordBottomView = nil;
    [_backView removeGestureRecognizer:_tap];
    _tap = nil;
    [_closeButton removeFromSuperview];
    _closeButton = nil;
    [_backView removeFromSuperview];
    _backView = nil;
    [self removeFromSuperview];
}

@end
