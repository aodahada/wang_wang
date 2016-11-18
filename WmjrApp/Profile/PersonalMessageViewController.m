//
//  PersonalMessageViewController.m
//  WmjrApp
//
//  Created by horry on 2016/11/1.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "PersonalMessageViewController.h"
#import "PopMenu.h"
#import "AvatorChangeView.h"

@interface PersonalMessageViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UITableView *tableViewForPersonal;

@property (nonatomic, strong) UIImageView *imageViewForPic;
@property (nonatomic, strong) UILabel *labelForName;
@property (nonatomic, strong) UILabel *labelForPhone;
@property (nonatomic, strong) PopMenu *popMenu;
@property (nonatomic, strong) AvatorChangeView *avatorChangeView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGes;

@end

@implementation PersonalMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(238, 238, 238, 1.0);
    _tableViewForPersonal = [[UITableView alloc]init];
    _tableViewForPersonal.scrollEnabled = NO;
    _tableViewForPersonal.backgroundColor = RGBA(238, 238, 238, 1.0);
    _tableViewForPersonal.delegate = self;
    _tableViewForPersonal.dataSource = self;
    _tableViewForPersonal.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableViewForPersonal];
    [_tableViewForPersonal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(12);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 70;
    } else {
        return 44;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Cellindentifier = @"Cellindentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellindentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cellindentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = RGBA(20, 20, 23, 1.0);
    }
    switch (indexPath.row) {
        case 0:{
            cell.textLabel.text = @"修改头像";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            _imageViewForPic = [[UIImageView alloc]init];
            [_imageViewForPic sd_setImageWithURL:[NSURL URLWithString:[SingletonManager sharedManager].userModel.photourl]];
            _imageViewForPic.layer.masksToBounds = YES;
            _imageViewForPic.layer.cornerRadius = 43/2;
            [cell addSubview:_imageViewForPic];
            [_imageViewForPic mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.mas_right).with.offset(-36);
                make.width.height.mas_offset(43);
                make.centerY.equalTo(cell.mas_centerY);
            }];
        }
            break;
        case 1:{
            cell.textLabel.text = @"昵称";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            _labelForName = [[UILabel alloc]init];
            _labelForName.text = [SingletonManager sharedManager].userModel.name;
            _labelForName.font = [UIFont systemFontOfSize:14];
            _labelForName.textColor = RGBA(153, 153, 153, 1.0);
            [cell addSubview:_labelForName];
            [_labelForName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell.mas_right).with.offset(-36);
            }];
        }
            break;
        case 2:{
            cell.textLabel.text = @"账户";
            NSMutableString *phoneNum = [[SingletonManager sharedManager].userModel.mobile mutableCopy];
            [phoneNum replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
            _labelForPhone = [[UILabel alloc]init];
            _labelForPhone.text = phoneNum;
            _labelForPhone.font = [UIFont systemFontOfSize:14];
            _labelForPhone.textColor = RGBA(153, 153, 153, 1.0);
            [cell addSubview:_labelForPhone];
            [_labelForPhone mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell.mas_right).with.offset(-36);
            }];
        }
            break;
            
        default:
            break;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:{
            //更换头像
//            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选取图片",@"拍摄照片", nil];
//            [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
            
            
            _popMenu = [[PopMenu alloc] init];
            _popMenu.dimBackground = YES;
            _popMenu.coverNavigationBar = YES;
            _tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesMethod)];
            [_popMenu addGestureRecognizer:_tapGes];
            _avatorChangeView = [[AvatorChangeView alloc] initWithFrame:RESIZE_FRAME(CGRectMake(35, 200, 305, 150))];
            _avatorChangeView.layer.cornerRadius = 5;
            _avatorChangeView.layer.masksToBounds = YES;
            [_popMenu addSubview:_avatorChangeView];
            [_popMenu showInRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            
            /* 修改头像 */
            [_avatorChangeView callBtnEventBlock:^(UIButton *sender) {
                NSString *titStr = sender.titleLabel.text;
                [_popMenu dismissMenu];
                
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                if ([titStr isEqualToString:@"拍照"]) {
                    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"未检测到摄像头" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alert show];
                        return ;
                    } else {
                        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    }
                } if ([titStr isEqualToString:@"从相册中选取"]) {
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                }
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }];
            
        }
            break;
        case 1:{
            //更换昵称
            MMPopupBlock completeBlock = ^(MMPopupView *popupView){
            };
            [[[MMAlertView alloc] initWithInputTitle:@"修改昵称" detail:nil placeholder:@"请输入昵称" handler:^(NSString *text) {
                if ([text isEqualToString:@""]) {
                    text = _labelForName.text;
                }
                //修改用户信息
                NetManager *manager = [[NetManager alloc] init];
                [SVProgressHUD showWithStatus:@"修改中"];
                [manager postDataWithUrlActionStr:@"User/change" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"name":text} withBlock:^(id obj) {
                    if (obj) {
                        [UserInfoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                            return @{@"user_id" : @"id"};
                        }];
                        UserInfoModel *userModel = [UserInfoModel mj_objectWithKeyValues:obj[@"data"]];
                        [SingletonManager sharedManager].userModel = userModel;
                        _labelForName.text = userModel.name;
                        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                    } else {
                        NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
                        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                        alertConfig.defaultTextOK = @"确定";
                        [SVProgressHUD dismiss];
                        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
                        [alertView show];
                    }
                }];
                
            }] showWithBlock:completeBlock];
        }
            break;
        case 2:{
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)tapGesMethod {
    [_popMenu dismissMenu];
    _avatorChangeView = nil;
    _tapGes = nil;
}

#pragma mark - UIImagePickerController -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *editedImage = info[@"UIImagePickerControllerEditedImage"];
    NSData *editedData = UIImageJPEGRepresentation(editedImage, .3);
    
    //上传头像
    NetManager *manager = [[NetManager alloc] init];
    NSDictionary *paramDic1 = @{@"member_id":[SingletonManager sharedManager].uid};
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",  nil];//设置相应内容类型
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [httpManager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    NSString *dateNew = [manager getCurrentTimestamp];
    NSDictionary *paramDic = @{@"timestamp":dateNew, @"action":@"User/upPhoto", @"data":paramDic1};//参数序列
    NSString *base64Str = [manager paramCodeStr:paramDic];
    
    [SVProgressHUD showWithStatus:@"正在上传头像"];
    [httpManager POST:WMJRAPI parameters:@{@"msg":base64Str, @"file":@"ss"} constructingBodyWithBlock:^(id formData) {
        [formData appendPartWithFileData:editedData
                                    name:@"file[]"
                                fileName:@"yifan3.png"
                                mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        id obj = [manager paramUnCodeStr:responseStr];
        if (obj) {
            [UserInfoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"user_id":@"id"};
            }];
            UserInfoModel *userModel = [UserInfoModel mj_objectWithKeyValues:obj[@"data"]];
            [SingletonManager sharedManager].userModel  =userModel;
            [_imageViewForPic sd_setImageWithURL:[NSURL URLWithString:userModel.photourl]];
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *msgStr = @"上传失败";
        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
        alertConfig.defaultTextOK = @"确定";
        [SVProgressHUD dismiss];
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
        [alertView show];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [SVProgressHUD showSuccessWithStatus:@"上传成功" maskType:(SVProgressHUDMaskTypeNone)];
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
