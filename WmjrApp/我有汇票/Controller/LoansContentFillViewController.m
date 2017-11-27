//
//  LoansContentFillViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/11/20.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "LoansContentFillViewController.h"
#import "LoansFilledSuccessViewController.h"
#import "ZLPhotoActionSheet.h"
#import "ZLPhotoConfiguration.h"

#define defaultInputColor RGBA(60, 60, 60, 1.0)
#define errorInputColor [UIColor redColor]

@interface LoansContentFillViewController ()<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong)UIButton *commitApplyButton;
@property (nonatomic, strong)UITextField *inputLoansMoney;//借款金额
@property (nonatomic, strong)UILabel *loansMoneyUnitLabel;//配合inputLoansMoney
@property (nonatomic, strong)UITextField *inputLoansDuration;//借款期限
@property (nonatomic, strong)UILabel *loansDurationUnitLabel;//配合inputLoansDuration
@property (nonatomic, strong)UITextField *inputApplyName;//申请人姓名
@property (nonatomic, strong)UITextField *inputApplyPhone;//申请人电话
@property (nonatomic, strong)UITextField *inputProfession;//申请人职业
@property (nonatomic, strong)UITextField *inputEnterpriseName;//企业名称
@property (nonatomic, strong)UITextField *inputYearIncome;//申请人年收入
@property (nonatomic, strong)UILabel *yearIncomeUnitLabel;//配合inputYearIncome
@property (nonatomic, strong)UITextView *loansUseTextView;//借款用途
@property (nonatomic, strong)UITextView *danbaoSelectTextView;//担保措施用途

@property (nonatomic, strong)UIView *row6View;
@property (nonatomic, strong)UILabel *tip6Label;
@property (nonatomic, strong)UILabel *unselectTip6;//提示营业执照图片
@property (nonatomic, assign)CGFloat buttonwidth;

@property (nonatomic, strong)UIImage *yingyezhizhaoImage1;
@property (nonatomic, strong)UIImage *yingyezhizhaoImage2;

@property (nonatomic, assign)NSInteger day;//到期天数差


@property (nonatomic, strong)UIButton *idCardButton1;
@property (nonatomic, strong)UIButton *idCardDeleteButton1;
@property (nonatomic, strong)UIButton *idCardButton2;
@property (nonatomic, strong)UIButton *idCardDeleteButton2;
@property (nonatomic, strong)UIImage *select1;
@property (nonatomic, strong)UIImage *select2;

@end

@implementation LoansContentFillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"借款信息填写";
    _buttonwidth = (SCREEN_WIDTH-RESIZE_UI(100))/4;
    [self setUpLayout];
}

