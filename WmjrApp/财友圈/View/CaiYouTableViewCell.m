//
//  CaiYouTableViewCell.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/28.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "CaiYouTableViewCell.h"
#import "MyReCommandModel.h"

@implementation CaiYouTableViewCell

- (instancetype)initWithReCommandModel:(MyReCommandModel *)recommandModel withRow:(NSInteger)row {
    self = [super init];
    if (self) {
        UILabel *indexLabel = [[UILabel alloc]init];
        indexLabel.text = [NSString stringWithFormat:@"%ld",(long)row+1];
        indexLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
        [self addSubview:indexLabel];
        [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(30));
        }];
        
        UILabel *phoneLabel = [[UILabel alloc]init];
        NSString *mobileNumber = recommandModel.mobile;
        NSMutableString *phoneNum = [mobileNumber mutableCopy];
        [phoneNum replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
        phoneLabel.text = phoneNum;
        phoneLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
        [self addSubview:phoneLabel];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(80));
        }];
        
        UILabel *timeLable = [[UILabel alloc]init];
        timeLable.text = recommandModel.createtime;
        timeLable.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
        [self addSubview:timeLable];
        [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).with.offset(RESIZE_UI(-30));
        }];
        
    }
    return self;
}
@end
