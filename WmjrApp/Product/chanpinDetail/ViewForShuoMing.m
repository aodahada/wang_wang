//
//  ViewForShuoMing.m
//  WmjrApp
//
//  Created by horry on 16/9/7.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "ViewForShuoMing.h"
#import "ProductModel.h"

@interface ViewForShuoMing ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ProductModel *productModel;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, assign) BOOL isCheck;

@end

@implementation ViewForShuoMing

- (instancetype)initWithProductModel:(ProductModel *)productModel {
    
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        _productModel = productModel;
        _isCheck = YES;
        [self setUpLayout];
    }
    return self;
}

- (void)setUpLayout {
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"产品编号";
            cell.detailTextLabel.text = _productModel.proIntro_id;
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"购买区间";
//            cell.detailTextLabel.text = _productModel.heightpurchase;
            NSString *proHeightChaseStr = _productModel.heightpurchase;
            if ([proHeightChaseStr isEqualToString:@"0"]) {
                proHeightChaseStr = @"";
            }
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@~%@",_productModel.lowpurchase,proHeightChaseStr];
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"产品类型";
            cell.detailTextLabel.text = _productModel.classify;
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"计息方式";
            cell.detailTextLabel.text = @"T+1";
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"偿还方式";
            cell.detailTextLabel.text = _productModel.repay;
        }
            break;
        case 5:
        {
            cell.textLabel.text = @"结算日期";
            cell.detailTextLabel.text = _productModel.duedate;
        }
            break;
        default:
            break;
    }
    
    cell.textLabel.font= [UIFont systemFontOfSize:RESIZE_UI(15)];
    cell.detailTextLabel.font= [UIFont systemFontOfSize:RESIZE_UI(15)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = AUXILY_COLOR;
    cell.detailTextLabel.textColor = TITLE_COLOR;
//    if (indexPath.row == 3) {
//        cell.detailTextLabel.textColor = ORANGE_COLOR;
//    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 230;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelLine = [[UILabel alloc]init];
    labelLine.backgroundColor = RGBA(231, 231, 231, 1.0);
    [aView addSubview:labelLine];
    [labelLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aView.mas_top);
        make.height.mas_offset(1);
        make.left.equalTo(aView.mas_left).with.offset(15);
        make.right.equalTo(aView.mas_right);
    }];
    
    UILabel *cdLable = [[UILabel alloc] init];
    cdLable.text = @"存单原件照:";
    cdLable.textAlignment = NSTextAlignmentLeft;
    cdLable.textColor = AUXILY_COLOR;
    cdLable.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [aView addSubview:cdLable];
    [cdLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aView.mas_top).with.offset(10);
        make.left.equalTo(aView.mas_left).with.offset(RESIZE_UI(15));
        make.height.mas_offset(15);
    }];
    
    NSString *picStr = [self convertNullString:_productModel.pic];
    if (![picStr isEqualToString:@""]) {
        UIImageView *cdImg = [[UIImageView alloc] init];
        [cdImg sd_setImageWithURL:[NSURL URLWithString:_productModel.pic] placeholderImage:nil];
        [aView addSubview:cdImg];
        cdImg.userInteractionEnabled = YES;
        _pic = _productModel.pic;
        UITapGestureRecognizer *cdImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cdImgTapAction)];
        [cdImg addGestureRecognizer:cdImgTap];
        [cdImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cdLable.mas_bottom).with.offset(10);
            make.centerX.equalTo(aView.mas_centerX);
            make.height.mas_offset(RESIZE_UI(133));
            make.width.mas_offset(RESIZE_UI(351));
        }];
    }
    
    UILabel *prompt = [[UILabel alloc] init];
    prompt.text = @"注:(还款如果遇到节假日,则还款日期顺延)";
    prompt.textAlignment = NSTextAlignmentLeft;
    prompt.textColor = AUXILY_COLOR;
    prompt.font = [UIFont systemFontOfSize:12.0f];
    [aView addSubview:prompt];
    [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cdLable.mas_bottom).with.offset(150);
        make.left.equalTo(aView.mas_left).with.offset(15);
        make.right.equalTo(aView.mas_right).with.offset(-15);
        make.height.mas_offset(15);
    }];
    
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.layer.cornerRadius = CGRectGetWidth(checkBtn.frame) / 2;
    checkBtn.layer.masksToBounds = YES;
    [checkBtn setImage:[UIImage imageNamed:@"icon_round_sel"] forState:(UIControlStateNormal)];
    [checkBtn addTarget:self action:@selector(changeCheckFlagAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [aView addSubview:checkBtn];
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(prompt.mas_bottom).with.offset(10);
        make.left.equalTo(aView.mas_left).with.offset(10);
        make.height.width.mas_offset(25);
    }];
    
    UILabel *checkAgree = [[UILabel alloc] init];
    checkAgree.textAlignment = NSTextAlignmentLeft;
    checkAgree.font = [UIFont systemFontOfSize:13.0];
    checkAgree.userInteractionEnabled = YES;
    [aView addSubview:checkAgree];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkAgree)];
    [checkAgree addGestureRecognizer:tap];
    NSMutableAttributedString *nickStr = [[NSMutableAttributedString alloc] initWithString: @"已查看网络服务协议"];
    [nickStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
    [nickStr addAttribute:NSForegroundColorAttributeName value:RGBA(0, 102, 177, 1.0) range:NSMakeRange(3, 6)];
    checkAgree.attributedText = nickStr;
    [checkAgree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(checkBtn.mas_centerY);
        make.left.equalTo(checkBtn.mas_right).with.offset(10);
        make.height.mas_offset(20);
    }];
    
    return aView;
}

/* 勾选查看合同 */
- (void)changeCheckFlagAction:(UIButton *)sender {
    _isCheck = !_isCheck;
    if (_isCheck == YES) {
        [sender setImage:[UIImage imageNamed:@"icon_round_sel"] forState:(UIControlStateNormal)];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectContract" object:nil];
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_round_nor"] forState:(UIControlStateNormal)];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"noselectContract" object:nil];
    }
}

/* 查看合同 */
- (void)checkAgree {
    
    if (self.watchContract) {
        self.watchContract();
    }
    
}

- (void)cdImgTapAction {
    
    if (self.watchPic) {
        self.watchPic(_pic);
    }
    
}

/*判断字符串是否为空*/
- (NSString*)convertNullString:(NSString*)oldString{
    if (oldString!=nil && (NSNull *)oldString != [NSNull null]) {
        if ([oldString length]!=0) {
            if ([oldString isEqualToString:@"(null)"]) {
                return @"";
            }
            return  oldString;
        }else{
            return @"";
        }
    }
    else{
        return @"";
    }
}

@end
