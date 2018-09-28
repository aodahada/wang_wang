//
//  NationalActivityView.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/9/25.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "NationalActivityView.h"
#import "GuoqingShowModel.h"

@interface NationalActivityView ()
{
    UIImageView *activityImageView;
    UIImageView *jiangjinchiImageView;
    UIButton *qiangButton;
    UILabel *hongbao_daojishi_label;
    NSInteger timeDistance;
    NSTimer *countDownTimer;
    GuoqingShowModel *guoqingModel;
}

@end

@implementation NationalActivityView

- (instancetype)initWithGuoqingShowModel:(GuoqingShowModel *)guoqingShowModel {
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
        guoqingModel = guoqingShowModel;
        activityImageView = [[UIImageView alloc]init];
        activityImageView.image = [UIImage imageNamed:@"guoqing_tanchuan01"];
        activityImageView.userInteractionEnabled = YES;
        [self addSubview:activityImageView];
        [activityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_offset(RESIZE_UI(279));
            make.height.mas_offset(RESIZE_UI(321));
        }];
        
        jiangjinchiImageView = [[UIImageView alloc]init];
        if ([guoqingShowModel.pool isEqualToString:@"66666"]) {
            jiangjinchiImageView.image = [UIImage imageNamed:@"元"];
        } else if ([guoqingShowModel.pool isEqualToString:@"88888"]) {
            jiangjinchiImageView.image = [UIImage imageNamed:@"元1"];
        } else if ([guoqingShowModel.pool isEqualToString:@"100001"]) {
            jiangjinchiImageView.image = [UIImage imageNamed:@"元2"];
        } else if ([guoqingShowModel.pool isEqualToString:@"168888"]) {
            jiangjinchiImageView.image = [UIImage imageNamed:@"元3"];
        } else {
            jiangjinchiImageView.image = [UIImage imageNamed:@"元4"];
        }
        [activityImageView addSubview:jiangjinchiImageView];
        [jiangjinchiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(activityImageView.mas_top).with.offset(RESIZE_UI(110));
            make.centerX.equalTo(activityImageView.mas_centerX);
            make.width.mas_offset(RESIZE_UI(213));
            make.height.mas_offset(RESIZE_UI(75));
        }];
        
        qiangButton = [[UIButton alloc]init];
        [qiangButton setBackgroundImage:[UIImage imageNamed:@"guoqing_button"] forState:UIControlStateNormal];
        [qiangButton addTarget:self action:@selector(likeqiangMethod) forControlEvents:UIControlEventTouchUpInside];
        [activityImageView addSubview:qiangButton];
        [qiangButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(activityImageView.mas_bottom).with.offset(-RESIZE_UI(25));
            make.centerX.equalTo(activityImageView.mas_centerX);
            make.width.mas_offset(RESIZE_UI(138));
            make.height.mas_offset(RESIZE_UI(42));
        }];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSDate *currentDate = [formatter dateFromString:guoqingShowModel.current_time];
        NSDate *nextDate = [formatter dateFromString:guoqingShowModel.next_time];
        timeDistance = [nextDate timeIntervalSinceDate:currentDate];
        NSInteger hour = timeDistance/3600;
        NSInteger minute = (timeDistance-3600*hour)/60;
        NSInteger second = timeDistance-hour*3600-minute*60;
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
        
        hongbao_daojishi_label = [[UILabel alloc]init];
        hongbao_daojishi_label.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        hongbao_daojishi_label.textColor = RGBA(198, 43, 38, 1.0);
        hongbao_daojishi_label.text = [NSString stringWithFormat:@"红包倒计时%02ld：%02ld：%02ld",hour,minute,second];
        [activityImageView addSubview:hongbao_daojishi_label];
        [hongbao_daojishi_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(qiangButton.mas_top).with.offset(-RESIZE_UI(29));
            make.centerX.equalTo(activityImageView.mas_centerX);
        }];
        
        UIButton *closeButton = [[UIButton alloc]init];
        [closeButton setImage:[UIImage imageNamed:@"guoqing_guanbianniu"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeMethod) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(activityImageView.mas_bottom).with.offset(RESIZE_UI(20));
            make.centerX.equalTo(self.mas_centerX);
            make.width.height.mas_offset(RESIZE_UI(40));
        }];
        
    }
    return self;
}

