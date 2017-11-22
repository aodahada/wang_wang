//
//  ReleaseBankCardViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/11/22.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "ReleaseBankCardViewController.h"

@interface ReleaseBankCardViewController ()<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong)UITextField *inputName;
@property (nonatomic, strong)UITextField *inputIdCard;
@property (nonatomic, strong)UITextField *inputBankCard;
@property (nonatomic, strong)UIButton *idCardButton1;
@property (nonatomic, strong)UIButton *idCardDeleteButton1;
@property (nonatomic, strong)UIButton *idCardButton2;
@property (nonatomic, strong)UIButton *idCardDeleteButton2;
@property (nonatomic, strong)UIButton *bankCardButton1;
@property (nonatomic, strong)UIButton *bankCardDeleteButton1;
@property (nonatomic, strong)UIButton *bankCardButton2;
@property (nonatomic, strong)UIButton *bankCardDeleteButton2;

@property (nonatomic, assign)NSInteger selectTag;//选择的哪个按钮

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
    self.title = @"解绑银行卡";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpLayOut];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ReleaseBankCardViewController"];
}

#pragma mark - 界面布局
- (void)setUpLayOut {
    UIButton *nextStepButton = [[UIButton alloc]init];
    [nextStepButton setTitle:@"提交申请" forState:UIControlStateNormal];
    [nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextStepButton setBackgroundColor:RGBA(255, 88, 26, 1.0)];
    [nextStepButton addTarget:self action:@selector(netStepButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStepButton];
    [nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.bottom.equalTo(nextStepButton.mas_top);
    }];
    
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
    [row1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView.mas_top);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(60));
    }];
    
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
    _inputName.keyboardType = UIKeyboardTypeDecimalPad;
    _inputName.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputName.textAlignment = NSTextAlignmentRight;
    [row1View addSubview:_inputName];
    [_inputName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row1View);
        make.right.equalTo(row1View.mas_right).with.offset(-RESIZE_UI(20));
    }];
    
    //第二行
    UIView *row2View = [[UIView alloc]init];
    row2View.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:row2View];
    [row2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row1View.mas_bottom).with.offset(RESIZE_UI(1));
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
    _inputIdCard.keyboardType = UIKeyboardTypeDecimalPad;
    _inputIdCard.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _inputIdCard.textAlignment = NSTextAlignmentRight;
    [row2View addSubview:_inputIdCard];
    [_inputIdCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row2View);
        make.right.equalTo(row2View.mas_right).with.offset(-RESIZE_UI(20));
    }];
    
    //第三行
    UIView *row3View = [[UIView alloc]init];
    row3View.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:row3View];
    [row3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(row2View.mas_bottom).with.offset(RESIZE_UI(1));
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
    [row3View addSubview:_inputBankCard];
    [_inputBankCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(row3View);
        make.right.equalTo(row3View.mas_right).with.offset(-RESIZE_UI(20));
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

#pragma mark - 选择图片
- (IBAction)selectHeadImageMethod:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
            
        default:
            break;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选取图片",@"拍摄照片", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}

#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *picker= [[UIImagePickerController alloc]init];
    picker.delegate = self;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (buttonIndex == 0) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    } else if (buttonIndex == 1) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        return;
    }
    // 没有拍照功能
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIAlertView *cameraAlert = [[UIAlertView alloc] init];
        cameraAlert.message = @"您的设备不支持拍照。";
        [cameraAlert addButtonWithTitle:@"OK"];
        [cameraAlert show];
        return;
    }
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:^{
    }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
}


#pragma mark - 提交申请
- (void)netStepButtonMethod {
    
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
