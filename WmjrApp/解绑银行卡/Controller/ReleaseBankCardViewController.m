//
//  ReleaseBankCardViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/11/22.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "ReleaseBankCardViewController.h"
#import "ZLPhotoActionSheet.h"
#import "ZLPhotoConfiguration.h"
#import "ZHPickView.h"
#import "BankModel.h"
#import "ConfirmReleaseCardView.h"
#import "ReleaseSuccessCardView.h"
#import "ReleaseBankCardModel.h"

#define defaultInputColor RGBA(60, 60, 60, 1.0)

@interface ReleaseBankCardViewController ()<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong)UITextField *inputName;
@property (nonatomic, strong)UITextField *inputPhone;
@property (nonatomic, strong)UITextField *inputIdCard;
@property (nonatomic, strong)UITextField *inputBank;
@property (nonatomic, strong)UITextField *inputBankCard;
@property (nonatomic, strong)UIButton *idCardButton1;
@property (nonatomic, strong)UIButton *idCardDeleteButton1;
@property (nonatomic, strong)UIButton *idCardButton2;
@property (nonatomic, strong)UIButton *idCardDeleteButton2;
@property (nonatomic, strong)UILabel *unselectTipId;
@property (nonatomic, strong)UIButton *bankCardButton1;
@property (nonatomic, strong)UIButton *bankCardDeleteButton1;
@property (nonatomic, strong)UIButton *bankCardButton2;
@property (nonatomic, strong)UIButton *bankCardDeleteButton2;
@property (nonatomic, strong)UILabel *unselectTipBnak;

@property (nonatomic, strong)UIImage *select1;
@property (nonatomic, strong)UIImage *select2;
@property (nonatomic, strong)UIImage *select3;
@property (nonatomic, strong)UIImage *select4;

@property (nonatomic, assign)NSInteger selectTag;//选择的哪个按钮

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) NSMutableArray *bankArray;
@property (nonatomic, copy) NSString *bank_codeStr;//所属银行编号

@end

@implementation ReleaseBankCardViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ReleaseBankCardViewController"];
    self.tabBarController.tabBar.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.window = [[UIApplication sharedApplication].delegate window];
    _select1 = nil;
    _select2 = nil;
    _select3 = nil;
    _select4 = nil;
    [self setUpLayOut];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ReleaseBankCardViewController"];
}

