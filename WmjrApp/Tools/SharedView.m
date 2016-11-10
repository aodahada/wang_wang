//
//  SharedView.m
//  share(无菜单)
//
//  Created by Baimifan on 15/7/31.
//  Copyright (c) 2015年 mob.com. All rights reserved.
//

#import "SharedView.h"

@implementation SharedView

- (instancetype)initWithFrame:(CGRect)frame {
    self  = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = VIEWBACKCOLOR;
        
        UILabel *labelForTitle = [[UILabel alloc]init];
        labelForTitle.text = @"分享";
        labelForTitle.textColor = RGBA(153, 153, 153, 1.0);
        labelForTitle.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [self addSubview:labelForTitle];
        [labelForTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(16));
            make.centerX.equalTo(self.mas_centerX);
            make.height.mas_offset(RESIZE_UI(17));
        }];
        
        UILabel *labelForLine1 = [[UILabel alloc]init];
        labelForLine1.backgroundColor = RGBA(239, 239, 239, 1.0);
        [self addSubview:labelForLine1];
        [labelForLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(1);
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(24));
            make.right.equalTo(labelForTitle.mas_left).with.offset(RESIZE_UI(-29));
            make.centerY.equalTo(labelForTitle.mas_centerY);
        }];
        
        UILabel *labelForLine2 = [[UILabel alloc]init];
        labelForLine2.backgroundColor = RGBA(239, 239, 239, 1.0);
        [self addSubview:labelForLine2];
        [labelForLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(1);
            make.left.equalTo(labelForTitle.mas_right).with.offset(RESIZE_UI(29));
            make.right.equalTo(self.mas_right).with.offset(RESIZE_UI(-24));
            make.centerY.equalTo(labelForTitle.mas_centerY);
        }];
        
        [self initWithSharedBtn];
        
        UILabel *labelForLine3 = [[UILabel alloc]initWithFrame:CGRectMake(0, RESIZE_UI(125), SCREEN_WIDTH, 1)];
        labelForLine3.backgroundColor = RGBA(239, 239, 239, 1.0);
        [self addSubview:labelForLine3];
        
        UILabel *labelForCancel = [[UILabel alloc]init];
        labelForCancel.text = @"取消";
        labelForCancel.textColor = RGBA(255, 88, 26, 1.0);
        labelForCancel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        [self addSubview:labelForCancel];
        [labelForCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labelForLine3.mas_bottom).with.offset(RESIZE_UI(11));
            make.height.mas_offset(RESIZE_UI(21));
            make.centerX.equalTo(self.mas_centerX);
        }];
        
    }
    return self;
}

/*创建分享按钮*/
- (void)initWithSharedBtn {
    NSArray *imgArray = @[@"icon_qq", @"icon_weixin", @"icon_weibo", @"icon_pyq"];
    for (int i = 0; i < 4; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = RESIZE_FRAME(CGRectMake(35 + (35 + 50) * i, 43, 50, 50));
        [button setBackgroundImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        button.tag = 500 + i;
        [self addSubview:button];
        [button addTarget:self action:@selector(clickSharedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *labelForName = [[UILabel alloc]initWithFrame:RESIZE_FRAME(CGRectMake(35+(35+50)*i, 95, 50, 20))];
        labelForName.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        labelForName.textAlignment = NSTextAlignmentCenter;
        labelForName.textColor = RGBA(102, 102, 102, 1.0);
        switch (i) {
            case 0:
                labelForName.text = @"QQ";
                break;
            case 1:
                labelForName.text = @"微信";
                break;
            case 2:
                labelForName.text = @"微博";
                break;
            case 3:
                labelForName.text = @"朋友圈";
                break;
                
            default:
                break;
        }
        [self addSubview:labelForName];
    }
}

- (void)callSharedBtnEventBlock:(callSharedEvent)block {
    self.block = block;
}

/*点击分享按钮事件响应*/
- (void)clickSharedBtnAction:(UIButton *)sender  {
    NSLog(@"－－－点击了分享按妞－－－");
    self.block(sender);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