#pragma mark - 界面布局
- (void)setUpLayout {
    
    _commitApplyButton = [[UIButton alloc]init];
    [_commitApplyButton setTitle:@"提交申请" forState:UIControlStateNormal];
    [_commitApplyButton setBackgroundColor:RGBA(255, 88, 26, 1.0)];
    [_commitApplyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commitApplyButton addTarget:self action:@selector(commitLoansMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commitApplyButton];
    [_commitApplyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(RESIZE_UI(49));
    }];
    
    UIScrollView *scrollViewMain = [[UIScrollView alloc]init];
    [self.view addSubview:scrollViewMain];
    [scrollViewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(_commitApplyButton.mas_top);
    }];
    
    UIView *viewMain = [[UIView alloc]init];
    viewMain.backgroundColor = RGBA(237, 240, 242, 1.0);
    [scrollViewMain addSubview:viewMain];
    [viewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollViewMain);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    //第一行
    UIView *row1View = [[UIView alloc]init];
    row1View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row1View];
    [row1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewMain.mas_top);
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_equalTo(RESIZE_UI(70));
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"借款金额";
    label1.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label1.textColor = RGBA(102, 102, 102, 1.0);
    [row1View addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row1View.mas_top).with.offset(RESIZE_UI(20));
        make.left.equalTo(row1View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _loansMoneyUnitLabel = [[UILabel alloc]init];
    _loansMoneyUnitLabel.text = @"";//@" 元"
    _loansMoneyUnitLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [row1View addSubview:_loansMoneyUnitLabel];
    [_loansMoneyUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row1View.mas_top).with.offset(RESIZE_UI(20));
        make.right.equalTo(row1View.mas_right).with.offset(-RESIZE_UI(20));
    }];
    
    _inputLoansMoney = [[UITextField alloc]init];
    _inputLoansMoney.placeholder = @"请输入借款面额(元)";
    _inputLoansMoney.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputLoansMoney.textAlignment = NSTextAlignmentRight;
    _inputLoansMoney.keyboardType = UIKeyboardTypeDecimalPad;
    _inputLoansMoney.tag = 1;
    _inputLoansMoney.delegate = self;
    [_inputLoansMoney addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [row1View addSubview:_inputLoansMoney];
    [_inputLoansMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row1View.mas_top).with.offset(RESIZE_UI(20));
        make.right.equalTo(_loansMoneyUnitLabel.mas_left);
        make.width.mas_offset(RESIZE_UI(160));
    }];
    
    UILabel *tip1Label = [[UILabel alloc]init];
    tip1Label.text = [NSString stringWithFormat:@"注:借款金额需小于等于票面金额%@元",_piaojuMoney];
    tip1Label.textColor = RGBA(153, 153, 153, 1.0);
    tip1Label.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
    [row1View addSubview:tip1Label];
    [tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(row1View.mas_bottom).with.offset(-RESIZE_UI(5));
        make.left.equalTo(row1View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    //第二行
    UIView *row2View = [[UIView alloc]init];
    row2View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row2View];
    [row2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row1View.mas_bottom).with.offset(1);
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(70));
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"借款期限";
    label2.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label2.textColor = RGBA(102, 102, 102, 1.0);
    [row2View addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row2View.mas_top).with.offset(RESIZE_UI(20));
        make.left.equalTo(row2View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _loansDurationUnitLabel = [[UILabel alloc]init];
    _loansDurationUnitLabel.text = @"";//@" 天"
    _loansDurationUnitLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [row2View addSubview:_loansDurationUnitLabel];
    [_loansDurationUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row2View.mas_top).with.offset(RESIZE_UI(20));
        make.right.equalTo(row2View.mas_right).with.offset(-RESIZE_UI(20));
    }];
    
    _inputLoansDuration = [[UITextField alloc]init];
    _inputLoansDuration.placeholder = @"请输入借款期限(天)";
    _inputLoansDuration.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputLoansDuration.textAlignment = NSTextAlignmentRight;
    _inputLoansDuration.keyboardType = UIKeyboardTypeDecimalPad;
    _inputLoansDuration.tag = 2;
    _inputLoansDuration.delegate = self;
    [_inputLoansDuration addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [row2View addSubview:_inputLoansDuration];
    [_inputLoansDuration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row2View.mas_top).with.offset(RESIZE_UI(20));
        make.right.equalTo(_loansDurationUnitLabel.mas_left);
        make.width.mas_offset(RESIZE_UI(160));
    }];
    
    _day = [SingletonManager getTheCountOfTwoDaysWithBeginDate:[NSDate date] endDate:_selectDate];
    UILabel *tip2Label = [[UILabel alloc]init];
    tip2Label.text = [NSString stringWithFormat:@"注:借款期限需要小于等于票据到期期限%ld天",(long)_day];
    tip2Label.textColor = RGBA(153, 153, 153, 1.0);
    tip2Label.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
    [row2View addSubview:tip2Label];
    [tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(row2View.mas_bottom).with.offset(-RESIZE_UI(5));
        make.left.equalTo(row2View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    //第三行
    UIView *row3View = [[UIView alloc]init];
    row3View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row3View];
    [row3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row2View.mas_bottom).with.offset(1);
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(60));
    }];
    
    UILabel *label3 = [[UILabel alloc]init];
    if (_identifier == 1) {
        label3.text = @"申请人姓名";
    } else {
        label3.text = @"联系人姓名";
    }
    label3.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label3.textColor = RGBA(102, 102, 102, 1.0);
    [row3View addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row3View);
        make.left.equalTo(row3View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _inputApplyName = [[UITextField alloc]init];
    if (_identifier == 1) {
        _inputApplyName.placeholder = @"请输入申请人姓名";
    } else {
        _inputApplyName.placeholder = @"请输入联系人姓名";
    }
    _inputApplyName.tag = 4;
    _inputApplyName.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputApplyName.textAlignment = NSTextAlignmentRight;
    _inputApplyName.delegate = self;
    [_inputApplyName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [row3View addSubview:_inputApplyName];
    [_inputApplyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row3View);
        make.right.equalTo(row3View.mas_right).with.offset(-RESIZE_UI(20));
        make.width.mas_offset(RESIZE_UI(160));
    }];
    
    //第四行
    UIView *row4View = [[UIView alloc]init];
    row4View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row4View];
    [row4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row3View.mas_bottom).with.offset(1);
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(60));
    }];
    
    UILabel *label4 = [[UILabel alloc]init];
    if (_identifier == 1) {
        label4.text = @"申请人电话";
    } else {
        label4.text = @"联系人电话";
    }
    label4.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label4.textColor = RGBA(102, 102, 102, 1.0);
    [row4View addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row4View);
        make.left.equalTo(row4View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _inputApplyPhone = [[UITextField alloc]init];
    if (_identifier == 1) {
        _inputApplyPhone.placeholder = @"请输入申请人电话";
    } else {
        _inputApplyPhone.placeholder = @"请输入联系人电话";
    }
    _inputApplyPhone.tag = 5;
    _inputApplyPhone.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputApplyPhone.textAlignment = NSTextAlignmentRight;
    _inputApplyPhone.keyboardType = UIKeyboardTypeNumberPad;
    _inputApplyPhone.delegate = self;
    [_inputApplyPhone addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [row4View addSubview:_inputApplyPhone];
    [_inputApplyPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row4View);
        make.right.equalTo(row4View.mas_right).with.offset(-RESIZE_UI(20));
        make.width.mas_offset(RESIZE_UI(160));
    }];
    
    //第五行
    UIView *row5View = [[UIView alloc]init];
    row5View.backgroundColor = [UIColor whiteColor];
    CGFloat height;
    if (_identifier == 1) {
        height = RESIZE_UI(60);
    } else {
        height = RESIZE_UI(70);
    }
    [viewMain addSubview:row5View];
    [row5View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row4View.mas_bottom).with.offset(1);
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(height);
    }];
    
    if (_identifier == 1) {
        UILabel *label5 = [[UILabel alloc]init];
        label5.text = @"职业(选填项)";
        label5.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        label5.textColor = RGBA(102, 102, 102, 1.0);
        [row5View addSubview:label5];
        [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(row5View);
            make.left.equalTo(row5View.mas_left).with.offset(RESIZE_UI(20));
        }];
        
        _inputProfession = [[UITextField alloc]init];
        _inputProfession.placeholder = @"请输入申请人职业";
        _inputProfession.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        _inputProfession.textAlignment = NSTextAlignmentRight;
        _inputProfession.delegate = self;
        [row5View addSubview:_inputProfession];
        [_inputProfession mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(row5View);
            make.right.equalTo(row5View.mas_right).with.offset(-RESIZE_UI(20));
            make.width.mas_offset(RESIZE_UI(160));
        }];
    } else {
        UILabel *label5 = [[UILabel alloc]init];
        label5.text = @"企业名称";
        label5.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        label5.textColor = RGBA(102, 102, 102, 1.0);
        [row5View addSubview:label5];
        [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(row5View.mas_top).with.offset(RESIZE_UI(20));
            make.left.equalTo(row5View.mas_left).with.offset(RESIZE_UI(20));
        }];
        
        _inputEnterpriseName = [[UITextField alloc]init];
        _inputEnterpriseName.placeholder = @"请输入企业名称";
        _inputEnterpriseName.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        _inputEnterpriseName.textAlignment = NSTextAlignmentRight;
        _inputEnterpriseName.tag = 6;
        _inputEnterpriseName.delegate = self;
        [_inputEnterpriseName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [row5View addSubview:_inputEnterpriseName];
        [_inputEnterpriseName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(row5View.mas_top).with.offset(RESIZE_UI(20));
            make.right.equalTo(row5View.mas_right).with.offset(-RESIZE_UI(20));
            make.width.mas_offset(RESIZE_UI(160));
        }];
        
        UILabel *tip3Label = [[UILabel alloc]init];
        tip3Label.text = @"注:企业名称需与营业执照上名称保持一致";
        tip3Label.textColor = RGBA(153, 153, 153, 1.0);
        tip3Label.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
        [row5View addSubview:tip3Label];
        [tip3Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(row5View.mas_bottom).with.offset(-RESIZE_UI(5));
            make.left.equalTo(row5View.mas_left).with.offset(RESIZE_UI(20));
        }];
    }
    
    //第六行
    _row6View = [[UIView alloc]init];
    _row6View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:_row6View];
    if (_identifier == 1) {
        [_row6View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(row5View.mas_bottom).with.offset(1);
            make.left.equalTo(viewMain.mas_left);
            make.right.equalTo(viewMain.mas_right);
            make.height.mas_offset(RESIZE_UI(60));
        }];
        
        UILabel *label6 = [[UILabel alloc]init];
        label6.text = @"年收入(选填项)";
        label6.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        label6.textColor = RGBA(102, 102, 102, 1.0);
        [_row6View addSubview:label6];
        [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_row6View);
            make.left.equalTo(_row6View.mas_left).with.offset(RESIZE_UI(20));
        }];
        
        _yearIncomeUnitLabel = [[UILabel alloc]init];
        _yearIncomeUnitLabel.text = @"";//@" 万"
        _yearIncomeUnitLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        [_row6View addSubview:_yearIncomeUnitLabel];
        [_yearIncomeUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_row6View);
            make.right.equalTo(_row6View.mas_right).with.offset(-RESIZE_UI(20));
        }];
        
        _inputYearIncome = [[UITextField alloc]init];
        _inputYearIncome.placeholder = @"请输入申请人年收入(万)";
        _inputYearIncome.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        _inputYearIncome.textAlignment = NSTextAlignmentRight;
        _inputYearIncome.keyboardType = UIKeyboardTypeDecimalPad;
        _inputYearIncome.tag = 3;
        _inputYearIncome.delegate = self;
        [_inputYearIncome addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_row6View addSubview:_inputYearIncome];
        [_inputYearIncome mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_row6View);
            make.right.equalTo(_yearIncomeUnitLabel.mas_left);
            make.width.mas_offset(RESIZE_UI(170));
        }];
    } else {
        [viewMain addSubview:_row6View];
        [_row6View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(row5View.mas_bottom).with.offset(1);
            make.left.equalTo(viewMain.mas_left);
            make.right.equalTo(viewMain.mas_right);
            make.height.mas_offset(RESIZE_UI(180));
        }];
        
        UILabel *label6 = [[UILabel alloc]init];
        label6.text = @"营业执照正副本";
        label6.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        label6.textColor = RGBA(102, 102, 102, 1.0);
        [_row6View addSubview:label6];
        [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_row6View.mas_top).with.offset(RESIZE_UI(20));
            make.left.equalTo(_row6View.mas_left).with.offset(RESIZE_UI(20));
        }];
        
        _unselectTip6 = [[UILabel alloc]init];
        _unselectTip6.text = @"请上传营业执照正副本";
        _unselectTip6.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        _unselectTip6.textColor = [UIColor redColor];
        _unselectTip6.hidden = YES;
        [_row6View addSubview:_unselectTip6];
        [_unselectTip6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label6.mas_centerY);
            make.right.equalTo(_row6View.mas_right).with.offset(-RESIZE_UI(20));
        }];
        
        _tip6Label = [[UILabel alloc]init];
        _tip6Label.text = @"(请保持照片信息清晰,勿进行修图软件处理)";
        _tip6Label.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
        _tip6Label.textColor = RGBA(153, 153, 153, 1.0);
        [_row6View addSubview:_tip6Label];
        [_tip6Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label6.mas_bottom).with.offset(RESIZE_UI(30));
            make.left.equalTo(_row6View.mas_left).with.offset(RESIZE_UI(20));
        }];
        
        _idCardButton1 = [[UIButton alloc]init];
        _idCardButton1.tag = 1;
        [_idCardButton1 setBackgroundImage:[UIImage imageNamed:@"addpic"] forState:UIControlStateNormal];
        [_idCardButton1 addTarget:self action:@selector(selectHeadImageMethod:) forControlEvents:UIControlEventTouchUpInside];
        [_row6View addSubview:_idCardButton1];
        [_idCardButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tip6Label.mas_bottom).with.offset(RESIZE_UI(5));
            make.left.equalTo(_row6View.mas_left).with.offset(RESIZE_UI(20));
            make.width.height.mas_offset(RESIZE_UI(72));
        }];
        
        _idCardButton2 = [[UIButton alloc]init];
        _idCardButton2.tag = 2;
        [_idCardButton2 setBackgroundImage:[UIImage imageNamed:@"addpic"] forState:UIControlStateNormal];
        [_idCardButton2 addTarget:self action:@selector(selectHeadImageMethod:) forControlEvents:UIControlEventTouchUpInside];
        [_row6View addSubview:_idCardButton2];
        [_idCardButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tip6Label.mas_bottom).with.offset(RESIZE_UI(5));
            make.left.equalTo(_idCardButton1.mas_right).with.offset(RESIZE_UI(20));
            make.width.height.mas_offset(RESIZE_UI(72));
        }];
    }
    
    //第七行
    UIView *row7View = [[UIView alloc]init];
    row7View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row7View];
    [row7View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_row6View.mas_bottom).with.offset(1);
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(180));
    }];
    
    UILabel *label7 = [[UILabel alloc]init];
    label7.text = @"借款用途";
    label7.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label7.textColor = RGBA(102, 102, 102, 1.0);
    [row7View addSubview:label7];
    [label7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row7View.mas_top).with.offset(RESIZE_UI(20));
        make.left.equalTo(row7View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    UILabel *label7Tip = [[UILabel alloc]init];
    label7Tip.text = @"(选填项)";
    label7Tip.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label7Tip.textColor = RGBA(153, 153, 153, 1.0);
    [row7View addSubview:label7Tip];
    [label7Tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label7.mas_centerY);
        make.left.equalTo(label7.mas_right);
    }];
    
    _loansUseTextView = [[UITextView alloc]init];
    _loansUseTextView.text = @"借款用途描述，200字以内";
    _loansUseTextView.textColor = RGBA(199, 199, 204, 1.0);
    _loansUseTextView.layer.borderWidth = 1.0;;
    _loansUseTextView.layer.borderColor = RGBA(136, 136, 136, 1.0).CGColor;
    _loansUseTextView.tag = 1;
    _loansUseTextView.delegate = self;
    [row7View addSubview:_loansUseTextView];
    [_loansUseTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label7.mas_bottom).with.offset(RESIZE_UI(10));
        make.left.equalTo(row7View.mas_left).with.offset(RESIZE_UI(20));
        make.right.equalTo(row7View.mas_right).with.offset(-RESIZE_UI(20));
        make.height.mas_offset(RESIZE_UI(110));
    }];
    
    //第八行
    UIView *row8View = [[UIView alloc]init];
    row8View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row8View];
    [row8View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row7View.mas_bottom).with.offset(1);
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(180));
    }];
    
    UILabel *label8 = [[UILabel alloc]init];
    label8.text = @"担保措施选择";
    label8.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label8.textColor = RGBA(102, 102, 102, 1.0);
    [row8View addSubview:label8];
    [label8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row8View.mas_top).with.offset(RESIZE_UI(20));
        make.left.equalTo(row8View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    UILabel *label8Tip = [[UILabel alloc]init];
    label8Tip.text = @"(选填项)";
    label8Tip.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label8Tip.textColor = RGBA(153, 153, 153, 1.0);
    [row8View addSubview:label8Tip];
    [label8Tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label8.mas_centerY);
        make.left.equalTo(label8.mas_right);
    }];
    
    UIImageView *selectZhiya = [[UIImageView alloc]init];
    selectZhiya.image = [UIImage imageNamed:@"icon_done_blue"];
    [row8View addSubview:selectZhiya];
    [selectZhiya mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label8.mas_bottom).with.offset(RESIZE_UI(5));
        make.left.equalTo(row8View.mas_left).with.offset(RESIZE_UI(20));
        make.width.height.mas_offset(RESIZE_UI(14));
    }];
    
    UILabel *tip8Label = [[UILabel alloc]init];
    tip8Label.text = @"票据质押";
    tip8Label.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    tip8Label.textColor = RGBA(153, 153, 153, 1.0);
    [row8View addSubview:tip8Label];
    [tip8Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectZhiya.mas_centerY);
        make.left.equalTo(selectZhiya.mas_right).with.offset(RESIZE_UI(8));
    }];
    
    _danbaoSelectTextView = [[UITextView alloc]init];
    _danbaoSelectTextView.text = @"担保措施描述，200字以内";
    _danbaoSelectTextView.textColor = RGBA(199, 199, 204, 1.0);
    _danbaoSelectTextView.layer.borderWidth = 1.0;;
    _danbaoSelectTextView.layer.borderColor = RGBA(136, 136, 136, 1.0).CGColor;
    _danbaoSelectTextView.tag = 2;
    _danbaoSelectTextView.delegate = self;
    [row8View addSubview:_danbaoSelectTextView];
    [_danbaoSelectTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip8Label.mas_bottom).with.offset(RESIZE_UI(10));
        make.left.equalTo(row8View.mas_left).with.offset(RESIZE_UI(20));
        make.right.equalTo(row8View.mas_right).with.offset(-RESIZE_UI(20));
        make.height.mas_offset(RESIZE_UI(110));
    }];
    
    [viewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(row8View.mas_bottom);
    }];
    
}