#pragma mark - 界面布局
- (void)setUpLayOut {
    
    UIScrollView *mainScrollView = [[UIScrollView alloc]init];
    mainScrollView.backgroundColor = RGBA(240, 241, 243, 1.0);
    [self.view addSubview:mainScrollView];
    
    if (![_releaseBankModel.status isEqualToString:@"0"] && ![_releaseBankModel.status isEqualToString:@"2"]) {
        UIButton *nextStepButton = [[UIButton alloc]init];
        [nextStepButton setTitle:@"提交申请" forState:UIControlStateNormal];
        [nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextStepButton setBackgroundColor:RGBA(255, 88, 26, 1.0)];
        [nextStepButton addTarget:self action:@selector(confirmSubmit) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:nextStepButton];
        [nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.mas_offset(RESIZE_UI(49));
        }];
        
        [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(nextStepButton.mas_top);
        }];
    } else {
        [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    UIView *mainView = [[UIView alloc]init];
    mainView.backgroundColor = RGBA(237, 240, 242, 1.0);
    [mainScrollView addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    //第一行
    UIView *row1View = [[UIView alloc]init];
    row1View.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:row1View];
    
    if ([_releaseBankModel.status isEqualToString:@"0"] || [_releaseBankModel.status isEqualToString:@"2"]) {
        UIView *currentStateView = [[UIView alloc]init];
        currentStateView.backgroundColor = RGBA(237, 244, 247, 1.0);
        [mainView addSubview:currentStateView];
        [currentStateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mainView.mas_top);
            make.left.equalTo(mainView.mas_left);
            make.right.equalTo(mainView.mas_right);
            make.height.mas_offset(RESIZE_UI(60));
        }];
        
        UILabel *currentTitle = [[UILabel alloc]init];
        currentTitle.text = @"当前状态";
        currentTitle.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        currentTitle.textColor = RGBA(102, 102, 102, 1.0);
        [currentStateView addSubview:currentTitle];
        [currentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(currentStateView.mas_left).with.offset(RESIZE_UI(20));
            make.centerY.equalTo(currentStateView.mas_centerY);
        }];
        
        UILabel *currentContent = [[UILabel alloc]init];
        if ([_releaseBankModel.status isEqualToString:@"0"]) {
            currentContent.text = @"审核中";
        } else {
            currentContent.text = @"审核驳回";
        }
        currentContent.textColor = RGBA(255, 88, 26, 1.0);
        currentContent.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        [currentStateView addSubview:currentContent];
        [currentContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(currentStateView.mas_right).with.offset(-RESIZE_UI(12));
            make.centerY.equalTo(currentStateView.mas_centerY);
        }];
        
        if ([_releaseBankModel.status isEqualToString:@"0"]) {
            [row1View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(currentStateView.mas_bottom);
                make.left.equalTo(mainView.mas_left);
                make.right.equalTo(mainView.mas_right);
                make.height.mas_offset(RESIZE_UI(60));
            }];
        } else {
            UIView *checkResultView = [[UIView alloc]init];
            checkResultView.backgroundColor = [UIColor whiteColor];
            [mainView addSubview:checkResultView];
            [checkResultView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(currentStateView.mas_bottom);
                make.left.equalTo(mainView.mas_left);
                make.right.equalTo(mainView.mas_right);
                make.height.mas_offset(RESIZE_UI(60));
            }];
            
            UILabel *checkResultTitle = [[UILabel alloc]init];
            checkResultTitle.text = @"审核反馈";
            checkResultTitle.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
            checkResultTitle.textColor = RGBA(102, 102, 102, 1.0);
            [checkResultTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(checkResultView.mas_left).with.offset(RESIZE_UI(15));
                make.centerY.equalTo(checkResultView.mas_centerY);
            }];
            
            UIView *checkResultContentView = [[UIView alloc]init];
            checkResultContentView.backgroundColor = [UIColor whiteColor];
            [mainView addSubview:checkResultContentView];
            [checkResultContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(checkResultView.mas_bottom).with.offset(RESIZE_UI(1));
                make.left.equalTo(mainView.mas_left);
                make.right.equalTo(mainView.mas_right);
                make.height.mas_offset(RESIZE_UI(90));
            }];
            
            UITextView *textViewCheckResult = [[UITextView alloc]init];
