//
//  ViewForScrollClass.m
//  quanqiju
//
//  Created by huorui on 16/6/20.
//  Copyright © 2016年 霍锐. All rights reserved.
//

#import "ViewForScrollClass.h"
#import "HomeProductCatModel.h"

@interface ViewForScrollClass ()

@property (nonatomic, strong) NSMutableArray *arrayForModule;

@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewForScrollClass

- (instancetype)initWithArray:(NSMutableArray *)moduleArray {
    
    self = [super init];
    if (self) {
        _arrayForModule = moduleArray;
        NSInteger count = moduleArray.count;
//        NSInteger count = 10;
        UIScrollView *scrollview = [[UIScrollView alloc]init];
        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH/3*count, 0);
        scrollview.contentOffset = CGPointMake(0, 0);
        scrollview.bounces = NO;
        scrollview.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollview];
        [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        for (int i=0; i<count; i++) {
            
            HomeProductCatModel *moduleClassModel = moduleArray[i];
            
            UIView *viewForBottom = [[UIView alloc]init];
            viewForBottom.backgroundColor = [UIColor whiteColor];
            [scrollview addSubview:viewForBottom];
            [viewForBottom mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(scrollview.mas_left).with.offset(i*SCREEN_WIDTH/3);
                make.width.mas_offset(SCREEN_WIDTH/3);
                make.height.mas_equalTo(self.mas_height);
                make.centerY.equalTo(scrollview.mas_centerY);
            }];
            
            _label = [[UILabel alloc]init];
            _label.textColor = RGBA(102, 102, 102, 1.0);
            _label.font = [UIFont systemFontOfSize:17];
            _label.text = moduleClassModel.name;
            [viewForBottom addSubview:_label];
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(viewForBottom.mas_centerX);
                make.bottom.equalTo(viewForBottom.mas_bottom).with.offset(-8);
                make.height.mas_equalTo(14);
            }];
            
            UIImageView *imageView = [[UIImageView alloc]init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:moduleClassModel.icon]];
//            imageView.image = [UIImage imageNamed:@"loginpage_icon.png"];
            [viewForBottom addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(viewForBottom.mas_top);
                make.centerX.equalTo(viewForBottom.mas_centerX);
                make.bottom.equalTo(_label.mas_top).with.offset(-3);
                make.width.mas_equalTo(imageView.mas_height);
            }];
            
            UIButton *buttonForClass = [[UIButton alloc]init];
            buttonForClass.backgroundColor = [UIColor clearColor];
            buttonForClass.tag = i;
            [buttonForClass addTarget:self action:@selector(jumpToMessPage:) forControlEvents:UIControlEventTouchUpInside];
            [viewForBottom addSubview:buttonForClass];
            [buttonForClass mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(viewForBottom);
            }];
            
        }
        
    }
    return self;
    
}

- (void)jumpToMessPage:(UIButton *)btn {
    
    HomeProductCatModel *moduleClassModel = _arrayForModule[btn.tag];
    if (self.jumToMessPage) {
        self.jumToMessPage(moduleClassModel);
    }
}

@end
