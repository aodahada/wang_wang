//
//  AddAddressViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/17.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "AddAddressViewController.h"
#import "AreaSelectView.h"
#import "IntegralAddressModel.h"

@interface AddAddressViewController ()<UITextViewDelegate>

@property (nonatomic, strong)UITextField *oneTextField;//收货人
@property (nonatomic, strong)UITextField *twoTextField;//手机号
@property (nonatomic, strong)UITextField *threeTextField;//所在地区
@property (nonatomic, strong)UITextView *fourTextView;//详细地址
@property (nonatomic, strong)UISwitch *fiveSwitch;//设为默认地址
/** 省*/
@property (copy, nonatomic) NSString *province;
/** 市*/
@property (copy, nonatomic) NSString *city;
/** 区*/
@property (copy, nonatomic) NSString *district;

@property (nonnull, copy) NSString *sandPath;//沙盒路径

@end

@implementation AddAddressViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"AddAddressViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AddAddressViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收货地址";
    self.view.backgroundColor = [UIColor whiteColor];
//    if (self.integralAddressModel) {
//        
//    } else {
//        
//    }
    [self getAddressPlist];
    
    UIButton *saveAddressButton = [[UIButton alloc]init];
    [saveAddressButton setTitle:@"保存地址" forState:UIControlStateNormal];
    [saveAddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveAddressButton setBackgroundColor:RGBA(255, 84, 34, 1.0)];
    saveAddressButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    if (self.integralAddressModel) {
        [saveAddressButton addTarget:self action:@selector(saveAddressInformation) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [saveAddressButton addTarget:self action:@selector(addAddressInformation) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:saveAddressButton];
    [saveAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_offset(RESIZE_UI(49));
    }];
    
    UIScrollView *mainScrollView = [[UIScrollView alloc]init];
    mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(saveAddressButton.mas_top);
    }];
    
    UIView *mainView = [[UIView alloc]init];
    mainView.backgroundColor = RGBA(238, 240, 242, 1.0);
    [mainScrollView addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.equalTo(self.view.mas_width);
        make.height.mas_offset(1000);
    }];
    
    UIView *oneView = [[UIView alloc]init];
    oneView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:oneView];
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(53));
    }];
    
    UILabel *oneLabel = [[UILabel alloc]init];
    oneLabel.text = @"收货人:";
    oneLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [oneView addSubview:oneLabel];
    [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(oneView.mas_centerY);
        make.left.equalTo(oneView.mas_left).with.offset(RESIZE_UI(12));
        make.width.mas_offset(RESIZE_UI(71));
    }];
    
    _oneTextField = [[UITextField alloc]init];
    _oneTextField.textColor = RGBA(153, 153, 153, 1.0);
    _oneTextField.placeholder = @"请填写收货人姓名";
    if (self.integralAddressModel) {
        _oneTextField.text = self.integralAddressModel.name;
    }
    _oneTextField.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [oneView addSubview:_oneTextField];
    [_oneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(oneView.mas_centerY);
        make.left.equalTo(oneLabel.mas_right).with.offset(RESIZE_UI(20));
        make.right.equalTo(oneView.mas_right).with.offset(-RESIZE_UI(5));
        make.height.mas_offset(RESIZE_UI(14));
    }];
    
    UIView *twoView = [[UIView alloc]init];
    twoView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:twoView];
    [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneView.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(53));
    }];
    
    UILabel *twoLabel = [[UILabel alloc]init];
    twoLabel.text = @"手机号码:";
    twoLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [twoView addSubview:twoLabel];
    [twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(twoView.mas_centerY);
        make.left.equalTo(oneLabel.mas_left);
        make.width.mas_offset(RESIZE_UI(71));
    }];
    
    _twoTextField = [[UITextField alloc]init];
    _twoTextField.textColor = RGBA(153, 153, 153, 1.0);
    _twoTextField.placeholder = @"请填写手机号";
    if (self.integralAddressModel) {
        _twoTextField.text = self.integralAddressModel.mobile;
    }
    _twoTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _twoTextField.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [twoView addSubview:_twoTextField];
    [_twoTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(twoView.mas_centerY);
        make.left.equalTo(twoLabel.mas_right).with.offset(RESIZE_UI(20));
        make.right.equalTo(twoView.mas_right).with.offset(-RESIZE_UI(5));
        make.height.mas_offset(RESIZE_UI(14));
    }];
    
    UIView *threeView = [[UIView alloc]init];
    threeView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:threeView];
    [threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoView.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(53));
    }];
    
    UILabel *threeLabel = [[UILabel alloc]init];
    threeLabel.text = @"所在地区:";
    threeLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [threeView addSubview:threeLabel];
    [threeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(threeView.mas_centerY);
        make.width.mas_offset(RESIZE_UI(71));
        make.left.equalTo(oneLabel.mas_left);
    }];
    
    _threeTextField = [[UITextField alloc]init];
    _threeTextField.placeholder = @"点击选择地区";
    if (self.integralAddressModel) {
        _threeTextField.text = self.integralAddressModel.district;
    }
    _threeTextField.textColor = RGBA(153, 153, 153, 1.0);
    _threeTextField.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [threeView addSubview:_threeTextField];
    [_threeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(threeView.mas_centerY);
        make.left.equalTo(threeLabel.mas_right).with.offset(RESIZE_UI(20));
        make.right.equalTo(threeView.mas_right).with.offset(-RESIZE_UI(10));
        make.height.mas_offset(RESIZE_UI(14));
    }];
    
    UIButton *selectButton = [[UIButton alloc]init];
    [selectButton setBackgroundColor:[UIColor clearColor]];
    [selectButton addTarget:self action:@selector(selectAreaMethod) forControlEvents:UIControlEventTouchUpInside];
    [threeView addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(threeView.mas_centerY);
        make.left.equalTo(_threeTextField.mas_left);
        make.right.equalTo(threeView.mas_right).with.offset(-RESIZE_UI(5));
        make.height.mas_offset(RESIZE_UI(30));
    }];
    
    UIView *fourView = [[UIView alloc]init];
    fourView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:fourView];
    [fourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeView.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(105));
    }];
    
    UILabel *fourLabel = [[UILabel alloc]init];
    fourLabel.text = @"详细地址:";
    fourLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [mainView addSubview:fourLabel];
    [fourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fourView.mas_top).with.offset(RESIZE_UI(12));
        make.left.equalTo(oneLabel.mas_left);
        make.width.mas_offset(RESIZE_UI(71));
    }];
    
    _fourTextView = [[UITextView alloc]init];
    _fourTextView.textColor = RGBA(199, 199, 204, 1.0);
    if (self.integralAddressModel) {
        _fourTextView.text = self.integralAddressModel.address;
    } else {
        _fourTextView.text = @"请输入详细地址";
    }
