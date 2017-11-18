//
//  ImmediatelyMoneyOrderViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/11/17.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "ImmediatelyMoneyOrderViewController.h"

@interface ImmediatelyMoneyOrderViewController ()

@property (nonatomic, strong)UIButton *nextStepButton;
@property (nonatomic, strong)UIButton *shangpiaoButton;
@property (nonatomic, strong)UIButton *yinpiaoButton;
@property (nonatomic, strong)UITextField *inputPiaojuMoney;
@property (nonatomic, strong)UITextField *inputRate;
@property (nonatomic, strong)UITextField *inputChengdui;

@end

@implementation ImmediatelyMoneyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"立即申请";
    self.view.backgroundColor = RGBA(240, 241, 243, 1.0);
    [self setUpLayout];
}

#pragma mark - 界面布局
- (void)setUpLayout {
    
    _nextStepButton = [[UIButton alloc]init];
    [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextStepButton setBackgroundColor:RGBA(232, 232, 232, 1.0)];
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
        make.height.mas_offset(2000);
    }];
    
    //第一行
    UIView *row1View = [[UIView alloc]init];
    row1View.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:row1View];
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
    [self.view addSubview:row2View];
    [row2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row1View.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(60));
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"票据金额";
    label2.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label2.textColor = RGBA(102, 102, 102, 1.0);
    [row2View addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row2View);
        make.left.equalTo(row2View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _inputPiaojuMoney = [[UITextField alloc]init];
    _inputPiaojuMoney.placeholder = @"请输入票据面额(元)";
    _inputPiaojuMoney.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputPiaojuMoney.textAlignment = NSTextAlignmentRight;
    [row2View addSubview:_inputPiaojuMoney];
    [_inputPiaojuMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row2View);
        make.right.equalTo(row2View.mas_right).with.offset(-RESIZE_UI(20));
    }];
    
    //第三行
    UIView *row3View = [[UIView alloc]init];
    row3View.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:row3View];
    [row3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row2View.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(60));
    }];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"期望利率";
    label3.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label3.textColor = RGBA(102, 102, 102, 1.0);
    [row3View addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row3View);
        make.left.equalTo(row3View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _inputRate = [[UITextField alloc]init];
    _inputRate.placeholder = @"请输入期望利率(%)";
    _inputRate.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputRate.textAlignment = NSTextAlignmentRight;
    [row3View addSubview:_inputRate];
    [_inputRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row3View);
        make.right.equalTo(row3View.mas_right).with.offset(-RESIZE_UI(20));
    }];
    
    //第四行
    UIView *row4View = [[UIView alloc]init];
    row4View.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:row4View];
    [row4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row3View.mas_bottom).with.offset(1);
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
    
    //第五行
    UIView *row5View = [[UIView alloc]init];
    row5View.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:row5View];
    [row5View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row4View.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(60));
    }];
    
    UILabel *label5 = [[UILabel alloc]init];
    label5.text = @"承兑银行/承兑人";
    label5.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label5.textColor = RGBA(102, 102, 102, 1.0);
    [row5View addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row5View);
        make.left.equalTo(row5View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _inputChengdui = [[UITextField alloc]init];
    _inputChengdui.placeholder = @"请输入承兑对象";
    _inputChengdui.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputChengdui.textAlignment = NSTextAlignmentRight;
    [row5View addSubview:_inputChengdui];
    [_inputChengdui mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row5View);
        make.right.equalTo(row5View.mas_right).with.offset(-RESIZE_UI(20));
    }];
    
    //第六行
    UIView *row6View = [[UIView alloc]init];
    row6View.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:row6View];
    [row6View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row4View.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(240));
    }];
    
    UILabel *label6 = [[UILabel alloc]init];
    label6.text = @"承兑银行/承兑人";
    label6.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    label6.textColor = RGBA(102, 102, 102, 1.0);
    [row6View addSubview:label6];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row6View.mas_top).with.offset(RESIZE_UI(20));
        make.left.equalTo(row6View.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    UILabel *tip6Label = [[UILabel alloc]init];
    tip6Label.text = @"(请保持照片信息清晰,勿进行修图软件处理)";
    tip6Label.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
    tip6Label.textColor = RGBA(0, 102, 177, 1.0);
    [row6View addSubview:tip6Label];
    [tip6Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label6.mas_bottom).with.offset(RESIZE_UI(30));
        make.left.equalTo(row6View.mas_left).with.offset(RESIZE_UI(20));
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
