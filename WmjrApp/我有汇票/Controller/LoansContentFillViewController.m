//
//  LoansContentFillViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/11/20.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "LoansContentFillViewController.h"

@interface LoansContentFillViewController ()

@property (nonatomic, strong)UIButton *commitApplyButton;
@property (nonatomic, strong)UITextField *inputLoansMoney;//借款金额
@property (nonatomic, strong)UITextField *inputLoansDuration;//借款期限
@property (nonatomic, strong)UITextField *inputApplyName;//申请人姓名
@property (nonatomic, strong)UITextField *inputApplyPhone;//申请人电话
@property (nonatomic, strong)UITextField *inputProfession;//申请人职业

@end

@implementation LoansContentFillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"借款信息填写";
    
    [self setUpLayout];
}

#pragma mark - 界面布局
- (void)setUpLayout {
    
    _commitApplyButton = [[UIButton alloc]init];
    [_commitApplyButton setTitle:@"提交申请" forState:UIControlStateNormal];
    [_commitApplyButton setBackgroundColor:RGBA(232, 232, 232, 1.0)];
    [_commitApplyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
        make.height.mas_equalTo(3000);
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
    
    _inputLoansMoney = [[UITextField alloc]init];
    _inputLoansMoney.placeholder = @"请输入借款面额(元)";
    _inputLoansMoney.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputLoansMoney.textAlignment = NSTextAlignmentRight;
    [row1View addSubview:_inputLoansMoney];
    [_inputLoansMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row1View.mas_top).with.offset(RESIZE_UI(20));
        make.right.equalTo(row1View.mas_right).with.offset(-RESIZE_UI(20));
    }];
    
    UILabel *tip1Label = [[UILabel alloc]init];
    tip1Label.text = @"注:借款金额需小于等于票面金额88元";
    tip1Label.textColor = RGBA(0, 104, 178, 1.0);
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
    
    _inputLoansDuration = [[UITextField alloc]init];
    _inputLoansDuration.placeholder = @"请输入借款期限(天)";
    _inputLoansDuration.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputLoansDuration.textAlignment = NSTextAlignmentRight;
    [row2View addSubview:_inputLoansDuration];
    [_inputLoansDuration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row2View.mas_top).with.offset(RESIZE_UI(20));
        make.right.equalTo(row2View.mas_right).with.offset(-RESIZE_UI(20));
    }];
    
    UILabel *tip2Label = [[UILabel alloc]init];
    tip2Label.text = @"注:借款期限需要小于等于票据到期期限12天";
    tip2Label.textColor = RGBA(0, 104, 178, 1.0);
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
    label3.text = @"申请人姓名";
    label3.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label3.textColor = RGBA(102, 102, 102, 1.0);
    [row3View addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row3View);
        make.left.equalTo(row3View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _inputApplyName = [[UITextField alloc]init];
    _inputApplyName.placeholder = @"请输入申请人姓名";
    _inputApplyName.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputApplyName.textAlignment = NSTextAlignmentRight;
    [row3View addSubview:_inputApplyName];
    [_inputApplyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row3View);
        make.right.equalTo(row3View.mas_right).with.offset(-RESIZE_UI(20));
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
    label4.text = @"申请人电话";
    label4.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label4.textColor = RGBA(102, 102, 102, 1.0);
    [row4View addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row4View);
        make.left.equalTo(row4View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _inputApplyPhone = [[UITextField alloc]init];
    _inputApplyPhone.placeholder = @"请输入申请人电话";
    _inputApplyPhone.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputApplyPhone.textAlignment = NSTextAlignmentRight;
    [row4View addSubview:_inputApplyPhone];
    [_inputApplyPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row4View);
        make.right.equalTo(row4View.mas_right).with.offset(-RESIZE_UI(20));
    }];
    
    //第五行
    UIView *row5View = [[UIView alloc]init];
    row5View.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:row5View];
    [row5View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row4View.mas_bottom).with.offset(1);
        make.left.equalTo(viewMain.mas_left);
        make.right.equalTo(viewMain.mas_right);
        make.height.mas_offset(RESIZE_UI(60));
    }];
    
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
    [row5View addSubview:_inputProfession];
    [_inputProfession mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row5View);
        make.right.equalTo(row5View.mas_right).with.offset(-RESIZE_UI(20));
    }];
    
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
