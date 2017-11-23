//
//  ImmediatelyMoneyOrderViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/11/17.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "ImmediatelyMoneyOrderViewController.h"
#import "DateSelectView.h"
#import "LoansContentFillViewController.h"
#import "ZLPhotoActionSheet.h"
#import "ZLPhotoConfiguration.h"

@interface ImmediatelyMoneyOrderViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,DateSelectViewDelegate,UITextViewDelegate>

@property (nonatomic, strong)UIButton *nextStepButton;
@property (nonatomic, strong)UIButton *shangpiaoButton;
@property (nonatomic, strong)UIButton *yinpiaoButton;
@property (nonatomic, assign)NSInteger typeTag;//选择银票按钮为1  选择商票按钮为2  没选为0
@property (nonatomic, strong)UITextField *inputPiaojuMoney;
@property (nonatomic, strong)UILabel *piaojuUnitLabel;//配合inputPiaojuMoney
@property (nonatomic, strong)UITextField *inputRate;
@property (nonatomic, strong)UILabel *rateUnitLabel;//配合inputRate
@property (nonatomic, strong)UILabel *dateLabel;
@property (nonatomic, strong)UITextView *inputChengdui;
@property (nonatomic, assign)NSInteger selectTag;
@property (nonatomic, strong)DateSelectView *dateSelectView;

@property (nonatomic, strong)UIView *row3View;
@property (nonatomic, strong)UIView *row6View;
@property (nonatomic, strong)UILabel *tip6Label;
@property (nonatomic, strong)UIView *row7View;
@property (nonatomic, strong)UILabel *tip7Label;

@property (nonatomic, assign)CGFloat buttonwidth;
@property (nonatomic, strong)NSMutableArray *buttonArray1;//第一组Button
@property (nonatomic, strong)NSMutableArray *imageArray1;//第一组图片
@property (nonatomic, strong)NSMutableArray *deleteArray1;//第一组删除按钮
@property (nonatomic, strong)NSMutableArray *buttonArray2;//第二组Button
@property (nonatomic, strong)NSMutableArray *imageArray2;//第二组图片
@property (nonatomic, strong)NSMutableArray *deleteArray2;//第二组删除按钮

@property (nonatomic, strong)NSDate *selectDate;

@end

@implementation ImmediatelyMoneyOrderViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"立即申请";
    self.view.backgroundColor = RGBA(240, 241, 243, 1.0);
    _typeTag = 0;
    _buttonArray1 = [[NSMutableArray alloc]init];
    _imageArray1 = [[NSMutableArray alloc]init];
    _buttonArray2 = [[NSMutableArray alloc]init];
    _imageArray2 = [[NSMutableArray alloc]init];
    _buttonwidth = (SCREEN_WIDTH-RESIZE_UI(100))/4;
    [self setUpLayout];
}