//    _fourTextView.backgroundColor = [UIColor redColor];
    _fourTextView.delegate = self;
    _fourTextView.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [fourView addSubview:_fourTextView];
    [_fourTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fourView.mas_top).with.offset(RESIZE_UI(3));
        make.left.equalTo(fourLabel.mas_right).with.offset(RESIZE_UI(16));
        make.bottom.equalTo(fourView.mas_bottom).with.offset(-RESIZE_UI(10));
        make.right.equalTo(fourView.mas_right).with.offset(-RESIZE_UI(10));
    }];
    
    UIView *fiveView = [[UIView alloc]init];
    fiveView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:fiveView];
    [fiveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fourView.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(53));
    }];
    
    UILabel *fiveLabel = [[UILabel alloc]init];
    fiveLabel.text = @"设为默认地址:";
    fiveLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    [mainView addSubview:fiveLabel];
    [fiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneLabel.mas_left);
        make.centerY.equalTo(fiveView.mas_centerY);
    }];
    
    _fiveSwitch = [[UISwitch alloc]init];
    _fiveSwitch.onTintColor = RGBA(0, 106, 179, 1.0);
    if (self.integralAddressModel) {
        if ([self.integralAddressModel.is_default isEqualToString:@"1"]) {
            [_fiveSwitch setOn:YES];
        } else {
            [_fiveSwitch setOn:NO];
        }
    }
    [fiveView addSubview:_fiveSwitch];
    [_fiveSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(fiveView.mas_centerY);
        make.right.equalTo(fiveView.mas_right).with.offset(-RESIZE_UI(15));
        make.width.mas_offset(RESIZE_UI(51));
        make.height.mas_offset(RESIZE_UI(31));
    }];
    
    
}

