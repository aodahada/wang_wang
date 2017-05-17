//
//  ListBankTableViewCell.h
//  WmjrApp
//
//  Created by Baimifan on 2017/5/17.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BankModel;
@interface ListBankTableViewCell : UITableViewCell

- (instancetype)initWithBankModel:(BankModel *)bankModel;

@end