- (void)likeqiangMethod {
    float pool_amount = [guoqingModel.pool_amount floatValue];
//    pool_amount = 0.00;
    if (guoqingModel.lists.count == 0) {
        [hongbao_daojishi_label removeFromSuperview];
        [jiangjinchiImageView removeFromSuperview];
        [qiangButton removeFromSuperview];
        if (pool_amount == 0) {
            //奖金池没了的时候
            activityImageView.image = [UIImage imageNamed:@"guoqing_tanchuan03"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            NSDate *nextDate = [formatter dateFromString:guoqingModel.next_time];
            [formatter setDateFormat:@"HH"];
            UILabel *tipLabel = [[UILabel alloc]init];
            tipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(23)];
            tipLabel.textColor = [UIColor whiteColor];
            NSString *dae = [formatter stringFromDate:nextDate];
            tipLabel.text = [NSString stringWithFormat:@"下一轮红包  %@:00",[formatter stringFromDate:nextDate]];
            [activityImageView addSubview:tipLabel];
            [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(activityImageView.mas_bottom).with.offset(-RESIZE_UI(33));
                make.centerX.equalTo(activityImageView.mas_centerX);
            }];
        } else {
            //获取红包
            [self getRedPackageMethod];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"你已参与本轮红包活动，请等待下一轮" message:@"" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }

}

- (void)getRedPackageMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"请稍后"];
    [manager postDataWithUrlActionStr:@"Redpacket/doGuoqing" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSDictionary *dataDic = obj[@"data"];
                [SVProgressHUD dismiss];
                activityImageView.image = [UIImage imageNamed:@"guoqing_tanchuang02"];
                
                UILabel *moneyLabel = [[UILabel alloc]init];
                moneyLabel.textColor = RGBA(225, 69, 56, 1.0);
                moneyLabel.text = [NSString stringWithFormat:@"%@元",dataDic[@"money"]];
                moneyLabel.font = [UIFont systemFontOfSize:RESIZE_UI(31)];
                [activityImageView addSubview:moneyLabel];
                [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(activityImageView.mas_top).with.offset(RESIZE_UI(103));
                    make.centerX.equalTo(activityImageView.mas_centerX);
                }];
                
                UILabel *tipLabel = [[UILabel alloc]init];
                tipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
                tipLabel.textColor = RGBA(198, 43, 38, 1.0);
                tipLabel.text = [NSString stringWithFormat:@"恭喜您获得%@元",dataDic[@"money"]];
                [activityImageView addSubview:tipLabel];
                [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(activityImageView.mas_bottom).with.offset(-RESIZE_UI(96));
                    make.centerX.equalTo(activityImageView.mas_centerX);
                }];
                
                UILabel *tipLabel2 = [[UILabel alloc]init];
                tipLabel2.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
                tipLabel2.textColor = [UIColor whiteColor];
                tipLabel2.text = @"可在账号中心-我的红包中查看使用";
                [activityImageView addSubview:tipLabel2];
                [tipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(activityImageView.mas_bottom).with.offset(-RESIZE_UI(40));
                    make.centerX.equalTo(activityImageView.mas_centerX);
                }];
                
                return ;
            } else {
                [SVProgressHUD dismiss];
                NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确定";
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
                [alertView show];
            }
        }
    }];
}

-(void)countDownAction{
    //倒计时-1
    timeDistance--;
    //重新计算 时/分/秒
    NSInteger hour = timeDistance/3600;
    NSInteger minute = (timeDistance-3600*hour)/60;
    NSInteger second = timeDistance-hour*3600-minute*60;
    hongbao_daojishi_label.text = [NSString stringWithFormat:@"红包倒计时%02ld：%02ld：%02ld",hour,minute,second];
    //当倒计时到0时做需要的操作，比如验证码过期不能提交
    if(timeDistance==0){
        [countDownTimer invalidate];
    }
    
}

- (void)closeMethod {
    [self removeFromSuperview];
}

@end
