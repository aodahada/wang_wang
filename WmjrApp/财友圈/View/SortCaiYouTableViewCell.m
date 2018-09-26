//
//  SortCaiYouTableViewCell.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/28.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "SortCaiYouTableViewCell.h"
#import "SortContaceModel.h"

@interface SortCaiYouTableViewCell()

@property (nonatomic, assign)NSInteger type_lei;
@property (nonatomic, strong)SortContaceModel *model;

@end

@implementation SortCaiYouTableViewCell

- (instancetype)initWithType:(NSInteger)type withRow:(NSInteger)row WithModel:(SortContaceModel *)sortModel {
    self = [super init];
    if (self) {
        _type_lei = type;
        _model = sortModel;
        if ([sortModel.is_myself isEqualToString:@"1"]) {
            UIImageView *sortImageView = [[UIImageView alloc]init];
            sortImageView.image = [UIImage imageNamed:@"icon_wdmc"];
            [self addSubview:sortImageView];
            [sortImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(8));
                make.width.mas_offset(RESIZE_UI(83));
                make.height.mas_offset(RESIZE_UI(27));
            }];
        } else {
            UILabel *indexLabel = [[UILabel alloc]init];
            indexLabel.text = [NSString stringWithFormat:@"%ld",(long)row+1];
            indexLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
            [self addSubview:indexLabel];
            [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(30));
            }];
        }
        
        UILabel *phoneLabel = [[UILabel alloc]init];
        NSString *mobileNumber = sortModel.name;
//        NSMutableString *phoneNum = [mobileNumber mutableCopy];
//        [phoneNum replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
//        phoneLabel.backgroundColor = [UIColor redColor];
        phoneLabel.text = mobileNumber;
        phoneLabel.textAlignment = NSTextAlignmentCenter;
        phoneLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
        [self addSubview:phoneLabel];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(80));
            make.width.mas_offset(RESIZE_UI(110));
        }];
        
        
        UILabel *timeLable = [[UILabel alloc]init];
        if (type == 0) {
            timeLable.text = sortModel.money;
        } else {
            if (sortModel.count) {
                timeLable.text = sortModel.count;
            } else {
                timeLable.text = @"0";
                sortModel.count = @"0";
            }
        }
        timeLable.textAlignment = NSTextAlignmentCenter;
        timeLable.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
        [self addSubview:timeLable];
        CGFloat money = [sortModel.money floatValue];
        if ( (money<=0&&type==0) || ([sortModel.count isEqualToString:@"0"]&&type==1)) {
            if ([sortModel.is_myself isEqualToString:@"1"]) {
                [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.mas_centerY);
                    make.right.equalTo(self.mas_right).with.offset(RESIZE_UI(-30));
                    make.width.mas_offset(RESIZE_UI(120));
                }];
            } else {
                UIButton *wakeFrinendButton = [[UIButton alloc]init];
                if (type == 0) {
                    [wakeFrinendButton setTitle:@"唤醒好友" forState:UIControlStateNormal];
                } else {
                    [wakeFrinendButton setTitle:@"召唤好友" forState:UIControlStateNormal];
                }
                [wakeFrinendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                wakeFrinendButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(9)];
//                [wakeFrinendButton setBackgroundColor:RGBA(235, 178, 77, 1.0)];
                [wakeFrinendButton setBackgroundImage:[UIImage imageNamed:@"huanxingfriend"] forState:UIControlStateNormal];
                [wakeFrinendButton addTarget:self action:@selector(wakeUpFriendMethod) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:wakeFrinendButton];
                [wakeFrinendButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.mas_right).with.offset(-RESIZE_UI(35));
                    make.width.mas_offset(RESIZE_UI(53));
                    make.height.mas_offset(RESIZE_UI(28));
                    make.centerY.equalTo(self.mas_centerY);
                }];
                
                [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.mas_centerY);
                    make.right.equalTo(wakeFrinendButton.mas_left).with.offset(RESIZE_UI(-10));
                }];
            }
        } else {
            [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.mas_centerY);
                make.right.equalTo(self.mas_right).with.offset(RESIZE_UI(-30));
                make.width.mas_offset(RESIZE_UI(120));
            }];
        }
        
        if ([sortModel.is_myself isEqualToString:@"1"]) {
            phoneLabel.textColor = RGBA(255, 108, 0, 1.0);
            timeLable.textColor = RGBA(255, 108, 0, 1.0);
        }
    }
    return self;
}

- (void)wakeUpFriendMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *intefaceName;
    if(_type_lei == 0) {
        intefaceName = @"Focus/prospect_rouse";
    } else {
        intefaceName = @"Focus/rich_rouse";
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"member_id"] = [SingletonManager sharedManager].uid;
    dict[@"mobile"] = _model.mobile;
    [manager postDataWithUrlActionStr:intefaceName withParamDictionary:dict withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
//            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"发送请求成功"];
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

@end