#pragma mark - 界面布局
- (void)setUpLayout {
    
    _nextStepButton = [[UIButton alloc]init];
    [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextStepButton setBackgroundColor:RGBA(255, 88, 26, 1.0)];
    [_nextStepButton addTarget:self action:@selector(netStepButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextStepButton];
    [_nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(49));
    }];
    
    UIScrollView *mainScrollView = [[UIScrollView alloc]init];
    mainScrollView.backgroundColor = RGBA(240, 241, 243, 1.0);
    [self.view addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(_nextStepButton.mas_top);
    }];
    
    UIView *mainView = [[UIView alloc]init];
    mainView.backgroundColor = RGBA(240, 241, 243, 1.0);
    [mainScrollView addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    //第一行
    UIView *row1View = [[UIView alloc]init];
    row1View.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:row1View];
    [row1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView.mas_top);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(60));
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"票据类型";
    label1.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label1.textColor = RGBA(102, 102, 102, 1.0);
    [row1View addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row1View);
        make.left.equalTo(row1View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _shangpiaoButton = [[UIButton alloc]init];
    [_shangpiaoButton setTitle:@"商票" forState:UIControlStateNormal];
    _shangpiaoButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [_shangpiaoButton setTitleColor:RGBA(0, 104, 178, 1.0) forState:UIControlStateNormal];
    [_shangpiaoButton.layer setMasksToBounds:YES];
    _shangpiaoButton.layer.cornerRadius = 5.0f;
    _shangpiaoButton.layer.borderWidth = 1.0f;
    _shangpiaoButton.layer.borderColor = RGBA(0, 104, 178, 1.0).CGColor;
    [_shangpiaoButton addTarget:self action:@selector(selectShangPiaoMethod) forControlEvents:UIControlEventTouchUpInside];
    [row1View addSubview:_shangpiaoButton];
    [_shangpiaoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row1View);
        make.right.equalTo(row1View.mas_right).with.offset(-RESIZE_UI(20));
        make.width.mas_offset(RESIZE_UI(65));
        make.height.mas_offset(RESIZE_UI(35));
    }];
    
    _yinpiaoButton = [[UIButton alloc]init];
    [_yinpiaoButton setTitle:@"银票" forState:UIControlStateNormal];
    _yinpiaoButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [_yinpiaoButton setTitleColor:RGBA(0, 104, 178, 1.0) forState:UIControlStateNormal];
    [_yinpiaoButton.layer setMasksToBounds:YES];
    _yinpiaoButton.layer.cornerRadius = 5.0f;
    _yinpiaoButton.layer.borderWidth = 1.0f;
    _yinpiaoButton.layer.borderColor = RGBA(0, 104, 178, 1.0).CGColor;
    [_yinpiaoButton addTarget:self action:@selector(selectYinPiaoMethod) forControlEvents:UIControlEventTouchUpInside];
    [row1View addSubview:_yinpiaoButton];
    [_yinpiaoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row1View);
        make.right.equalTo(_shangpiaoButton.mas_left).with.offset(-RESIZE_UI(20));
        make.width.mas_offset(RESIZE_UI(65));
        make.height.mas_offset(RESIZE_UI(35));
    }];
    
    //第二行
    UIView *row2View = [[UIView alloc]init];
    row2View.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:row2View];
    [row2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row1View.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(60));
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"票面金额";
    label2.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label2.textColor = RGBA(102, 102, 102, 1.0);
    [row2View addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row2View);
        make.left.equalTo(row2View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _piaojuUnitLabel = [[UILabel alloc]init];
    _piaojuUnitLabel.text = @"";//@" 元"
    _piaojuUnitLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [row2View addSubview:_piaojuUnitLabel];
    [_piaojuUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row2View);
        make.right.equalTo(row2View.mas_right).with.offset(-RESIZE_UI(20));
    }];
    
    _inputPiaojuMoney = [[UITextField alloc]init];
    _inputPiaojuMoney.placeholder = @"请输入票面面额(元)";
    _inputPiaojuMoney.keyboardType = UIKeyboardTypeDecimalPad;
    _inputPiaojuMoney.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputPiaojuMoney.textAlignment = NSTextAlignmentRight;
    _inputPiaojuMoney.tag = 1;
    [_inputPiaojuMoney addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [row2View addSubview:_inputPiaojuMoney];
    [_inputPiaojuMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row2View);
        make.right.equalTo(_piaojuUnitLabel.mas_left);
    }];
    
    //第三行
    _row3View = [[UIView alloc]init];
    _row3View.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:_row3View];
    [_row3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row2View.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(60));
    }];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"期望利率";
    label3.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label3.textColor = RGBA(102, 102, 102, 1.0);
    [_row3View addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_row3View);
        make.left.equalTo(_row3View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _rateUnitLabel = [[UILabel alloc]init];
    _rateUnitLabel.text = @"";//@" %"
    _rateUnitLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [_row3View addSubview:_rateUnitLabel];
    [_rateUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_row3View);
        make.right.equalTo(_row3View.mas_right).with.offset(-RESIZE_UI(20));
    }];
    
    _inputRate = [[UITextField alloc]init];
    _inputRate.placeholder = @"请输入期望利率(%)";
    _inputRate.keyboardType = UIKeyboardTypeDecimalPad;
    _inputRate.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputRate.textAlignment = NSTextAlignmentRight;
    _inputRate.tag = 2;
    [_inputRate addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_row3View addSubview:_inputRate];
    [_inputRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_row3View);
        make.right.equalTo(_rateUnitLabel.mas_left);
    }];
    
    //第四行
    UIView *row4View = [[UIView alloc]init];
    row4View.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:row4View];
    [row4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_row3View.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(60));
    }];
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.text = @"票据到期日";
    label4.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label4.textColor = RGBA(102, 102, 102, 1.0);
    [row4View addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row4View);
        make.left.equalTo(row4View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    UIImageView *jiantouImageView = [[UIImageView alloc]init];
    jiantouImageView.image = [UIImage imageNamed:@"icon_arrow"];
    [row4View addSubview:jiantouImageView];
    [jiantouImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row4View);
        make.right.equalTo(row4View.mas_right).with.offset(-RESIZE_UI(20));
        make.width.height.mas_offset(RESIZE_UI(16));
    }];
    
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.text = @"";
    [row4View addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row4View);
        make.right.equalTo(jiantouImageView.mas_left).with.offset(-RESIZE_UI(5));
    }];
    
    UIButton *watchDatePiaojuButton = [[UIButton alloc]init];
    [watchDatePiaojuButton setBackgroundColor:[UIColor clearColor]];
    [watchDatePiaojuButton addTarget:self action:@selector(watchDateMethod) forControlEvents:UIControlEventTouchUpInside];
    [row4View addSubview:watchDatePiaojuButton];
    [watchDatePiaojuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(row4View);
    }];
    
    //第五行
    UIView *row5View = [[UIView alloc]init];
    row5View.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:row5View];
    [row5View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row4View.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(80));
    }];
    
    UILabel *label5 = [[UILabel alloc]init];
    label5.text = @"承兑银行/承兑人";
    label5.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label5.textColor = RGBA(102, 102, 102, 1.0);
    [row5View addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row5View.mas_top).with.offset(RESIZE_UI(20));
        make.left.equalTo(row5View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _inputChengdui = [[UITextView alloc]init];
    _inputChengdui.text = @"请输入承兑对象";
    _inputChengdui.textColor = RGBA(199, 199, 204, 1.0);
    _inputChengdui.delegate = self;
    _inputChengdui.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputChengdui.textAlignment = NSTextAlignmentRight;
    [row5View addSubview:_inputChengdui];
    [_inputChengdui mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row5View.mas_top).with.offset(RESIZE_UI(12));
        make.right.equalTo(row5View.mas_right).with.offset(-RESIZE_UI(20));
        make.width.mas_offset(RESIZE_UI(176));
        make.height.mas_offset(RESIZE_UI(42));
    }];
    
    //第六行
    _row6View = [[UIView alloc]init];
    _row6View.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:_row6View];
    [_row6View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row5View.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(180));
    }];
    
    UILabel *label6 = [[UILabel alloc]init];
    label6.text = @"票面图片";
    label6.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label6.textColor = RGBA(102, 102, 102, 1.0);
    [_row6View addSubview:label6];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_row6View.mas_top).with.offset(RESIZE_UI(20));
        make.left.equalTo(_row6View.mas_left).with.offset(RESIZE_UI(20));
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
    
    for (int i=0; i<4; i++) {
        UIButton *button1 = [[UIButton alloc]init];
        button1.tag = 1;
        if (i == 0) {
            button1.hidden = NO;
        } else {
            button1.hidden = YES;
        }
        [button1 setBackgroundImage:[UIImage imageNamed:@"addpic"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(selectHeadImageMethod:) forControlEvents:UIControlEventTouchUpInside];
        [_row6View addSubview:button1];
        [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tip6Label.mas_bottom).with.offset(RESIZE_UI(5));
            make.left.equalTo(_row6View.mas_left).with.offset(RESIZE_UI(20)+RESIZE_UI(20+_buttonwidth)*i);
            make.width.height.mas_offset(_buttonwidth);
        }];
        [_buttonArray1 addObject:button1];
    }
    
    //第七行
    _row7View = [[UIView alloc]init];
    _row7View.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:_row7View];
    [_row7View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_row6View.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(180));
    }];
    
    UILabel *label7 = [[UILabel alloc]init];
    label7.text = @"背书图片";
    label7.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label7.textColor = RGBA(102, 102, 102, 1.0);
    [_row7View addSubview:label7];
    [label7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_row7View.mas_top).with.offset(RESIZE_UI(20));
        make.left.equalTo(_row7View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _tip7Label = [[UILabel alloc]init];
    _tip7Label.text = @"(请保持照片信息清晰,勿进行修图软件处理)";
    _tip7Label.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
    _tip7Label.textColor = RGBA(153, 153, 153, 1.0);
    [_row7View addSubview:_tip7Label];
    [_tip7Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label7.mas_bottom).with.offset(RESIZE_UI(30));
        make.left.equalTo(_row7View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    for (int i=0; i<4; i++) {
        UIButton *button2 = [[UIButton alloc]init];
        button2.tag = 2;
        if (i == 0) {
            button2.hidden = NO;
        } else {
            button2.hidden = YES;
        }
        [button2 setBackgroundImage:[UIImage imageNamed:@"addpic"] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(selectHeadImageMethod:) forControlEvents:UIControlEventTouchUpInside];
        [_row7View addSubview:button2];
        [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tip7Label.mas_bottom).with.offset(RESIZE_UI(5));
            make.left.equalTo(_row7View.mas_left).with.offset(RESIZE_UI(20)+RESIZE_UI(20+_buttonwidth)*i);
            make.width.height.mas_offset(_buttonwidth);
        }];
        [_buttonArray2 addObject:button2];
    }
    
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_row7View.mas_bottom);
    }];
    
}

