//
//  MyRecommandTableViewCell.m
//  WmjrApp
//
//  Created by horry on 16/9/26.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "MyRecommandTableViewCell.h"
#import "MyReCommandModel.h"

@interface MyRecommandTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelForName;
@property (weak, nonatomic) IBOutlet UILabel *labelForInvitation;
@property (weak, nonatomic) IBOutlet UILabel *labelForMobile;
@property (weak, nonatomic) IBOutlet UILabel *labelForCreattime;

@end

@implementation MyRecommandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMyRecommandModel:(MyReCommandModel *)myRecommandModel {
    
    _labelForName.text = myRecommandModel.name;
    _labelForInvitation.text = [NSString stringWithFormat:@"￥%@",myRecommandModel.invitation];
    _labelForMobile.text = myRecommandModel.mobile;
    _labelForCreattime.text = myRecommandModel.createtime;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
