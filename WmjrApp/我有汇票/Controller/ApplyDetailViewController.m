//
//  ApplyDetailViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/11/21.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "ApplyDetailViewController.h"
#import "ApplySmallMessView.h"

@interface ApplyDetailViewController ()

@property (nonatomic, assign)CGFloat buttonwidth;

@end

@implementation ApplyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请详情";
    self.view.backgroundColor = [UIColor whiteColor];
    _buttonwidth = (SCREEN_WIDTH-RESIZE_UI(100))/4;
    _identifier = [_applyRecordModel.member_type integerValue];//1.个人 2.企业
    [self setUpLayout];
}

#pragma mark - 界面布局
- (void)setUpLayout {
    UIScrollView *scrollViewMain = [[UIScrollView alloc]init];
    scrollViewMain.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollViewMain];
    [scrollViewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *viewMain = [[UIView alloc]init];
    viewMain.backgroundColor = RGBA(238, 240, 242, 1.0);
    [scrollViewMain addSubview:viewMain];
    [viewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollViewMain);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    //第一行
    UIView *row1View = [[UIView alloc]init];
    row1View.backgroundColor = RGBA(237, 244, 247, 1.0);
    [viewMain addSubview:row1View];
    [row1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewMain.mas_top);
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(60));
    }];
    
    UILabel *numberLabel = [[UILabel alloc]init];
    numberLabel.text = _applyRecordModel.id;
    numberLabel.textColor = RGBA(102, 102, 102, 1.0);
    numberLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [viewMain addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row1View.mas_centerY);
        make.left.equalTo(row1View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    NSString *status;
    if ([_applyRecordModel.status isEqualToString:@"0"]) {
        status = @"审核中";
    } else if ([_applyRecordModel.status isEqualToString:@"1"]) {
        status = @"审核通过";
    } else {
        status = @"审核驳回";
    }
    UILabel *statusLabel = [[UILabel alloc]init];
    statusLabel.text = status;
    statusLabel.textColor = RGBA(255, 88, 26, 1.0);
    statusLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [row1View addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row1View.mas_centerY);
        make.right.equalTo(row1View.mas_right).with.offset(-RESIZE_UI(20));
    }];
    
    //第二行  6块
    UIView *row2View = [[UIView alloc]init];
    row2View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row2View];
    [row2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row1View.mas_bottom);
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(174));
    }];
    
    ApplySmallMessView *applyView1 = [[ApplySmallMessView alloc]initWithTitle:@"申请日期" Content:_applyRecordModel.created_at andUnit:@""];
    [row2View addSubview:applyView1];
    [applyView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row2View.mas_top);
        make.left.equalTo(row2View.mas_left);
        make.height.mas_offset(RESIZE_UI(174)/2-RESIZE_UI(1));
        make.width.mas_offset(SCREEN_WIDTH/3-RESIZE_UI(1));
    }];
    
    UILabel *line1 = [[UILabel alloc]init];
    line1.backgroundColor = RGBA(237, 240, 242, 1.0);
    [row2View addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(applyView1.mas_centerY);
        make.left.equalTo(applyView1.mas_right);
        make.width.mas_equalTo(RESIZE_UI(2));
        make.height.mas_offset(RESIZE_UI(35));
    }];
    
    ApplySmallMessView *applyView2 = [[ApplySmallMessView alloc]initWithTitle:@"票据到期日期" Content:_applyRecordModel.end_time andUnit:@""];
    [row2View addSubview:applyView2];
    [applyView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyView1.mas_top);
        make.left.equalTo(line1.mas_right);
        make.width.mas_offset(SCREEN_WIDTH/3-RESIZE_UI(2));
        make.height.mas_equalTo(RESIZE_UI(174)/2-RESIZE_UI(1));
    }];
    
    UILabel *line2 = [[UILabel alloc]init];
    line2.backgroundColor = RGBA(237, 240, 242, 1.0);
    [row2View addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(applyView2.mas_right);
        make.centerY.equalTo(applyView2.mas_centerY);
        make.width.mas_equalTo(RESIZE_UI(2));
        make.height.mas_offset(RESIZE_UI(35));
    }];
    
    ApplySmallMessView *applyView3 = [[ApplySmallMessView alloc]initWithTitle:@"借款期限" Content:_applyRecordModel.borrow_day andUnit:@"天"];
    [row2View addSubview:applyView3];
    [applyView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyView1.mas_top);
        make.left.equalTo(line2.mas_right);
        make.right.equalTo(row2View.mas_right);
        make.height.mas_equalTo(RESIZE_UI(174)/2-RESIZE_UI(1));
    }];
    
    UILabel *line3 = [[UILabel alloc]init];
    line3.backgroundColor = RGBA(237, 240, 242, 1.0);
    [row2View addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyView1.mas_bottom).with.offset(RESIZE_UI(2));
        make.left.equalTo(row2View.mas_left).with.offset(RESIZE_UI(20));
        make.right.equalTo(row2View.mas_right).with.offset(-RESIZE_UI(20));
        make.height.mas_offset(RESIZE_UI(2));
    }];
    
    ApplySmallMessView *applyView4 = [[ApplySmallMessView alloc]initWithTitle:@"票面金额" Content:_applyRecordModel.money andUnit:@"元"];
    [row2View addSubview:applyView4];
    [applyView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line3.mas_bottom);
        make.left.equalTo(row2View.mas_left);
        make.height.mas_offset(RESIZE_UI(174)/2-RESIZE_UI(1));
        make.width.mas_offset(SCREEN_WIDTH/3-RESIZE_UI(1));
    }];
    
    UILabel *line4 = [[UILabel alloc]init];
    line4.backgroundColor = RGBA(237, 240, 242, 1.0);
    [row2View addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(applyView4.mas_centerY);
        make.left.equalTo(applyView4.mas_right);
        make.width.mas_equalTo(RESIZE_UI(2));
        make.height.mas_offset(RESIZE_UI(35));
    }];
    
    ApplySmallMessView *applyView5 = [[ApplySmallMessView alloc]initWithTitle:@"借款金额" Content:_applyRecordModel.borrow_money andUnit:@"元"];
    [row2View addSubview:applyView5];
    [applyView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyView4.mas_top);
        make.left.equalTo(line4.mas_right);
        make.width.mas_offset(SCREEN_WIDTH/3-RESIZE_UI(2));
        make.height.mas_equalTo(RESIZE_UI(174)/2-RESIZE_UI(1));
    }];
    
    UILabel *line5 = [[UILabel alloc]init];
    line5.backgroundColor = RGBA(237, 240, 242, 1.0);
    [row2View addSubview:line5];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(applyView5.mas_right);
        make.centerY.equalTo(applyView5.mas_centerY);
        make.width.mas_equalTo(RESIZE_UI(2));
        make.height.mas_offset(RESIZE_UI(35));
    }];
    
    ApplySmallMessView *applyView6 = [[ApplySmallMessView alloc]initWithTitle:@"期望利率" Content:_applyRecordModel.returnrate andUnit:@"%"];
    [row2View addSubview:applyView6];
    [applyView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyView4.mas_top);
        make.left.equalTo(line5.mas_right);
        make.right.equalTo(row2View.mas_right);
        make.height.mas_equalTo(RESIZE_UI(174)/2-RESIZE_UI(1));
    }];
    
    //第三行 票据类型
    UIView *row3View = [[UIView alloc]init];
    row3View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row3View];
    [row3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row2View.mas_bottom).with.offset(RESIZE_UI(10));
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(50));
    }];
    
    UILabel *piaojuTypeTitle = [[UILabel alloc]init];
    piaojuTypeTitle.text = @"票据类型";
    piaojuTypeTitle.textColor = RGBA(102, 102, 102, 1.0);
    piaojuTypeTitle.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [row3View addSubview:piaojuTypeTitle];
    [piaojuTypeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row3View.mas_centerY);
        make.left.equalTo(row3View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    NSString *billType;
    if ([_applyRecordModel.bill_type isEqualToString:@"1"]) {
        billType = @"银票";
    } else {
        billType = @"商票";
    }
    UILabel *piaojuTypeContent = [[UILabel alloc]init];
    piaojuTypeContent.text = billType;
    piaojuTypeContent.textColor = RGBA(60, 60, 60, 1.0);
    piaojuTypeContent.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [row3View addSubview:piaojuTypeContent];
    [piaojuTypeContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row3View.mas_centerY);
        make.right.equalTo(row3View.mas_right).with.offset(-RESIZE_UI(20));
    }];
    
    //第四行 承兑银行/承兑人
    UIView *row4View = [[UIView alloc]init];
    row4View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row4View];
    
    UILabel *chengduiTitle = [[UILabel alloc]init];
    chengduiTitle.text = @"承兑银行/承兑人";
    chengduiTitle.textColor = RGBA(102, 102, 102, 1.0);
    chengduiTitle.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [row4View addSubview:chengduiTitle];
    [chengduiTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row4View.mas_centerY);
        make.left.equalTo(row4View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    UILabel *chengduiContent = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, RESIZE_UI(160), RESIZE_UI(20))];
    chengduiContent.text = _applyRecordModel.acceptor;
    chengduiContent.lineBreakMode = NSLineBreakByWordWrapping;
    chengduiContent.numberOfLines = 0;
    CGSize size = [chengduiContent sizeThatFits:CGSizeMake(chengduiContent.frame.size.width, MAXFLOAT)];
    chengduiContent.frame =CGRectMake(0, 100, 300, size.height);
    chengduiContent.textColor = RGBA(60, 60, 60, 1.0);
    chengduiContent.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    chengduiContent.textAlignment = NSTextAlignmentRight;
    [row4View addSubview:chengduiContent];
    [chengduiContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row4View.mas_centerY);
        make.right.equalTo(row4View.mas_right).with.offset(-RESIZE_UI(20));
        make.width.mas_offset(RESIZE_UI(160));
        make.height.mas_offset(size.height);
    }];
    
    [row4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row3View.mas_bottom).with.offset(RESIZE_UI(1));
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(size.height+RESIZE_UI(30));
    }];
    
    //第五行 联系人姓名
    UIView *row5View = [[UIView alloc]init];
    row5View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row5View];
    [row5View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row4View.mas_bottom).with.offset(RESIZE_UI(1));
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(50));
    }];
    
    UILabel *personNameTitle = [[UILabel alloc]init];
    personNameTitle.text = @"联系人姓名";
    personNameTitle.textColor = RGBA(102, 102, 102, 1.0);
    personNameTitle.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [row5View addSubview:personNameTitle];
    [personNameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row5View.mas_centerY);
        make.left.equalTo(row5View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    UILabel *personNameContent = [[UILabel alloc]init];
    personNameContent.text = _applyRecordModel.borrow_name;
    personNameContent.textColor = RGBA(60, 60, 60, 1.0);
    personNameContent.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    personNameContent.textAlignment = NSTextAlignmentRight;
    [row5View addSubview:personNameContent];
    [personNameContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row5View.mas_centerY);
        make.right.equalTo(row5View.mas_right).with.offset(-RESIZE_UI(20));
        make.width.mas_offset(RESIZE_UI(160));
    }];
    
    //第六行 申请人电话
    UIView *row6View = [[UIView alloc]init];
    row6View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row6View];
    [row6View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row5View.mas_bottom).with.offset(RESIZE_UI(1));
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(50));
    }];
    
    UILabel *personPhoneTitle = [[UILabel alloc]init];
    personPhoneTitle.text = @"联系人电话";
    personPhoneTitle.textColor = RGBA(102, 102, 102, 1.0);
    personPhoneTitle.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [row6View addSubview:personPhoneTitle];
    [personPhoneTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row6View.mas_centerY);
        make.left.equalTo(row6View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    UILabel *personPhoneContent = [[UILabel alloc]init];
    personPhoneContent.text = _applyRecordModel.borrow_phone;
    personPhoneContent.textColor = RGBA(60, 60, 60, 1.0);
    personPhoneContent.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    personPhoneContent.textAlignment = NSTextAlignmentRight;
    [row6View addSubview:personPhoneContent];
    [personPhoneContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row6View.mas_centerY);
        make.right.equalTo(row6View.mas_right).with.offset(-RESIZE_UI(20));
        make.width.mas_offset(RESIZE_UI(160));
    }];
    
    if (_identifier == 1) {
        //第七行 职业
        UIView *row7View = [[UIView alloc]init];
        row7View.backgroundColor = [UIColor whiteColor];
        [viewMain addSubview:row7View];
        [row7View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(row6View.mas_bottom).with.offset(RESIZE_UI(1));
            make.left.equalTo(viewMain.mas_left);
            make.right.equalTo(viewMain.mas_right);
            make.height.mas_offset(RESIZE_UI(50));
        }];
        
        UILabel *personJobTitle = [[UILabel alloc]init];
        personJobTitle.text = @"职业";
        personJobTitle.textColor = RGBA(102, 102, 102, 1.0);
        personJobTitle.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        [row7View addSubview:personJobTitle];
        [personJobTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(row7View.mas_centerY);
            make.left.equalTo(row7View.mas_left).with.offset(RESIZE_UI(20));
        }];
        
        UILabel *personJobContent = [[UILabel alloc]init];
        if ([[SingletonManager convertNullString:_applyRecordModel.borrow_carrer] isEqualToString:@""]) {
            personJobContent.text = @"未填写";
            personJobContent.textColor = RGBA(153, 153, 153, 1.0);
        } else {
            personJobContent.text = _applyRecordModel.borrow_carrer;
            personJobContent.textColor = RGBA(60, 60, 60, 1.0);
        }
        personJobContent.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        personJobContent.textAlignment = NSTextAlignmentRight;
        [row7View addSubview:personJobContent];
        [personJobContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(row7View.mas_centerY);
            make.right.equalTo(row7View.mas_right).with.offset(-RESIZE_UI(20));
            make.width.mas_offset(RESIZE_UI(160));
        }];
        
        //第八行 年收入
        UIView *row8View = [[UIView alloc]init];
        row8View.backgroundColor = [UIColor whiteColor];
        [viewMain addSubview:row8View];
        [row8View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(row7View.mas_bottom).with.offset(RESIZE_UI(1));
            make.left.equalTo(viewMain.mas_left);
            make.right.equalTo(viewMain.mas_right);
            make.height.mas_offset(RESIZE_UI(50));
        }];
        
        UILabel *personSalaryTitle = [[UILabel alloc]init];
        personSalaryTitle.text = @"年收入";
        personSalaryTitle.textColor = RGBA(102, 102, 102, 1.0);
        personSalaryTitle.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        [row8View addSubview:personSalaryTitle];
        [personSalaryTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(row8View.mas_centerY);
            make.left.equalTo(row8View.mas_left).with.offset(RESIZE_UI(20));
        }];
        
        UILabel *personSalaryContent = [[UILabel alloc]init];
        if ([[SingletonManager convertNullString:_applyRecordModel.borrow_income] isEqualToString:@""]) {
            personSalaryContent.text = @"未填写";
            personSalaryContent.textColor = RGBA(153, 153, 153, 1.0);
        } else {
            personSalaryContent.text = [NSString stringWithFormat:@"%@万",_applyRecordModel.borrow_income];
            personSalaryContent.textColor = RGBA(60, 60, 60, 1.0);
        }
        personSalaryContent.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        personSalaryContent.textAlignment = NSTextAlignmentRight;
        [row8View addSubview:personSalaryContent];
        [personSalaryContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(row8View.mas_centerY);
            make.right.equalTo(row8View.mas_right).with.offset(-RESIZE_UI(20));
            make.width.mas_offset(RESIZE_UI(160));
        }];
    } else {
        //第七行 企业名称
        UIView *row7View = [[UIView alloc]init];
        row7View.backgroundColor = [UIColor whiteColor];
        [viewMain addSubview:row7View];
        [row7View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(row6View.mas_bottom).with.offset(RESIZE_UI(1));
            make.left.equalTo(viewMain.mas_left);
            make.right.equalTo(viewMain.mas_right);
            make.height.mas_offset(RESIZE_UI(70));
        }];
        
        UILabel *enterpriseTitle = [[UILabel alloc]init];
        enterpriseTitle.text = @"企业名称";
        enterpriseTitle.textColor = RGBA(102, 102, 102, 1.0);
        enterpriseTitle.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        [row7View addSubview:enterpriseTitle];
        [enterpriseTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(row7View.mas_top).with.offset(RESIZE_UI(20));
            make.left.equalTo(row7View.mas_left).with.offset(RESIZE_UI(20));
        }];
        
        UILabel *enterpriseContent = [[UILabel alloc]init];
        NSString *content = _applyRecordModel.enterprise_name;
        if (content.length>13) {
            enterpriseContent.textAlignment = NSTextAlignmentLeft;
            enterpriseContent.numberOfLines = 2;
        } else {
            enterpriseContent.textAlignment = NSTextAlignmentRight;
            enterpriseContent.numberOfLines = 1;
        }
        enterpriseContent.text = content;
        [enterpriseContent setUserInteractionEnabled:NO];
        enterpriseContent.textColor = RGBA(60, 60, 60, 1.0);
        enterpriseContent.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        enterpriseContent.textAlignment = NSTextAlignmentRight;
        [row7View addSubview:enterpriseContent];
        [enterpriseContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(row7View.mas_top).with.offset(RESIZE_UI(20));
            make.width.mas_offset(RESIZE_UI(212));
            make.right.equalTo(row7View.mas_right).with.offset(-RESIZE_UI(20));
        }];
    }
    
    //第九行 借款用途标题
    //距离第六行距离
    CGFloat row6Distace;
    if (_identifier == 1) {
        row6Distace = RESIZE_UI(109);
    } else {
        row6Distace = RESIZE_UI(80);
    }
    UIView *row9View = [[UIView alloc]init];
    row9View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row9View];
    [row9View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row6View.mas_bottom).with.offset(row6Distace);
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(50));
    }];
    
    UILabel *loansUseTitle = [[UILabel alloc]init];
    loansUseTitle.text = @"借款用途";
    loansUseTitle.textColor = RGBA(102, 102, 102, 1.0);
    loansUseTitle.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [row9View addSubview:loansUseTitle];
    [loansUseTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row9View.mas_centerY);
        make.left.equalTo(row9View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    //第十行 借款用途详细
    UIView *row10View = [[UIView alloc]init];
    row10View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row10View];
    [row10View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row9View.mas_bottom).with.offset(RESIZE_UI(1));
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(100));
    }];
    
    UITextView *loansUseTextView = [[UITextView alloc]init];
    if ([[SingletonManager convertNullString:_applyRecordModel.borrow_use] isEqualToString:@""]) {
        loansUseTextView.text = @"未填写";
        loansUseTextView.textColor = RGBA(153, 153, 153, 1.0);
    } else {
        loansUseTextView.text = _applyRecordModel.borrow_use;
        loansUseTextView.textColor = RGBA(60, 60, 60, 1.0);
    }
    loansUseTextView.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [row10View addSubview:loansUseTextView];
    [loansUseTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row10View.mas_top).with.offset(RESIZE_UI(14));
        make.left.equalTo(row10View.mas_left).with.offset(RESIZE_UI(20));
        make.right.equalTo(row10View.mas_right).with.offset(-RESIZE_UI(20));
        make.bottom.equalTo(row10View.mas_bottom).with.offset(-RESIZE_UI(30));
    }];
    
    //第十一行 担保措施
    UIView *row11View = [[UIView alloc]init];
    row11View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row11View];
    [row11View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row10View.mas_bottom).with.offset(RESIZE_UI(10));
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(50));
    }];

    UILabel *ensureStepTitle = [[UILabel alloc]init];
    ensureStepTitle.text = @"担保措施";
    ensureStepTitle.textColor = RGBA(102, 102, 102, 1.0);
    ensureStepTitle.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [row11View addSubview:ensureStepTitle];
    [ensureStepTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row11View.mas_centerY);
        make.left.equalTo(row11View.mas_left).with.offset(RESIZE_UI(20));
    }];

    UILabel *ensureStepContent = [[UILabel alloc]init];
    ensureStepContent.text = @"票据质押";
    ensureStepContent.textColor = RGBA(60, 60, 60, 1.0);
    ensureStepContent.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [row11View addSubview:ensureStepContent];
    [ensureStepContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row11View.mas_centerY);
        make.right.equalTo(row11View.mas_right).with.offset(-RESIZE_UI(20));
    }];

    //第十二行 担保措施详情
    UIView *row12View = [[UIView alloc]init];
    row12View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row12View];
    [row12View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row11View.mas_bottom).with.offset(RESIZE_UI(1));
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(100));
    }];

    UITextView *ensureStepTextView = [[UITextView alloc]init];
    if ([[SingletonManager convertNullString:_applyRecordModel.borrow_guarantee] isEqualToString:@""]) {
        ensureStepTextView.text = @"未填写";
        ensureStepTextView.textColor = RGBA(153, 153, 153, 1.0);
    } else {
        ensureStepTextView.text = _applyRecordModel.borrow_guarantee;
        ensureStepTextView.textColor = RGBA(60, 60, 60, 1.0);
    }
    ensureStepTextView.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [row12View addSubview:ensureStepTextView];
    [ensureStepTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row12View.mas_top).with.offset(RESIZE_UI(14));
        make.left.equalTo(row12View.mas_left).with.offset(RESIZE_UI(20));
        make.right.equalTo(row12View.mas_right).with.offset(-RESIZE_UI(20));
        make.bottom.equalTo(row12View.mas_bottom).with.offset(-RESIZE_UI(30));
    }];

    //营业执照正副本
    if (_identifier == 2) {
        UIView *row13View = [[UIView alloc]init];
        row13View.backgroundColor = [UIColor whiteColor];
        [viewMain addSubview:row13View];
        [row13View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(row12View.mas_bottom).with.offset(RESIZE_UI(10));
            make.left.equalTo(viewMain.mas_left);
            make.right.equalTo(viewMain.mas_right);
            make.height.mas_offset(RESIZE_UI(150));
        }];
        
        UILabel *businessLicenseTitle = [[UILabel alloc]init];
        businessLicenseTitle.text = @"营业执照正副本";
        businessLicenseTitle.textColor = RGBA(102, 102, 102, 1.0);
        businessLicenseTitle.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        [row13View addSubview:businessLicenseTitle];
        [businessLicenseTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(row13View.mas_top).with.offset(RESIZE_UI(20));
            make.left.equalTo(row13View.mas_left).with.offset(RESIZE_UI(20));
        }];
        
        NSArray *enterpriseImageArray = _applyRecordModel.img_enterprise;
        for (int i=0; i<enterpriseImageArray.count; i++) {
            NSDictionary *imageDic = enterpriseImageArray[i];
            NSString *imageUrl = imageDic[@"img_url"];
            UIButton *imageButton = [[UIButton alloc]init];
            [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal];
            [row13View addSubview:imageButton];
            [imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(businessLicenseTitle.mas_bottom).with.offset(RESIZE_UI(14));
                make.left.equalTo(row13View.mas_left).with.offset(RESIZE_UI(20)+RESIZE_UI(20+_buttonwidth)*i);
                make.width.height.mas_offset(_buttonwidth);
            }];
        }
    }
    
    //票面图片
    UIView *row13HuoView = [[UIView alloc]init];
    row13HuoView.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row13HuoView];
    if (_identifier == 1) {
        [row13HuoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(row12View.mas_bottom).with.offset(RESIZE_UI(10));
            make.left.equalTo(viewMain.mas_left);
            make.right.equalTo(viewMain.mas_right);
            make.height.mas_offset(RESIZE_UI(150));
        }];
    } else {
        [row13HuoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(row12View.mas_bottom).with.offset(RESIZE_UI(161));
            make.left.equalTo(viewMain.mas_left);
            make.right.equalTo(viewMain.mas_right);
            make.height.mas_offset(RESIZE_UI(150));
        }];
    }
    
    UILabel *businessLicenseTitle = [[UILabel alloc]init];
    businessLicenseTitle.text = @"票面图片";
    businessLicenseTitle.textColor = RGBA(102, 102, 102, 1.0);
    businessLicenseTitle.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [row13HuoView addSubview:businessLicenseTitle];
    [businessLicenseTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row13HuoView.mas_top).with.offset(RESIZE_UI(20));
        make.left.equalTo(row13HuoView.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    NSArray *piaomianImageArray = _applyRecordModel.img_front;
    for (int i=0; i<piaomianImageArray.count; i++) {
        NSDictionary *imageDic = piaomianImageArray[i];
        NSString *imageUrl = imageDic[@"img_url"];
        UIButton *imageButton = [[UIButton alloc]init];
        [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal];
        [row13HuoView addSubview:imageButton];
        [imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(businessLicenseTitle.mas_bottom).with.offset(RESIZE_UI(14));
            make.left.equalTo(row13HuoView.mas_left).with.offset(RESIZE_UI(20)+RESIZE_UI(20+_buttonwidth)*i);
            make.width.height.mas_offset(_buttonwidth);
        }];
    }

    //第十四行 背书图片
    UIView *row14View = [[UIView alloc]init];
    row14View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row14View];
    [row14View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row13HuoView.mas_bottom).with.offset(RESIZE_UI(1));
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(150));
    }];

    UILabel *beishuPicTitle = [[UILabel alloc]init];
    beishuPicTitle.text = @"背书图片";
    beishuPicTitle.textColor = RGBA(102, 102, 102, 1.0);
    beishuPicTitle.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [row14View addSubview:beishuPicTitle];
    [beishuPicTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row14View.mas_top).with.offset(RESIZE_UI(20));
        make.left.equalTo(row14View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    NSArray *beimainImageArray = _applyRecordModel.img_bg;
    for (int i=0; i<beimainImageArray.count; i++) {
        NSDictionary *imageDic = beimainImageArray[i];
        NSString *imageUrl = imageDic[@"img_url"];
        UIButton *imageButton = [[UIButton alloc]init];
        [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal];
        [row14View addSubview:imageButton];
        [imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(beishuPicTitle.mas_bottom).with.offset(RESIZE_UI(14));
            make.left.equalTo(row14View.mas_left).with.offset(RESIZE_UI(20)+RESIZE_UI(20+_buttonwidth)*i);
            make.width.height.mas_offset(_buttonwidth);
        }];
    }
    
    //第十五行 审核反馈标题
    if ([_applyRecordModel.status isEqualToString:@"0"] || [[SingletonManager convertNullString:_applyRecordModel.audit] isEqualToString:@""]) {
        [viewMain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(row14View.mas_bottom);
        }];
    } else {
        UIView *row15View = [[UIView alloc]init];
        row15View.backgroundColor = [UIColor whiteColor];
        [viewMain addSubview:row15View];
        [row15View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(row14View.mas_bottom).with.offset(RESIZE_UI(10));
            make.left.equalTo(viewMain.mas_left);
            make.right.equalTo(viewMain.mas_right);
            make.height.mas_offset(RESIZE_UI(50));
        }];
        
        UILabel *shenheTitle = [[UILabel alloc]init];
        shenheTitle.text = @"审核反馈";
        shenheTitle.textColor = RGBA(102, 102, 102, 1.0);
        shenheTitle.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        [row15View addSubview:shenheTitle];
        [shenheTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(row15View.mas_centerY);
            make.left.equalTo(row15View.mas_left).with.offset(RESIZE_UI(20));
        }];
        
        //第十六行 审核反馈详情
        UIView *row16View = [[UIView alloc]init];
        row16View.backgroundColor = [UIColor whiteColor];
        [viewMain addSubview:row16View];
        [row16View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(row15View.mas_bottom).with.offset(RESIZE_UI(1));
            make.left.equalTo(viewMain.mas_left);
            make.right.equalTo(viewMain.mas_right);
            make.height.mas_offset(RESIZE_UI(100));
        }];
        
        UITextView *shenheTextView = [[UITextView alloc]init];
        shenheTextView.text = _applyRecordModel.audit;
        shenheTextView.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        if ([_applyRecordModel.status isEqualToString:@"1"]) {
            shenheTextView.textColor = NAVBARCOLOR;
        } else {
            shenheTextView.textColor = RGBA(243, 39, 68, 1.0);
        }
        [row16View addSubview:shenheTextView];
        [shenheTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(row16View.mas_top).with.offset(RESIZE_UI(14));
            make.left.equalTo(row16View.mas_left).with.offset(RESIZE_UI(20));
            make.right.equalTo(row16View.mas_right).with.offset(-RESIZE_UI(20));
            make.bottom.equalTo(row16View.mas_bottom).with.offset(-RESIZE_UI(30));
        }];
        
        [viewMain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(row16View.mas_bottom);
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