#pragma mark - 监听textfield
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:_inputLoansMoney]) {
        textField.placeholder = @"请输入借款面额(元)";
    }
    if ([textField isEqual:_inputLoansDuration]) {
        textField.placeholder = @"请输入借款期限(天)";
    }
    if ([textField isEqual:_inputApplyName]) {
        textField.placeholder = @"请输入申请人姓名";
    }
    if ([textField isEqual:_inputApplyPhone]) {
        textField.placeholder = @"请输入申请人电话";
    }
    if ([textField isEqual:_inputProfession]) {
        textField.placeholder = @"请输入申请人职业";
    }
    if ([textField isEqual:_inputYearIncome]) {
        textField.placeholder = @"请输入申请人年收入(万)";
    }
}

-(void)textFieldDidChange :(UITextField *)theTextField {
    
    if ([theTextField isEqual:_inputLoansMoney]) {
        _loansMoneyUnitLabel.textColor = defaultInputColor;
        [self recoverPlaceholderMethod:_inputLoansMoney];
    }
    if ([theTextField isEqual:_inputLoansDuration]) {
        [self recoverPlaceholderMethod:_inputLoansDuration];
        _loansDurationUnitLabel.textColor = defaultInputColor;
    }
    if ([theTextField isEqual:_inputApplyName]) {
        [self recoverPlaceholderMethod:_inputApplyName];
    }
    if ([theTextField isEqual:_inputApplyPhone]) {
        [self recoverPlaceholderMethod:_inputApplyPhone];
    }
    if ([theTextField isEqual:_inputEnterpriseName]) {
        [self recoverPlaceholderMethod:_inputEnterpriseName];
    }
    
    if ([theTextField.text isEqualToString:@""]) {
        switch (theTextField.tag) {
            case 1:
                _loansMoneyUnitLabel.text = @"";
                break;
            case 2:
                _loansDurationUnitLabel.text = @"";
                break;
            case 3:
                _yearIncomeUnitLabel.text = @"";
                break;
                
            default:
                break;
        }
    } else {
        switch (theTextField.tag) {
            case 1:
            {
                _loansMoneyUnitLabel.text = @" 元";
                CGFloat money = [_inputLoansMoney.text floatValue];
                CGFloat bottomMoney = [_piaojuMoney floatValue];
                NSString *tipString = [NSString stringWithFormat:@"借款金额需小于等于票面金额%.2f元",bottomMoney];
                if (money>bottomMoney) {
                    [self changgePlaceholderMethod:_inputLoansMoney];
                    _loansMoneyUnitLabel.textColor = errorInputColor;
                    [[SingletonManager sharedManager] showHUDView:self.view title:@"提示" content:tipString time:1.0 andCodes:^{
                        
                    }];
                    return;
                } else {
//                    NSLog(@"ok的");
                    [self recoverPlaceholderMethod:_inputLoansMoney];
                    _loansMoneyUnitLabel.textColor = defaultInputColor;
                }
            }
                break;
            case 2:
            {
                _loansDurationUnitLabel.text = @" 天";
                NSInteger needDay = [_inputLoansDuration.text integerValue];
                NSString *tipString = [NSString stringWithFormat:@"借款期限需小于等于票据期限%ld天",(long)_day];
                if (needDay>_day) {
                    [self changgePlaceholderMethod:_inputLoansDuration];
                    _loansDurationUnitLabel.textColor = errorInputColor;
                    [[SingletonManager sharedManager] showHUDView:self.view title:tipString content:@"" time:1.0 andCodes:^{
                        
                    }];
                    return;
                } else {
                    [self recoverPlaceholderMethod:_inputLoansDuration];
                    _loansDurationUnitLabel.textColor = defaultInputColor;
                }
            }
                break;
            case 3:
                _yearIncomeUnitLabel.text = @" 万";
                break;
                
            default:
                break;
        }
    }
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    switch (textView.tag) {
        case 1:
        {
            textView.textColor = RGBA(60, 60, 60, 1.0);
            if ([textView.text isEqualToString:@"借款用途描述，200字以内"]) {
                textView.text = @"";
            }
        }
            break;
        case 2:
        {
            textView.textColor = RGBA(60, 60, 60, 1.0);
            if ([textView.text isEqualToString:@"担保措施描述，200字以内"]) {
                textView.text = @"";
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    switch (textView.tag) {
        case 1:
        {
            if(textView.text.length < 1){
                textView.text = @"借款用途描述，200字以内";
                textView.textColor = RGBA(199, 199, 204, 1.0);
            }
            if (![textView.text isEqualToString:@"借款用途描述，200字以内"]) {
                textView.textColor = RGBA(60, 60, 60, 1.0);
            } else {
                textView.textColor = RGBA(199, 199, 204, 1.0);
            }
        }
            break;
        case 2:
        {
            if(textView.text.length < 1){
                textView.text = @"担保措施描述，200字以内";
                textView.textColor = RGBA(199, 199, 204, 1.0);
            }
            if (![textView.text isEqualToString:@"担保措施描述，200字以内"]) {
                textView.textColor = RGBA(60, 60, 60, 1.0);
            } else {
                textView.textColor = RGBA(199, 199, 204, 1.0);
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 选择图片
- (void)selectHeadImageMethod:(UIButton *)sender {
    
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
    
    //相册参数配置
    ZLPhotoConfiguration *configuration = [ZLPhotoConfiguration defaultPhotoConfiguration];
    configuration.maxSelectCount = 1;
    ac.configuration = configuration;
    
    //如调用的方法无sender参数，则该参数必传
    ac.sender = self;
    
    //选择回调
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        //your codes
        switch (sender.tag) {
            case 1:
            {
                [_idCardButton1 setBackgroundImage:images[0] forState:UIControlStateNormal];
                _select1 = images[0];
                _idCardDeleteButton1 = [[UIButton alloc]init];
                _idCardDeleteButton1.tag = 1;
                [_idCardDeleteButton1 setImage:[UIImage imageNamed:@"icon_del"] forState:UIControlStateNormal];
                [_idCardDeleteButton1 addTarget:self action:@selector(deleteSelectImage:) forControlEvents:UIControlEventTouchUpInside];
                [_idCardButton1 addSubview:_idCardDeleteButton1];
                [_idCardDeleteButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(_idCardButton1);
                }];
            }
                break;
            case 2:
            {
                [_idCardButton2 setBackgroundImage:images[0] forState:UIControlStateNormal];
                _select2 = images[0];
                _idCardDeleteButton2 = [[UIButton alloc]init];
                _idCardDeleteButton2.tag = 2;
                [_idCardDeleteButton2 setImage:[UIImage imageNamed:@"icon_del"] forState:UIControlStateNormal];
                [_idCardDeleteButton2 addTarget:self action:@selector(deleteSelectImage:) forControlEvents:UIControlEventTouchUpInside];
                [_idCardButton2 addSubview:_idCardDeleteButton2];
                [_idCardDeleteButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(_idCardButton2);
                }];
            }
                break;
                
            default:
                break;
        }
        if (_select1 && _select2) {
            _unselectTip6.hidden = YES;
        }
    }];
    
    //调用相册
    [ac showPreviewAnimated:YES];
    
}

- (void)deleteSelectImage:(UIButton *)btn {
    switch (btn.tag) {
        case 1:
        {
            [_idCardDeleteButton1 removeFromSuperview];
            _idCardDeleteButton1 = nil;
            [_idCardButton1 setBackgroundImage:[UIImage imageNamed:@"addpic"] forState:UIControlStateNormal];
            _select1 = nil;
        }
            break;
        case 2:
        {
            [_idCardDeleteButton2 removeFromSuperview];
            _idCardDeleteButton2 = nil;
            [_idCardButton2 setBackgroundImage:[UIImage imageNamed:@"addpic"] forState:UIControlStateNormal];
            _select2 = nil;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 提交信息
- (void)commitLoansMethod {
    
    [_commitApplyButton setUserInteractionEnabled:NO];
    CGFloat money = [_inputLoansMoney.text floatValue];
    CGFloat bottomMoney = [_piaojuMoney floatValue];
    NSInteger needDay = [_inputLoansDuration.text integerValue];
    
    if ([_inputLoansMoney.text isEqualToString:@""] || ![SingletonManager isPureFloat:_inputLoansMoney.text]) {
        _loansMoneyUnitLabel.textColor = [UIColor redColor];
        [self changgePlaceholderMethod:_inputLoansMoney];
        [[SingletonManager sharedManager] showHUDView:self.view title:@"请输入借款金额" content:@"" time:1.0 andCodes:^{
            [_commitApplyButton setUserInteractionEnabled:YES];
        }];
    } else if (money>bottomMoney) {
        NSString *tipString = [NSString stringWithFormat:@"借款金额需小于等于票面金额%.2f元",bottomMoney];
        [[SingletonManager sharedManager] showHUDView:self.view title:@"提示" content:tipString time:1.0 andCodes:^{
            [_commitApplyButton setUserInteractionEnabled:YES];
        }];
    }  else if ([_inputLoansDuration.text isEqualToString:@""] || ![SingletonManager isPureFloat:_inputLoansDuration.text]) {
        [[SingletonManager sharedManager] showHUDView:self.view title:@"请输入借款期限" content:@"" time:1.0 andCodes:^{
            [_commitApplyButton setUserInteractionEnabled:YES];
        }];
    } else if (needDay>_day) {
        NSString *tipString = [NSString stringWithFormat:@"借款期限需小于等于票据期限%ld天",(long)_day];
        [[SingletonManager sharedManager] showHUDView:self.view title:@"提示" content:tipString time:1.0 andCodes:^{
            [_commitApplyButton setUserInteractionEnabled:YES];
        }];
    }else if ([_inputApplyName.text isEqualToString:@""]) {
        NSString *tip;
        if (_identifier == 1) {
            tip = @"请输入申请人姓名";
        } else {
            tip = @"请输入联系人姓名";
        }
        [self changgePlaceholderMethod:_inputApplyName];
        [[SingletonManager sharedManager] showHUDView:self.view title:tip content:@"" time:1.0 andCodes:^{
            [_commitApplyButton setUserInteractionEnabled:YES];
        }];
    }
//    else if ([_inputApplyPhone.text isEqualToString:@""] || _inputApplyPhone.text.length != 11 || ![SingletonManager isPureInt:_inputApplyPhone.text]) {
//        NSString *tip;
//        if (_identifier == 1) {
//            tip = @"请输入正确的申请人电话";
//        } else {
//            tip = @"请输入正确的联系人电话";
//        }
//        [self changgePlaceholderMethod:_inputApplyPhone];
//        [[SingletonManager sharedManager] showHUDView:self.view title:tip content:@"" time:1.0 andCodes:^{
//            [_commitApplyButton setUserInteractionEnabled:YES];
//        }];
//    }
    else if (_loansUseTextView.text.length>200) {
        [[SingletonManager sharedManager] showHUDView:self.view title:@"借款用途描述200字以内" content:@"" time:1.0 andCodes:^{
            [_commitApplyButton setUserInteractionEnabled:YES];
        }];
    } else if (_danbaoSelectTextView.text.length>200) {
        [[SingletonManager sharedManager] showHUDView:self.view title:@"担保措施描述200字以内" content:@"" time:1.0 andCodes:^{
            [_commitApplyButton setUserInteractionEnabled:YES];
        }];
    } else {
        if (_identifier == 2) {
            if ([_inputEnterpriseName.text isEqualToString:@""]) {
                [self changgePlaceholderMethod:_inputEnterpriseName];
                [[SingletonManager sharedManager] showHUDView:self.view title:@"请输入企业名称" content:@"" time:1.0 andCodes:^{
                    [_commitApplyButton setUserInteractionEnabled:YES];
                }];
            } else if (!_select1 || !_select2) {
                _unselectTip6.hidden = NO;
                [[SingletonManager sharedManager] showHUDView:self.view title:@"请上传营业执照正副本" content:@"" time:1.0 andCodes:^{
                    [_commitApplyButton setUserInteractionEnabled:YES];
                }];
            } else {
                //网络请求
                [self sendMessageMethod];
            }
        } else {
            //网络请求
            [self sendMessageMethod];
        }
    }
    
}

#pragma mark - 网络请求
- (void)sendMessageMethod {
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NetManager *manager = [[NetManager alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"member_id"] = [SingletonManager sharedManager].uid;
    dict[@"member_type"] = @(_identifier);
    dict[@"bill_type"] = @(_typeTag);
    dict[@"money"] = _piaojuMoney;
    dict[@"returnrate"] = _respectRate;
    dict[@"end_time"] = _piaojuDate;
    dict[@"acceptor"] = _chengduiObject;
    dict[@"borrow_money"] = _inputLoansMoney.text;
    dict[@"borrow_day"] = _inputLoansDuration.text;
    dict[@"borrow_name"] = _inputApplyName.text;
    dict[@"borrow_phone"] = _inputApplyPhone.text;
    if (_identifier == 1) {
        dict[@"borrow_carrer"] = _inputProfession.text;
        dict[@"borrow_income"] = _inputYearIncome.text;
    } else {
        dict[@"enterprise_name"] = _inputEnterpriseName.text;
    }
    if ([_loansUseTextView.text isEqualToString:@"借款用途描述，200字以内"]) {
        dict[@"borrow_use"] = @"";
    } else {
        dict[@"borrow_use"] = _loansUseTextView.text;
    }
    if ([_danbaoSelectTextView.text isEqualToString:@"担保措施描述，200字以内"]) {
        dict[@"borrow_guarantee"] = @"";
    } else {
        dict[@"borrow_guarantee"] = _danbaoSelectTextView.text;
    }

    [SVProgressHUD showWithStatus:@"上传中"];
    NSArray *paramImagArray = [[NSArray alloc]init];//参数数组
    NSArray *imageSumArray = [[NSArray alloc]init];//图片数组
    paramImagArray = @[@"img_front[]",@"img_bg[]",@"img_enterprise[]"];
    NSMutableArray *piaoMianArry = [[NSMutableArray alloc]init];
    for (int i=0; i<_piaoMianImage.count; i++) {
        [piaoMianArry addObject:_piaoMianImage[i]];
    }
    NSArray *piaoA = [piaoMianArry copy];
    NSMutableArray *beishuArry = [[NSMutableArray alloc]init];
    for (int i=0; i<_beishuImage.count; i++) {
        [beishuArry addObject:_beishuImage[i]];
    }
    NSArray *beiA = [beishuArry copy];
    NSArray *yingyezhizhaoA = [[NSArray alloc]initWithObjects:_select1,_select2, nil];;
    imageSumArray = @[piaoA,beiA,yingyezhizhaoA];
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",  nil];//设置相应内容类型
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [httpManager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    NSString *dateNew = [manager getCurrentTimestamp];
    NSDictionary *paramDic = @{@"timestamp":dateNew, @"action":@"Bill/apply", @"data":dict};//参数序列
    NSString *base64Str = [manager paramCodeStr:paramDic];
    //@"file":@"ss"
    [httpManager POST:WMJRAPI parameters:@{@"msg":base64Str} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < paramImagArray.count; i++)
        {
            NSArray *imageArray = imageSumArray[i];
            for (int j=0; j<imageArray.count;j++) {
                NSData *imageData = UIImageJPEGRepresentation(imageArray[j], 1.0);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@ - %d.jpg", str,i];
                
                // 上传图片，以文件流的格式
                [formData appendPartWithFileData:imageData name:paramImagArray[i] fileName:fileName mimeType:@"image/jpeg"];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_commitApplyButton setUserInteractionEnabled:YES];
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        id obj = [manager paramUnCodeStr:responseStr];
        if (obj) {
            [SVProgressHUD dismiss];
            LoansFilledSuccessViewController *loansFillSuccessVC = [[LoansFilledSuccessViewController alloc]init];
            [self.navigationController pushViewController:loansFillSuccessVC animated:YES];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *msgStr = @"上传失败";
        [_commitApplyButton setUserInteractionEnabled:YES];
        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
        alertConfig.defaultTextOK = @"确定";
        [SVProgressHUD dismiss];
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
        [alertView show];
    }];
    
    
}
    

#pragma mark - 修改placeholder字体
- (void)changgePlaceholderMethod:(UITextField *)textField {
    [textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    //    [textField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    textField.textColor = [UIColor redColor];
    textField.text = textField.text;
}

#pragma mark - 恢复placeholder字体
- (void)recoverPlaceholderMethod:(UITextField *)textField {
    [textField setValue:RGBA(207, 207, 207, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    textField.textColor = defaultInputColor;
    textField.text = textField.text;
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