//            textViewCheckResult.text = _releaseBankModel.audit;
            textViewCheckResult.text = @"您的银行卡卡今年对方那里看见女款链接安康链接啊看见你疯狂乱收费，所以审核未通过。您可以重新申请.";
            textViewCheckResult.textColor = RGBA(243, 39, 68, 1.0);
            textViewCheckResult.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
            [checkResultContentView addSubview:textViewCheckResult];
            [textViewCheckResult mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(checkResultContentView.mas_top).with.offset(RESIZE_UI(14));
                make.left.equalTo(checkResultContentView.mas_left).with.offset(RESIZE_UI(20));
                make.right.equalTo(checkResultContentView.mas_right).with.offset(-RESIZE_UI(20));
                make.bottom.equalTo(checkResultContentView.mas_bottom).with.offset(-RESIZE_UI(14));
            }];
            
            [row1View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(checkResultContentView.mas_bottom).with.offset(RESIZE_UI(14));
                make.left.equalTo(mainView.mas_left);
                make.right.equalTo(mainView.mas_right);
                make.height.mas_offset(RESIZE_UI(60));
            }];
            
        }
        
    }
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"用户姓名";
    label1.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label1.textColor = RGBA(102, 102, 102, 1.0);
    [row1View addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row1View);
        make.left.equalTo(row1View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _inputName = [[UITextField alloc]init];
    _inputName.placeholder = @"请输入用户姓名";
    _inputName.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputName.textAlignment = NSTextAlignmentRight;
    _inputName.delegate = self;
//    [_inputName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [row1View addSubview:_inputName];
    [_inputName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(row1View.mas_right).with.offset(-RESIZE_UI(20));
        make.height.mas_equalTo(row1View.mas_height);
        make.centerY.equalTo(row1View.mas_centerY);
    }];
    
    //第一行补充
    UIView *row1PriView = [[UIView alloc]init];
    row1PriView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:row1PriView];
    [row1PriView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row1View.mas_bottom).with.offset(RESIZE_UI(1));
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(60));
    }];
    
    UILabel *label1Pri = [[UILabel alloc]init];
    label1Pri.text = @"联系电话";
    label1Pri.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label1Pri.textColor = RGBA(102, 102, 102, 1.0);
    [row1PriView addSubview:label1Pri];
    [label1Pri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row1PriView);
        make.left.equalTo(row1PriView.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _inputPhone = [[UITextField alloc]init];
    _inputPhone.placeholder = @"请输入联系电话";
    _inputPhone.keyboardType = UIKeyboardTypeNumberPad;
    _inputPhone.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputPhone.textAlignment = NSTextAlignmentRight;
    _inputPhone.delegate = self;
    //    [_inputName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [row1PriView addSubview:_inputPhone];
    [_inputPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(row1PriView.mas_right).with.offset(-RESIZE_UI(20));
        make.height.mas_equalTo(row1PriView.mas_height);
        make.centerY.equalTo(row1PriView.mas_centerY);
    }];
    
    //第二行
    UIView *row2View = [[UIView alloc]init];
    row2View.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:row2View];
    [row2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row1PriView.mas_bottom).with.offset(RESIZE_UI(1));
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(60));
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"身份证号码";
    label2.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label2.textColor = RGBA(102, 102, 102, 1.0);
    [row2View addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row2View);
        make.left.equalTo(row2View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _inputIdCard = [[UITextField alloc]init];
    _inputIdCard.placeholder = @"请输入身份证号码";
    _inputIdCard.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputIdCard.textAlignment = NSTextAlignmentRight;
    _inputIdCard.delegate = self;
//    [_inputIdCard addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [row2View addSubview:_inputIdCard];
    [_inputIdCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row2View);
        make.right.equalTo(row2View.mas_right).with.offset(-RESIZE_UI(20));
        make.height.mas_equalTo(row2View.mas_height);
    }];
    
    //第二行补充
    UIView *row2PriView = [[UIView alloc]init];
    row2PriView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:row2PriView];
    [row2PriView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row2View.mas_bottom).with.offset(RESIZE_UI(1));
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(60));
    }];
    
    UILabel *label2Pri = [[UILabel alloc]init];
    label2Pri.text = @"原银行卡发卡行";
    label2Pri.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label2Pri.textColor = RGBA(102, 102, 102, 1.0);
    [row2PriView addSubview:label2Pri];
    [label2Pri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row2PriView);
        make.left.equalTo(row2PriView.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _inputBank = [[UITextField alloc]init];
    _inputBank.placeholder = @"请选择发卡行";
    _inputBank.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputBank.textAlignment = NSTextAlignmentRight;
    _inputBank.delegate = self;
    //    [_inputIdCard addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [row2PriView addSubview:_inputBank];
    [_inputBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row2PriView);
        make.right.equalTo(row2PriView.mas_right).with.offset(-RESIZE_UI(20));
        make.height.mas_equalTo(row2PriView.mas_height);
    }];
    
    UIButton *selectBankButton = [[UIButton alloc]init];
    [selectBankButton setBackgroundColor:[UIColor clearColor]];
    [selectBankButton addTarget:self action:@selector(selectBankNameMethod) forControlEvents:UIControlEventTouchUpInside];
    [row2PriView addSubview:selectBankButton];
    [selectBankButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(row2PriView);
    }];
    
    //第三行
    UIView *row3View = [[UIView alloc]init];
    row3View.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:row3View];
    [row3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row2PriView.mas_bottom).with.offset(RESIZE_UI(1));
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(60));
    }];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"原银行卡卡号";
    label3.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label3.textColor = RGBA(102, 102, 102, 1.0);
    [row3View addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row3View);
        make.left.equalTo(row3View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _inputBankCard = [[UITextField alloc]init];
    _inputBankCard.placeholder = @"请输入银行卡卡号";
    _inputBankCard.keyboardType = UIKeyboardTypeDecimalPad;
    _inputBankCard.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputBankCard.textAlignment = NSTextAlignmentRight;
    _inputBankCard.delegate = self;
//    [_inputBankCard addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [row3View addSubview:_inputBankCard];
    [_inputBankCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row3View);
        make.right.equalTo(row3View.mas_right).with.offset(-RESIZE_UI(20));
        make.height.mas_equalTo(row3View.mas_height);
    }];
    
    //第四行
    UIView *row4View = [[UIView alloc]init];
    row4View.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:row4View];
    [row4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row3View.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(180));
    }];
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.text = @"手持身份证正反面照";
    label4.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label4.textColor = RGBA(102, 102, 102, 1.0);
    [row4View addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row4View.mas_top).with.offset(RESIZE_UI(20));
        make.left.equalTo(row4View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _unselectTipId = [[UILabel alloc]init];
    _unselectTipId.text = @"请上传身份证正反面照";
    _unselectTipId.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _unselectTipId.textColor = [UIColor redColor];
    _unselectTipId.hidden = YES;
    [row4View addSubview:_unselectTipId];
    [_unselectTipId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label4.mas_centerY);
        make.right.equalTo(row4View.mas_right).with.offset(-RESIZE_UI(20));
    }];
    
    UILabel *tip4Label = [[UILabel alloc]init];
    tip4Label.text = @"(请保持照片信息清晰,勿进行修图软件处理)";
    tip4Label.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
    tip4Label.textColor = RGBA(153, 153, 153, 1.0);
    [row4View addSubview:tip4Label];
    [tip4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label4.mas_bottom).with.offset(RESIZE_UI(15));
        make.left.equalTo(row4View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _idCardButton1 = [[UIButton alloc]init];
    _idCardButton1.tag = 1;
    [_idCardButton1 setBackgroundImage:[UIImage imageNamed:@"addpic"] forState:UIControlStateNormal];
    [_idCardButton1 addTarget:self action:@selector(selectHeadImageMethod:) forControlEvents:UIControlEventTouchUpInside];
    [row4View addSubview:_idCardButton1];
    [_idCardButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip4Label.mas_bottom).with.offset(RESIZE_UI(5));
        make.left.equalTo(row4View.mas_left).with.offset(RESIZE_UI(20));
        make.width.height.mas_offset(RESIZE_UI(72));
    }];
    
    _idCardButton2 = [[UIButton alloc]init];
    _idCardButton2.tag = 2;
    [_idCardButton2 setBackgroundImage:[UIImage imageNamed:@"addpic"] forState:UIControlStateNormal];
    [_idCardButton2 addTarget:self action:@selector(selectHeadImageMethod:) forControlEvents:UIControlEventTouchUpInside];
    [row4View addSubview:_idCardButton2];
    [_idCardButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip4Label.mas_bottom).with.offset(RESIZE_UI(5));
        make.left.equalTo(_idCardButton1.mas_right).with.offset(RESIZE_UI(20));
        make.width.height.mas_offset(RESIZE_UI(72));
    }];
    
    //第五行
    UIView *row5View = [[UIView alloc]init];
    row5View.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:row5View];
    [row5View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row4View.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(180));
    }];
    
    UILabel *label5 = [[UILabel alloc]init];
    label5.text = @"手持新的银行卡正反面照";
    label5.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label5.textColor = RGBA(102, 102, 102, 1.0);
    [row5View addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row5View.mas_top).with.offset(RESIZE_UI(20));
        make.left.equalTo(row5View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _unselectTipBnak = [[UILabel alloc]init];
    _unselectTipBnak.text = @"请上传银行卡正反面照";
    _unselectTipBnak.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _unselectTipBnak.textColor = [UIColor redColor];
    _unselectTipBnak.hidden = YES;
    [row5View addSubview:_unselectTipBnak];
    [_unselectTipBnak mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label5.mas_centerY);
        make.right.equalTo(row5View.mas_right).with.offset(-RESIZE_UI(20));
    }];
    
    UILabel *tip5Label = [[UILabel alloc]init];
    tip5Label.text = @"(请保持照片信息清晰,勿进行修图软件处理)";
    tip5Label.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
    tip5Label.textColor = RGBA(153, 153, 153, 1.0);
    [row5View addSubview:tip5Label];
    [tip5Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label5.mas_bottom).with.offset(RESIZE_UI(15));
        make.left.equalTo(row5View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _bankCardButton1 = [[UIButton alloc]init];
    _bankCardButton1.tag = 3;
    [_bankCardButton1 setBackgroundImage:[UIImage imageNamed:@"addpic"] forState:UIControlStateNormal];
    [_bankCardButton1 addTarget:self action:@selector(selectHeadImageMethod:) forControlEvents:UIControlEventTouchUpInside];
    [row5View addSubview:_bankCardButton1];
    [_bankCardButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip5Label.mas_bottom).with.offset(RESIZE_UI(5));
        make.left.equalTo(row5View.mas_left).with.offset(RESIZE_UI(20));
        make.width.height.mas_offset(RESIZE_UI(72));
    }];
    
    _bankCardButton2 = [[UIButton alloc]init];
    _bankCardButton2.tag = 4;
    [_bankCardButton2 setBackgroundImage:[UIImage imageNamed:@"addpic"] forState:UIControlStateNormal];
    [_bankCardButton2 addTarget:self action:@selector(selectHeadImageMethod:) forControlEvents:UIControlEventTouchUpInside];
    [row5View addSubview:_bankCardButton2];
    [_bankCardButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip5Label.mas_bottom).with.offset(RESIZE_UI(5));
        make.left.equalTo(_bankCardButton1.mas_right).with.offset(RESIZE_UI(20));
        make.width.height.mas_offset(RESIZE_UI(72));
    }];
    
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(row5View.mas_bottom);
    }];
    
}

