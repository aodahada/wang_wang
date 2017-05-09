//
//  ProductCategoryTopCell.m
//  WmjrApp
//
//  Created by horry on 2017/2/22.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "ProductCategoryTopCell.h"
#import "ProductCategoryModel.h"

@interface ProductCategoryTopCell ()

@property (nonatomic, strong)ProductCategoryModel *pcModel;

@end

@implementation ProductCategoryTopCell

- (instancetype)initWithProductCategoryModel:(ProductCategoryModel *)productCategoryModel {
    self = [super init];
    if (self) {
        _pcModel = productCategoryModel;
        UILabel *labelForTitle = [[UILabel alloc]init];
        labelForTitle.text = productCategoryModel.name;
        labelForTitle.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        [self addSubview:labelForTitle];
        [labelForTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(15));
        }];
        
        UILabel  *labelForTag = [[UILabel alloc]init];
        labelForTag.text = @"新人购";
        labelForTag.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
        labelForTag.textColor = RGBA(48, 100, 172, 1.0);
        labelForTag.textAlignment = NSTextAlignmentCenter;
        labelForTag.layer.borderColor = RGBA(48, 100, 172, 1.0).CGColor;
        labelForTag.layer.borderWidth = 1.0f;
        [self addSubview:labelForTag];
        [labelForTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(labelForTitle.mas_right).with.offset(RESIZE_UI(12));
            make.height.mas_offset(RESIZE_UI(19));
            make.width.mas_offset(RESIZE_UI(49));
        }];
        
        UIImageView *jianTouImageView = [[UIImageView alloc]init];
        jianTouImageView.image = [UIImage imageNamed:@"icon_arrow_ck"];
        [self addSubview:jianTouImageView];
        [jianTouImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).with.offset(RESIZE_UI(-15));
            make.height.mas_offset(RESIZE_UI(11));
            make.width.mas_offset(RESIZE_UI(6));
        }];
        
//        UILabel *labelForWatch = [[UILabel alloc]init];
//        labelForWatch.text = @"查看所有";
//        labelForWatch.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
//        labelForWatch.textColor = RGBA(89, 161, 217, 1.0);
//        [self addSubview:labelForWatch];
//        [labelForWatch mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.mas_centerY);
//            make.right.equalTo(jianTouImageView.mas_left).with.offset(RESIZE_UI(-7));
//        }];
        
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.backgroundColor = RGBA(239, 239, 239, 1.0);
        [self addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(1);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