#pragma mark - 监听textfield
-(void)textFieldDidChange :(UITextField *)theTextField {
    
    if ([theTextField.text isEqualToString:@""]) {
        switch (theTextField.tag) {
            case 1:
                _piaojuUnitLabel.text = @"";
                break;
            case 2:
                _rateUnitLabel.text = @"";
                break;
                
            default:
                break;
        }
    } else {
        switch (theTextField.tag) {
            case 1:
                _piaojuUnitLabel.text = @" 元";
                break;
            case 2:
                _rateUnitLabel.text = @" %";
                break;
                
            default:
                break;
        }
    }
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"请输入承兑对象"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"请输入承兑对象";
        textView.textColor = RGBA(199, 199, 204, 1.0);
    }
    if (![textView.text isEqualToString:@"请输入承兑对象"]) {
        textView.textColor = RGBA(60, 60, 60, 1.0);
    } else {
        textView.textColor = RGBA(199, 199, 204, 1.0);
    }
    if (textView.text.length>11) {
        textView.textAlignment = NSTextAlignmentLeft;
    } else {
        textView.textAlignment = NSTextAlignmentRight;
    }
}

#pragma mark - 选择商票
- (void)selectShangPiaoMethod {
    _typeTag = 1;
    [_shangpiaoButton setBackgroundColor:RGBA(0, 104, 178, 1.0)];
    [_shangpiaoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_yinpiaoButton setBackgroundColor:[UIColor whiteColor]];
    [_yinpiaoButton setTitleColor:RGBA(0, 104, 178, 1.0) forState:UIControlStateNormal];
}