#pragma mark - 选择银行
- (void)selectBankNameMethod {
    
    [_inputName resignFirstResponder];
    [_inputPhone resignFirstResponder];
    [_inputIdCard resignFirstResponder];
    [_inputBankCard resignFirstResponder];
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    _bankArray = [[NSMutableArray alloc]init];
    NSMutableArray *stringArray = [[NSMutableArray alloc]init];
    [manager postDataWithUrlActionStr:@"Bank/index" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSMutableArray *array = obj[@"data"];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic = array[i];
                BankModel *bankModel = [BankModel mj_objectWithKeyValues:dic];
                NSString *bankString = [NSString stringWithFormat:@"%@-%@",bankModel.code,bankModel.name];
                [stringArray addObject:bankString];
                [_bankArray addObject:bankModel];
            }
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setBankViewWithItem:(NSArray *)stringArray title:@"银行名称"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr)
            {
                NSArray *bankArray = [selectedStr componentsSeparatedByString:@"-"];
                _bank_codeStr = [bankArray firstObject];
                _inputBank.textColor = [UIColor blackColor];
                _inputBank.text = [bankArray lastObject];
            };
            
            [SVProgressHUD dismiss];
        } else {
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            [SVProgressHUD dismiss];
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
    }];

}

#pragma mark - 选择图片
- (IBAction)selectHeadImageMethod:(UIButton *)sender {
    
    [_inputName resignFirstResponder];
    [_inputBankCard resignFirstResponder];
    [_inputIdCard resignFirstResponder];
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
    
    //相册参数配置
    ZLPhotoConfiguration *configuration = [ZLPhotoConfiguration defaultPhotoConfiguration];
    configuration.maxSelectCount = 1;
    ac.configuration = configuration;
    
    //如调用的方法无sender参数，则该参数必传
    ac.sender = self;
    
    //选择回调
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        
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
                if (_select2) {
                    _unselectTipId.hidden = YES;
                }
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
                if (_select1) {
                    _unselectTipId.hidden = YES;
                }
            }
                break;
            case 3:
            {
                [_bankCardButton1 setBackgroundImage:images[0] forState:UIControlStateNormal];
                _select3 = images[0];
                _bankCardDeleteButton1 = [[UIButton alloc]init];
                _bankCardDeleteButton1.tag = 3;
                [_bankCardDeleteButton1 setImage:[UIImage imageNamed:@"icon_del"] forState:UIControlStateNormal];
                [_bankCardDeleteButton1 addTarget:self action:@selector(deleteSelectImage:) forControlEvents:UIControlEventTouchUpInside];
                [_bankCardButton1 addSubview:_bankCardDeleteButton1];
                [_bankCardDeleteButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(_bankCardButton1);
                }];
                if (_select4) {
                    _unselectTipBnak.hidden = YES;
                }
            }
                break;
            case 4:
            {
                [_bankCardButton2 setBackgroundImage:images[0] forState:UIControlStateNormal];
                _select4 = images[0];
                _bankCardDeleteButton2 = [[UIButton alloc]init];
                _bankCardDeleteButton2.tag = 4;
                [_bankCardDeleteButton2 setImage:[UIImage imageNamed:@"icon_del"] forState:UIControlStateNormal];
                [_bankCardDeleteButton2 addTarget:self action:@selector(deleteSelectImage:) forControlEvents:UIControlEventTouchUpInside];
                [_bankCardButton2 addSubview:_bankCardDeleteButton2];
                [_bankCardDeleteButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(_bankCardButton2);
                }];
                if (_select3) {
                    _unselectTipBnak.hidden = YES;
                }
            }
                break;
                
            default:
                break;
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
            _unselectTipId.hidden = NO;
        }
            break;
        case 2:
        {
            [_idCardDeleteButton2 removeFromSuperview];
            _idCardDeleteButton2 = nil;
            [_idCardButton2 setBackgroundImage:[UIImage imageNamed:@"addpic"] forState:UIControlStateNormal];
            _select2 = nil;
            _unselectTipId.hidden = NO;
        }
            break;
        case 3:
        {
            [_bankCardDeleteButton1 removeFromSuperview];
            _bankCardDeleteButton1 = nil;
            [_bankCardButton1 setBackgroundImage:[UIImage imageNamed:@"addpic"] forState:UIControlStateNormal];
            _select3 = nil;
            _unselectTipBnak.hidden = NO;
        }
            break;
        case 4:
        {
            [_bankCardDeleteButton2 removeFromSuperview];
            _bankCardDeleteButton2 = nil;
            [_bankCardButton2 setBackgroundImage:[UIImage imageNamed:@"addpic"] forState:UIControlStateNormal];
            _select4 = nil;
            _unselectTipBnak.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 所有恢复正常
- (void)allRecoverNormal {
    _inputName.textColor = defaultInputColor;
    _inputName.text = _inputName.text;
    _inputPhone.textColor = defaultInputColor;
    _inputPhone.text = _inputPhone.text;
    _inputIdCard.textColor = defaultInputColor;
    _inputIdCard.text = _inputIdCard.text;
    _inputBank.textColor = defaultInputColor;
    _inputBank.text = _inputBank.text;
    _inputBankCard.textColor = defaultInputColor;
    _inputBankCard.text = _inputBankCard.text;
    _unselectTipId.hidden = YES;
    _unselectTipBnak.hidden = YES;
}

#pragma mark - 点击提交按钮
- (void)confirmSubmit {
    
    [self allRecoverNormal];
    if ([_inputName.text isEqualToString:@""]) {
        [self changgePlaceholderMethod:_inputName];
        _inputName.textColor = [UIColor redColor];
        [[SingletonManager sharedManager] showHUDView:self.view title:@"请输入用户姓名" content:@"" time:1.0 andCodes:^{
            
        }];
        return;
    }
    
    if ([_inputPhone.text isEqualToString:@""]) {
        [self changgePlaceholderMethod:_inputPhone];
        _inputPhone.textColor = [UIColor redColor];
        [[SingletonManager sharedManager] showHUDView:self.view title:@"请输入联系电话" content:@"" time:1.0 andCodes:^{
            
        }];
        return;
    }
    
    if ([_inputIdCard.text isEqualToString:@""]) {
        [self changgePlaceholderMethod:_inputIdCard];
        _inputIdCard.textColor = [UIColor redColor];
        [[SingletonManager sharedManager] showHUDView:self.view title:@"请输入身份证号码" content:@"" time:1.0 andCodes:^{
            
        }];
        return;
    }
    
    if ([_inputBank.text isEqualToString:@""]) {
        [self changgePlaceholderMethod:_inputBank];
        _inputBank.textColor = [UIColor redColor];
        [[SingletonManager sharedManager] showHUDView:self.view title:@"请选择发卡行" content:@"" time:1.0 andCodes:^{
            
        }];
        return;
    }
    
    if ([_inputBankCard.text isEqualToString:@""]) {
        [self changgePlaceholderMethod:_inputBankCard];
        _inputBankCard.textColor = [UIColor redColor];
        [[SingletonManager sharedManager] showHUDView:self.view title:@"请输入银行卡卡号" content:@"" time:1.0 andCodes:^{
            
        }];
        return;
    }
    if (!_select1||!_select2) {
        _unselectTipId.hidden = NO;
        [[SingletonManager sharedManager] showHUDView:self.view title:@"请上传身份证正反面照" content:@"" time:1.0 andCodes:^{
            
        }];
        return;
    }
    if (!_select3||!_select4) {
        _unselectTipBnak.hidden = NO;
        [[SingletonManager sharedManager] showHUDView:self.view title:@"请上传银行卡正反面照" content:@"" time:1.0 andCodes:^{
            
        }];
        return;
    }
    
    ConfirmReleaseCardView *confirmReleaseCardView = [[ConfirmReleaseCardView alloc]init];
    confirmReleaseCardView.confirmRelease = ^(){
        [self netStepButtonMethod];
    };
    [self.window addSubview:confirmReleaseCardView];
    [confirmReleaseCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.window);
    }];
}

