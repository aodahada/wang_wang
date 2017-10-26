//
//  AddressTableViewCell.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/17.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IntegralAddressModel;
@protocol AddressCellDalegate<NSObject>

//删除地址
- (void)deleteAddress:(IntegralAddressModel *)integralAddressModel;
//设置默认地址
- (void)setNormalAddress:(IntegralAddressModel *)integralAddressModel;
//编辑地址
- (void)editAddress:(IntegralAddressModel *)integralAddressModel;

@end

@interface AddressTableViewCell : UITableViewCell

@property (nonatomic, assign) id<AddressCellDalegate> delegate;

- (instancetype)initWithIntegralAddressModel:(IntegralAddressModel *)integralAddressModel;

@end