#pragma mark - 选择银票
- (void)selectYinPiaoMethod {
    _typeTag = 2;
    [_yinpiaoButton setBackgroundColor:RGBA(0, 104, 178, 1.0)];
    [_yinpiaoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_shangpiaoButton setBackgroundColor:[UIColor whiteColor]];
    [_shangpiaoButton setTitleColor:RGBA(0, 104, 178, 1.0) forState:UIControlStateNormal];
}

#pragma mark - 查看日期选择器
- (void)watchDateMethod {
    
    [_inputRate resignFirstResponder];
    [_inputPiaojuMoney resignFirstResponder];
    [_inputChengdui resignFirstResponder];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    _dateSelectView = [[DateSelectView alloc]init];
    _dateSelectView.delegate = self;
    [window addSubview:_dateSelectView];
    [_dateSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
}

#pragma mark - DateSelectViewDelegate
- (void)cancelDatePickerView {
    [_dateSelectView removeFromSuperview];
    _dateSelectView = nil;
}

- (void)confirmDatePickerView:(NSString *)content andDate:(NSDate *)selectDate {
    [self cancelDatePickerView];
    _selectDate = selectDate;
    _dateLabel.text = content;
}

#pragma mark - 选择图片
- (IBAction)selectHeadImageMethod:(UIButton *)sender {

    switch (sender.tag) {
        case 1:
            _selectTag = 1;
            break;
        case 2:
            _selectTag = 2;
            break;
            
        default:
            break;
    }
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
    
    //相册参数配置
    ZLPhotoConfiguration *configuration = [ZLPhotoConfiguration defaultPhotoConfiguration];
    if (_selectTag == 1) {
        configuration.maxSelectCount = 4-_imageArray1.count;
    } else {
        configuration.maxSelectCount = 4-_imageArray2.count;
    }
    ac.configuration = configuration;
    
    //如调用的方法无sender参数，则该参数必传
    ac.sender = self;
    
    //选择回调
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        //your codes
        for (int i=0; i<images.count; i++) {
            UIImage *selectImage = images[i];
            if (_selectTag == 1) {
                [_imageArray1 addObject:selectImage];
            } else {
                [_imageArray2 addObject:selectImage];
            }
        }
        if (_selectTag == 1) {
            [self configDealWithButtonOne];
        } else {
            [self configDealWithButtonTwo];
        }
    }];
    
    //调用相册
    [ac showPreviewAnimated:YES];
    
}