#pragma mark - 提交申请
- (void)netStepButtonMethod {
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NetManager *manager = [[NetManager alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"member_id"] = [SingletonManager sharedManager].uid;
    dict[@"name"] = _inputName.text;
    dict[@"cert_no"] = _inputIdCard.text;
    dict[@"card_no"] = _inputBankCard.text;
    dict[@"mobile"] = _inputPhone.text;
    dict[@"bank_name"] = _inputBank.text;
    
    NSArray *paramArray = @[@"cert_front[]",@"cert_front[]",@"cert_bg[]",@"cert_bg[]"];
    NSArray *imageArray = @[_select1,_select2,_select3,_select4];
    
    [SVProgressHUD showWithStatus:@"上传中"];
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",  nil];//设置相应内容类型
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [httpManager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    NSString *dateNew = [manager getCurrentTimestamp];
    NSDictionary *paramDic = @{@"timestamp":dateNew, @"action":@"Bank/unbind_apply", @"data":dict};//参数序列
    NSString *base64Str = [manager paramCodeStr:paramDic];
    //@"file":@"ss"
    [httpManager POST:WMJRAPI parameters:@{@"msg":base64Str} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < paramArray.count; i++)
        {
            NSData *imageData = UIImageJPEGRepresentation(imageArray[i], 1.0);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@ - %d.jpg", str,i];
            
            // 上传图片，以文件流的格式
            [formData appendPartWithFileData:imageData name:paramArray[i] fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        id obj = [manager paramUnCodeStr:responseStr];
        if (obj) {
            
            [SVProgressHUD dismiss];
//            [[SingletonManager sharedManager] showHUDView:self.view title:@"提交成功" content:@"" time:1.0 andCodes:^{
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }];
            [self successTipWindow];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *msgStr = @"上传失败";
        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
        alertConfig.defaultTextOK = @"确定";
        [SVProgressHUD dismiss];
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
        [alertView show];
    }];
    
}

- (void)successTipWindow {
    _blackView = [[UIView alloc]init];
    _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
    [self.window addSubview:_blackView];
    [_blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.window);
    }];

    _whiteView = [[UIView alloc]init];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.masksToBounds = YES;
    _whiteView.layer.cornerRadius = RESIZE_UI(10);
    [_blackView addSubview:_whiteView];
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_blackView.mas_centerX);
        make.centerY.equalTo(_blackView.mas_centerY);
        make.height.mas_offset(RESIZE_UI(160));
        make.width.mas_offset(RESIZE_UI(258));
    }];

    _rightImage = [[UIImageView alloc]init];
    _rightImage.image = [UIImage imageNamed:@"icon_done"];
    [_whiteView addSubview:_rightImage];
    [_rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_whiteView.mas_top).with.offset(RESIZE_UI(30));
        make.centerX.equalTo(_whiteView.mas_centerX);
        make.height.width.mas_offset(RESIZE_UI(60));
    }];

    _tipLabel = [[UILabel alloc]init];
    _tipLabel.text = @"申请已提交，请耐心等候";
    _tipLabel.textColor = RGBA(102, 102, 102, 1.0);
    _tipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    [_whiteView addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightImage.mas_bottom).with.offset(RESIZE_UI(18));
        make.centerX.equalTo(_whiteView.mas_centerX);
    }];

    //    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBlackView)];
    //    [_blackView addGestureRecognizer:_tap];
    [self performSelector:@selector(closeBlackView) withObject:nil afterDelay:1.0];
    