#pragma mark - 检测有没有addressPlist
- (void)getAddressPlist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    self.sandPath = docDir;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *file = [fileManager contentsOfDirectoryAtPath:docDir error:nil];
    if (![file containsObject:@"area.plist"]) {
        [self getAddressList];
    } else {
    }
}

#pragma mark - 获取地址列表
- (void)getAddressList {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Address/district" withParamDictionary:@{@"show_children":@"3"} withBlock:^(id obj) {
        
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSDictionary *dic = obj;
                NSArray *array = [dic objectForKey:@"data"];
                NSString *path = [self.sandPath stringByAppendingPathComponent:@"area.plist"];
                [array writeToFile:path atomically:YES];
                [SVProgressHUD dismiss];
                return ;
            } else {
                NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确定";
                [SVProgressHUD dismiss];
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
                [alertView show];
            }
        }
    }];
}

#pragma mark - 选择区域
- (void)selectAreaMethod {
    [_oneTextField resignFirstResponder];
    [_twoTextField resignFirstResponder];
    [_fourTextView resignFirstResponder];
    AreaSelectView *areaView = [[AreaSelectView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:areaView];
    @weakify(self);
    [areaView pickViewButtonSelectWithSelect:^(NSString *province, NSString *city, NSString *district) {
        @strongify(self);
        if (district) {
            [self.threeTextField setText:[NSString stringWithFormat:@"%@ %@ %@",province,city,district]];
            self.province = province;
            self.city = city;
            self.district = district;
        } else {
            [self.threeTextField setText:[NSString stringWithFormat:@"%@,%@",province,city]];
            self.province = province;
            self.city = city;
        }
        
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"请输入详细地址";
        textView.textColor = RGBA(199, 199, 204, 1.0);
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入详细地址"]){
        textView.text=@"";
        textView.textColor=RGBA(153, 153, 153, 1.0);
    }
}

#pragma mark - 保存修改地址
- (void)saveAddressInformation {
    if ([_oneTextField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请填写收货人"];
        return;
    }
    if (_twoTextField.text.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    if ([_fourTextView.text isEqualToString:@"请输入详细地址"]) {
        [SVProgressHUD showInfoWithStatus:@"请输入详细地址"];
        return;
    }
    NSString *isDefault = @"";
    if (_fiveSwitch.isOn) {
        isDefault = @"1";
    } else {
        isDefault = @"0";
    }
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Address/edit" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid,@"address_id":self.integralAddressModel.id,@"name":_oneTextField.text,@"mobile":_twoTextField.text,@"district":_threeTextField.text,@"address":_fourTextView.text,@"is_default":isDefault} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            [[SingletonManager sharedManager] showHUDView:self.view title:@"保存成功" content:@"" time:1.0 andCodes:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
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

#pragma mark - 新增地址
- (void)addAddressInformation {
    if ([_oneTextField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请填写收货人"];
        return;
    }
    if (_twoTextField.text.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    if ([_fourTextView.text isEqualToString:@"请输入详细地址"]) {
        [SVProgressHUD showInfoWithStatus:@"请输入详细地址"];
        return;
    }
    NSString *isDefault = @"";
    if (_fiveSwitch.isOn) {
        isDefault = @"1";
    } else {
        isDefault = @"0";
    }
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Address/add" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid,@"name":_oneTextField.text,@"mobile":_twoTextField.text,@"district":_threeTextField.text,@"address":_fourTextView.text,@"is_default":isDefault} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            [[SingletonManager sharedManager] showHUDView:self.view title:@"添加成功" content:@"" time:1.0 andCodes:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
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