#pragma mark - 整理第一组按钮的图片显示问题
- (void)configDealWithButtonOne {
    //初始化数组里的button
    for (int i=0; i<_buttonArray1.count; i++) {
        UIButton *button1 = _buttonArray1[i];
        [button1 setBackgroundImage:[UIImage imageNamed:@"addpic"] forState:UIControlStateNormal];
        if (i==0) {
            button1.hidden = NO;
        } else {
            button1.hidden = YES;
        }
    }
    for (int i=0; i<_deleteArray1.count; i++) {
        [_deleteArray1[i] removeFromSuperview];
    }
    _deleteArray1 = [[NSMutableArray alloc]init];
    for (int i=0; i<_imageArray1.count; i++) {
        UIImage *image1 = _imageArray1[i];
        UIButton *button1 = _buttonArray1[i];
        button1.hidden = NO;
        [button1 setBackgroundImage:image1 forState:UIControlStateNormal];
        UIButton *deleteButton = [[UIButton alloc]init];
        deleteButton.tag = i;
        [deleteButton setImage:[UIImage imageNamed:@"icon_del"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteImageOne:) forControlEvents:UIControlEventTouchUpInside];
        [_row6View addSubview:deleteButton];
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tip6Label.mas_bottom).with.offset(RESIZE_UI(5));
            make.left.equalTo(_row6View.mas_left).with.offset(RESIZE_UI(20)+RESIZE_UI(20+_buttonwidth)*i);
            make.width.height.mas_offset(_buttonwidth);
        }];
        [_deleteArray1 addObject:deleteButton];
        if (i+1<4) {
            UIButton *button11 = _buttonArray1[i+1];
            button11.hidden = NO;
        }
        
    }
}

#pragma mark - 第一组图片删除问题
- (void)deleteImageOne:(UIButton *)sender {
    NSInteger row = sender.tag;
    [_imageArray1 removeObjectAtIndex:row];
    //回调第一组按钮方法
    [self configDealWithButtonOne];
}

