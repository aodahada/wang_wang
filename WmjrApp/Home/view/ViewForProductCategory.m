//
//  ViewForProductCategory.m
//  WmjrApp
//
//  Created by horry on 16/9/8.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "ViewForProductCategory.h"
#import "HomeProductCatModel.h"

@interface ViewForProductCategory ()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) HomeProductCatModel *productHaModel;

@end

@implementation ViewForProductCategory

- (instancetype)initWithProductModel:(HomeProductCatModel *)productModel {
    
    self = [super init];
    if (self) {
        _productHaModel = productModel;
        _button = [[UIButton alloc]init];
//        [_button sd_setBackgroundImageWithURL:[NSURL URLWithString:productModel.icon] forState:UIControlStateNormal];
        [_button setBackgroundColor:[UIColor redColor]];
        [_button addTarget:self action:@selector(buttonMethod) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _label = [[UILabel alloc]init];
        _label.textColor = RGBA(102, 102, 102, 1.0);
        _label.font = [UIFont systemFontOfSize:17];
        _label.text = productModel.name;
        [_button addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_button.mas_centerX);
            make.bottom.equalTo(_button.mas_bottom).with.offset(-10);
        }];
        
    }
    return self;
}

- (void)buttonMethod {
    
    if (self.buttonClickMethod) {
        self.buttonClickMethod(_productHaModel.id);
    }
    
}

@end