//    ReleaseSuccessCardView *releaseSuccessCardView = [[ReleaseSuccessCardView alloc]init];
//    @weakify(self)
//    releaseSuccessCardView.releaseSuccess = ^(){
//        @strongify(self)
////        [self.navigationController popViewControllerAnimated:YES];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    };
    
}

- (void)closeBlackView {
    [_blackView removeFromSuperview];
    _blackView = nil;
    //    _tap = nil;
    //    [_blackView removeGestureRecognizer:_tap];
    [_whiteView removeFromSuperview];
    _whiteView = nil;
    [_rightImage removeFromSuperview];
    _rightImage = nil;
    [_tipLabel removeFromSuperview];
    _tipLabel = nil;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - 监听textfield
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self recoverPlaceholderMethod:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:_inputName]) {
        textField.placeholder = @"请输入用户姓名";
    }
    if ([textField isEqual:_inputIdCard]) {
        textField.placeholder = @"请输入身份证号码";
    }
    if ([textField isEqual:_inputBankCard]) {
        textField.placeholder = @"请输入银行卡卡号";
    }
}

//-(void)textFieldDidChange :(UITextField *)theTextField {
//
//}

#pragma mark - 修改placeholder字体
- (void)changgePlaceholderMethod:(UITextField *)textField {
    [textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    //    [textField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
}

#pragma mark - 恢复placeholder字体
- (void)recoverPlaceholderMethod:(UITextField *)textField {
    textField.placeholder = @"";
    [textField setValue:RGBA(207, 207, 207, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    textField.textColor = RGBA(60, 60, 60, 1.0);
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
