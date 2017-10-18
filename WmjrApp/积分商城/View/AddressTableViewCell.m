//
//  AddressTableViewCell.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/17.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "AddressTableViewCell.h"
#import "IntegralAddressModel.h"

@interface AddressTableViewCell()

@property (nonatomic, strong)UIImageView *norquanImage;
@property (nonatomic, strong)IntegralAddressModel *integralAddressModel;

@end

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithIntegralAddressModel:(IntegralAddressModel *)integralAddressModel {
    
    self = [super init];
    if (self) {
        self.backgroundColor = RGBA(238, 240, 242, 1.0);
        _integralAddressModel = integralAddressModel;
        UIView *topView = [[UIView alloc]init];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(RESIZE_UI(111.5));
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = integralAddressModel.name;
        nameLabel.textColor = RGBA(20, 20, 23, 1.0);
        nameLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        [topView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(14));
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(12));
        }];
        
        UIImageView *jianImageView = [[UIImageView alloc]init];
        jianImageView.image = [UIImage imageNamed:@"icon_arrow"];
        [topView addSubview:jianImageView];
        [jianImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView.mas_centerY);
            make.right.equalTo(topView.mas_right).with.offset(-RESIZE_UI(15));
            make.width.mas_offset(RESIZE_UI(14));
            make.height.mas_offset(RESIZE_UI(14));
        }];
        
        UILabel *phoneLabel = [[UILabel alloc]init];
        phoneLabel.text = integralAddressModel.mobile;
        phoneLabel.textColor = RGBA(102, 102, 102, 1.0);
        [topView addSubview:phoneLabel];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_top).with.offset(RESIZE_UI(14));
            make.right.equalTo(topView.mas_right).with.offset(RESIZE_UI(-48));
        }];
        
        UILabel *addressLabel = [[UILabel alloc]init];
        addressLabel.numberOfLines = 2;
        addressLabel.text = integralAddressModel.address;
        addressLabel.textColor = RGBA(102, 102, 102, 1.0);
        addressLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [topView addSubview:addressLabel];
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).with.offset(RESIZE_UI(9));
            make.left.equalTo(nameLabel.mas_left);
            make.right.equalTo(jianImageView.mas_left).with.offset(-RESIZE_UI(25));
            make.height.mas_offset(RESIZE_UI(52));
        }];
        
        UIView *bottomView = [[UIView alloc]init];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).with.offset(1);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(RESIZE_UI(48.5));
        }];
        
        _norquanImage = [[UIImageView alloc]init];
        if ([integralAddressModel.is_default isEqualToString:@"1"]) {
            _norquanImage.image = [UIImage imageNamed:@"icon_dagou"];
        } else {
            _norquanImage.image = [UIImage imageNamed:@"icon_round_nor"];
        }
        [bottomView addSubview:_norquanImage];
        [_norquanImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView.mas_centerY);
            make.left.equalTo(bottomView.mas_left).with.offset(RESIZE_UI(15));
            make.width.height.mas_offset(RESIZE_UI(15));
        }];
        
        UILabel *normalLabel = [[UILabel alloc]init];
        normalLabel.text = @"默认地址";
        normalLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        normalLabel.textColor = RGBA(255, 82, 37, 1.0);
        [bottomView addSubview:normalLabel];
        [normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView.mas_centerY);
            make.left.equalTo(_norquanImage.mas_right).with.offset(RESIZE_UI(12));
        }];
        
        UIButton *setNormalAdderss = [[UIButton alloc]init];
        [setNormalAdderss setBackgroundColor:[UIColor clearColor]];
        [setNormalAdderss addTarget:self action:@selector(selecNormalAddressMethod) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:setNormalAdderss];
        [setNormalAdderss mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomView.mas_left);
            make.top.equalTo(bottomView.mas_top);
            make.bottom.equalTo(bottomView.mas_bottom);
            make.right.equalTo(normalLabel.mas_right);
        }];
        
        UILabel *deleteLabel = [[UILabel alloc]init];
        deleteLabel.text = @"删除";
        deleteLabel.textColor = RGBA(102, 102, 102, 1.0);
        deleteLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        [bottomView addSubview:deleteLabel];
        [deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView.mas_centerY);
            make.right.equalTo(bottomView.mas_right).with.offset(-RESIZE_UI(16));
        }];
        
        UIImageView *deleteImage = [[UIImageView alloc]init];
        deleteImage.image = [UIImage imageNamed:@"icon_shanchu"];
        [bottomView addSubview:deleteImage];
        [deleteImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView.mas_centerY);
            make.right.equalTo(deleteLabel.mas_left).with.offset(-RESIZE_UI(5));
            make.height.width.mas_offset(RESIZE_UI(18));
        }];
        
        //删除按钮
        UIButton *deleteButton = [[UIButton alloc]init];
        [deleteButton setBackgroundColor:[UIColor clearColor]];
        [deleteButton addTarget:self action:@selector(deleteAddressMethod) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:deleteButton];
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bottomView.mas_right);
            make.top.equalTo(bottomView.mas_top);
            make.bottom.equalTo(bottomView.mas_bottom);
            make.left.equalTo(deleteImage.mas_left).with.offset(-RESIZE_UI(10));
        }];
        
    }
    return self;
    
}

- (void)selecNormalAddressMethod {
    //未选中 icon_round_nor
    //选中  icon_dagou
    if (self.delegate && [self.delegate respondsToSelector:@selector(setNormalAddress:)]) {
        [self.delegate setNormalAddress:_integralAddressModel];
    }
    
}

- (void)deleteAddressMethod {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteAddress:)]) {
        [self.delegate deleteAddress:_integralAddressModel];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