#pragma mark - 整理第二组的图片显示问题
- (void)configDealWithButtonTwo {
    //初始化数组里的button
    for (int i=0; i<_buttonArray2.count; i++) {
        UIButton *button2 = _buttonArray2[i];
        [button2 setBackgroundImage:[UIImage imageNamed:@"addpic"] forState:UIControlStateNormal];
        if (i==0) {
            button2.hidden = NO;
        } else {
            button2.hidden = YES;
        }
    }
    for (int i=0; i<_deleteArray2.count; i++) {
        [_deleteArray2[i] removeFromSuperview];
    }
    _deleteArray2 = [[NSMutableArray alloc]init];
    NSInteger row = _imageArray2.count;
    for (int i=0; i<_imageArray2.count; i++) {
        UIImage *image2 = _imageArray2[i];
        UIButton *button2 = _buttonArray2[i];
        button2.hidden = NO;
        [button2 setBackgroundImage:image2 forState:UIControlStateNormal];
        UIButton *deleteButton = [[UIButton alloc]init];
        deleteButton.tag = i;
        [deleteButton setImage:[UIImage imageNamed:@"icon_del"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteImageTwo:) forControlEvents:UIControlEventTouchUpInside];
        [_row7View addSubview:deleteButton];
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tip7Label.mas_bottom).with.offset(RESIZE_UI(5));
            make.left.equalTo(_row7View.mas_left).with.offset(RESIZE_UI(20)+RESIZE_UI(20+_buttonwidth)*i);
            make.width.height.mas_offset(_buttonwidth);
        }];
        [_deleteArray2 addObject:deleteButton];
        if (i+1<4) {
            UIButton *button22 = _buttonArray2[i+1];
            button22.hidden = NO;
        }
        
    }
}

#pragma mark - 第二组图片删除问题
- (void)deleteImageTwo:(UIButton *)sender {
    NSInteger row = sender.tag;
    [_imageArray2 removeObjectAtIndex:row];
    //回调第一组按钮方法
    [self configDealWithButtonTwo];
}
#pragma mark - 下一步按钮
- (void)netStepButtonMethod {
    if (_typeTag == 0) {
        [[SingletonManager sharedManager] showHUDView:self.view title:@"请选择票据类型" content:@"" time:1.0 andCodes:^{

        }];
    } else if ([_inputPiaojuMoney.text isEqualToString:@""]) {
        [[SingletonManager sharedManager] showHUDView:self.view title:@"请输入票面金额" content:@"" time:1.0 andCodes:^{

        }];
    } else if ([_inputRate.text isEqualToString:@""]) {
        [[SingletonManager sharedManager] showHUDView:self.view title:@"请输入期望利率" content:@"" time:1.0 andCodes:^{

        }];
    } else if ([_dateLabel.text isEqualToString:@""]) {
        [[SingletonManager sharedManager] showHUDView:self.view title:@"请选择票据到期日" content:@"" time:1.0 andCodes:^{

        }];
    } else if ([_inputChengdui.text isEqualToString:@""] || [_inputChengdui.text isEqualToString:@"请输入承兑对象"]) {
        [[SingletonManager sharedManager] showHUDView:self.view title:@"请输入承兑对象" content:@"" time:1.0 andCodes:^{

        }];
    } else if (_imageArray1.count == 0) {
        [[SingletonManager sharedManager] showHUDView:self.view title:@"请上传票面图片" content:@"" time:1.0 andCodes:^{

        }];
    } else if (_imageArray2.count == 0) {
        [[SingletonManager sharedManager] showHUDView:self.view title:@"请上传背书图片" content:@"" time:1.0 andCodes:^{

        }];
    } else {
        LoansContentFillViewController *loansFillVC = [[LoansContentFillViewController alloc]init];
        loansFillVC.identifier = self.identifier;
        loansFillVC.typeTag = _typeTag;
        loansFillVC.piaojuMoney = _inputPiaojuMoney.text;
        loansFillVC.respectRate = _inputRate.text;
        loansFillVC.piaojuDate = _dateLabel.text;
        loansFillVC.chengduiObject = _inputChengdui.text;
        loansFillVC.selectDate = _selectDate;
        loansFillVC.piaoMianImage = [_imageArray1 copy];
        loansFillVC.beishuImage = [_imageArray1 copy];
        [self.navigationController pushViewController:loansFillVC animated:YES];
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
