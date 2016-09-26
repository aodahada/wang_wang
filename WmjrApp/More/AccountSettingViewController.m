//
//  AccountViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/6/17.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "PopMenu.h"
#import "AvatorChangeView.h"
#import "PhoneChangeView.h"
#import "UserInfoModel.h"
#import "AvatorSettingCell.h"
#import "NSString+StringCode.h"
#import "LoginViewController.h"
#import "RealNameCertificationViewController.h"
#import "AddBankViewController.h"
#import "MyselfBankViewController.h"
#import "MyselfAccountController.h"
#import "ResetLoginPasswordViewController.h"
#import "ResetTradePasswordViewController.h"
#import "MMPopupWindow.h"
#import "MMPopupItem.h"
#import "RestPassWordViewController.h"

@interface AccountSettingViewController ()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AvatorSettingDelegate, UIAlertViewDelegate> {
    UITableView *_tableView;
    PopMenu *_popMenu;
    
    PhoneChangeView *_phoneChangeView;
    
    NSMutableArray *_dataSource1;
    NSMutableArray *_dataSource2;
    NSMutableArray *_dataSource3;
    NSMutableArray *_dataSource4;
}

@property (nonatomic, strong) UILabel *detailLab; /* 副标题 */
@property (nonatomic, copy) NSString *isRealNameStr; /* 实名认证 */
@property (nonatomic, copy) NSString *card_idStr; /* 绑定银行卡 */

@end

@implementation AccountSettingViewController

- (void)configNagationBar {
    self.title = @"账户设置";
    [[MMPopupWindow sharedWindow] cacheWindow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNagationBar];
    
    _dataSource1 = [NSMutableArray array];
    _dataSource2 = [NSMutableArray array];
    _dataSource3 = [NSMutableArray array];
    _dataSource4 = [NSMutableArray array];
//    [self getDataWithNetManager];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[AvatorSettingCell class] forCellReuseIdentifier:@"avatorCell"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self getDataWithNetManager];
    
    /* 当实名认证成功返回后直接刷新对应的单元格 */
//    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:(UITableViewRowAnimationNone)];
}

#pragma mark - 数据处理 －
- (void)getDataWithNetManager {
    //查询用户信息
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"查询中"];
    NSDictionary *paramDic4 = @{@"member_id":[SingletonManager sharedManager].uid};
    [manager postDataWithUrlActionStr:@"User/que" withParamDictionary:paramDic4 withBlock:^(id obj) {
        if (obj) {
//            NSLog(@"4 === %@", obj);
            UserInfoModel *model4 = [[UserInfoModel alloc] init];
            [model4 setValuesForKeysWithDictionary:obj[@"data"]];
            [_dataSource4 addObject:model4];
            [SVProgressHUD dismiss];
        } else {
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            [SVProgressHUD dismiss];
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
        [_tableView reloadData];
    }];
}

#pragma mark - UITableView dataSource delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfoModel *model4 = [_dataSource4 firstObject];
    if (indexPath.section == 0) {
        AvatorSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"avatorCell" forIndexPath:indexPath];
        [cell configCellWithModel:model4];
        
        cell.delegate = self;
        cell.indexPath = indexPath;
        
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        /* 放置lable设置副标题, 以便隐藏和改变 */
        switch (indexPath.row) {
            case 0:
            {
                [self separatorLineShowInView:cell];
                /* 账号 */
                cell.textLabel.text = @"账号";
                /* 更改手机号格式 */
                for (UIView *aView in cell.subviews) {
                    if ([aView isKindOfClass:[UILabel class]]) {
                    } else {
                        NSMutableString *phoneNum = [model4.mobile mutableCopy];
                        [phoneNum replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
                        [cell addSubview:[self detailLableTitle:phoneNum withRealNameId:@"0"]];
                    }
                }
            }
                break;
//            case 1:
//            {
//                [self separatorLineShowInView:cell];
//                /*  实名认证 */
//                cell.textLabel.text = @"实名认证";
//                /* 通过属性若是实名认证成功,变为 "认证" */
//                NSString *isRealName = model4.is_real_name;
//                _isRealNameStr = isRealName;
//                NSString *realNameStr = nil;
//                if ([isRealName isEqualToString:@"0"]) {
//                    realNameStr = @"未认证";
//                }
//                if ([isRealName isEqualToString:@"1"]) {
//                    realNameStr = @"已认证";
//                }
//                [cell addSubview:[self detailLableTitle:realNameStr withRealNameId:isRealName]];
//            }
//                break;
//            case 2:
//            {
//                [self separatorLineShowInView:cell];
//                /*  我的银行卡 */
//                cell.textLabel.text = @"我的银行卡";
//                /* 通过属性若是银行卡绑定成功,变为 "认证" */
//                NSString *isCard_id = model4.card_id;
//                NSString *card_idStr = nil;
//                if (isCard_id != nil) {
//                    if ([isCard_id isEqualToString:@"0"]) {
//                        card_idStr = @"未绑定";
//                    } else {
//                        card_idStr = @"已绑定";
//                    }
//                    [cell addSubview:[self detailLableTitle:card_idStr withRealNameId:isCard_id]];
//                }
//            }
//                break;
            case 1:
            {
                [self separatorLineShowInView:cell];
                /*  修改登录密码 */
                cell.textLabel.text = @"修改登录密码";
            }
                break;
            case 2:
            {
                /*  修改交易密码 */
                cell.textLabel.text = @"修改交易密码";
            }
                break;
                
            default:
                break;
        }
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor = TITLE_COLOR;
        
        return cell;
    } else {
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor];
        UILabel *exitLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, VIEW_WIDTH - 40, 35)];
        exitLable.text = @"安 全 退 出";
        exitLable.textColor = VIEWBACKCOLOR;
        exitLable.backgroundColor = BASECOLOR;
        exitLable.font = [UIFont systemFontOfSize:17.0f];
        exitLable.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:exitLable];
        
        return cell;
    }
}

/* 设置分割线 */
- (void)separatorLineShowInView:(UITableViewCell *)cell {
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(15, 43, SCREEN_WIDTH - 15, 1)];
    lable.backgroundColor = AUXILY_COLOR;
    lable.alpha = .1;
    [cell addSubview:lable];
}

/* 设置副标题 */
- (UILabel *)detailLableTitle:(NSString *)deTitStr withRealNameId:(NSString *)isRealNameStr {
    UILabel *deatailLab = [[UILabel alloc] initWithFrame:CGRectMake(RESIZE_UI(150), 12, 150, 21)];
    if ([isRealNameStr isEqualToString:@"0"]) {
        deatailLab.text = deTitStr;
        deatailLab.textColor = AUXILY_COLOR;
    } else {
        deatailLab.text = deTitStr;
        deatailLab.textColor = [UIColor blueColor];
    }
    deatailLab.font = [UIFont systemFontOfSize:14.0];
    
    return deatailLab;
}

//点击头像
- (void)clickAvatorBtnWithCell:(AvatorSettingCell *)cell withIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"点击头像");
    _popMenu = [[PopMenu alloc] init];
    _popMenu.dimBackground = YES;
    _popMenu.coverNavigationBar = YES;
    AvatorChangeView *avatorChangeView = [[AvatorChangeView alloc] initWithFrame:RESIZE_FRAME(CGRectMake(35, 200, 305, 150))];
    avatorChangeView.layer.cornerRadius = 5;
    avatorChangeView.layer.masksToBounds = YES;
    [_popMenu addSubview:avatorChangeView];
    [_popMenu showInRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    /* 修改头像 */
    [avatorChangeView callBtnEventBlock:^(UIButton *sender) {
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
    
    [SVProgressHUD showWithStatus:@"正在上传头像" maskType:(SVProgressHUDMaskTypeNone)];
    [httpManager POST:WMJRAPI parameters:@{@"msg":base64Str, @"file":@"ss"} constructingBodyWithBlock:^(id formData) {
        [formData appendPartWithFileData:editedData
                                                       name:@"file[]"
                                                  fileName:@"yifan3.png"
                                                mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        id obj = [manager paramUnCodeStr:responseStr];
        if (obj) {
            UserInfoModel *model1 = [[UserInfoModel alloc] init];
            [model1 setValuesForKeysWithDictionary:obj[@"data"]];
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            for (UIView *aView in cell.contentView.subviews) {
                if ([aView isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)aView;
                    [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model1.photourl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zhtx_icon.png"]];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];

    [self dismissViewControllerAnimated:YES completion:nil];
    [SVProgressHUD showSuccessWithStatus:@"上传成功" maskType:(SVProgressHUDMaskTypeNone)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return RESIZE_UI(70);
    } else if (indexPath.section == 2) {
        return 35;
    } else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return RESIZE_UI(5);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return RESIZE_UI(30);
    } else {
        return .1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        NSLog(@"---修改资料----");
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        UILabel *aLable = nil;
        for (UIView *aView in cell.contentView.subviews) {
            if ([aView isKindOfClass:[UILabel class]]) {
                aLable = (UILabel *)aView;
            }
        }
        NSLog(@"%@", aLable.text);
        
        MMPopupBlock completeBlock = ^(MMPopupView *popupView){
        };
        [[[MMAlertView alloc] initWithInputTitle:@"修改昵称" detail:nil placeholder:@"请输入昵称" handler:^(NSString *text) {
            if ([text isEqualToString:@""]) {
                text = aLable.text;
            }
            NSLog(@"%ld", text.length);
            //修改用户信息
            NetManager *manager = [[NetManager alloc] init];
            [SVProgressHUD showWithStatus:@"修改中"];
            [manager postDataWithUrlActionStr:@"User/change" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"name":text} withBlock:^(id obj) {
                if (obj) {
                    //                NSLog(@"2 === %@", obj);
                    UserInfoModel *model2 = [[UserInfoModel alloc] init];
                    [model2 setValuesForKeysWithDictionary:obj[@"data"]];
                    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                    for (UIView *aView in cell.contentView.subviews) {
                        if ([aView isKindOfClass:[UILabel class]]) {
                            UILabel *aLable = (UILabel *)aView;
                            aLable.text = model2.name;
                        }
                    }
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
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [_tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
            
        }] showWithBlock:completeBlock];
        
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
//            case 1:
//            {
//                //实名认证
//                if ([[SingletonManager sharedManager].isRealName isEqualToString:@"0"] && [_isRealNameStr isEqualToString:@"0"]) {
//                    RealNameCertificationViewController *realNameCerVC = [[RealNameCertificationViewController alloc] init];
//                    [self.navigationController pushViewController:realNameCerVC animated:YES];
//                }
//            }
//                break;
            case 0:
            {
                //修改手机号
                _popMenu = [[PopMenu alloc] init];
                _popMenu.dimBackground = YES;
                _popMenu.coverNavigationBar = YES;
                _phoneChangeView = [[PhoneChangeView alloc] initWithFrame:RESIZE_FRAME(CGRectMake(35, 200, 305, 170))];
                _phoneChangeView.layer.cornerRadius = 5;
                _phoneChangeView.layer.masksToBounds = YES;
                [_popMenu addSubview:_phoneChangeView];
                [_popMenu showInRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                
                [_phoneChangeView callBtnEventBlock:^(UIButton *sender, NSString *text) {
                    NSString *titStr = sender.titleLabel.text;
                    if ([titStr isEqualToString:@"取消"]) {
                        [_popMenu dismissMenu];
                        return ;
                    }
                    //修改手机号
                    if ([titStr isEqualToString:@"确定"]) {
                        [_popMenu dismissMenu];
                        NetManager *manager = [[NetManager alloc] init];
                        [SVProgressHUD showWithStatus:@"修改中"];
                        NSDictionary *paramDic3 = @{@"member_id":[SingletonManager sharedManager].uid, @"new_mobile":text};
                        [manager postDataWithUrlActionStr:@"User/chanMob" withParamDictionary:paramDic3 withBlock:^(id obj) {
                            if ([obj[@"result"] isEqualToString:@"1"]) {
                                UserInfoModel *model3 = [[UserInfoModel alloc] init];
                                [model3 setValuesForKeysWithDictionary:obj[@"data"]];
                                UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                                for (UIView *aView in cell.subviews) {
                                    if ([aView isKindOfClass:[UILabel class]]) {
                                        [aView removeFromSuperview];
                                    }
                                }
                                NSMutableString *phoneNum = [model3.mobile mutableCopy];
                                [phoneNum replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
                                [cell addSubview:[self detailLableTitle:phoneNum withRealNameId:@"0"]];
                                [SVProgressHUD dismiss];
                            } else {
                                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                                alertConfig.defaultTextOK = @"确定";
                                [SVProgressHUD dismiss];
                                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:[obj[@"data"] objectForKey:@"mes"]];
                                [alertView show];
                            }
                        }];
                        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
                        [_tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }];
            }
                break;
//            case 2:
//            {
//                
//                if ([[SingletonManager sharedManager].isCard_id isEqualToString:@"0"]) {
//                    /*  我的银行卡 */
//                    UIStoryboard *addbank = [UIStoryboard storyboardWithName:@"AddBankViewController" bundle:[NSBundle mainBundle]];
//                    AddBankViewController *addBankVC = [addbank instantiateViewControllerWithIdentifier:@"AddBank"];
//                    addBankVC.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:addBankVC animated:YES];
//                } else {
//                    MyselfBankViewController *myselfBankVC = [[MyselfBankViewController alloc] init];
//                    myselfBankVC.card_id = [SingletonManager sharedManager].isCard_id;
//                    [self.navigationController pushViewController:myselfBankVC animated:YES];
//                }
//            }
//                break;
            case 1:
            {
                /* 修改登录密码 */
                ResetLoginPasswordViewController *resetLoginPVC = [[ResetLoginPasswordViewController alloc] init];
                [self.navigationController pushViewController:resetLoginPVC animated:YES];
            }
                break;
            case 2:
            {
                /* 修改交易密码 */
//                ResetTradePasswordViewController *resetTradeVC = [[ResetTradePasswordViewController alloc] init];
//                [self.navigationController pushViewController:resetTradeVC animated:YES];
                [self resetPasswordMethod];
                
            }
                break;
                
            default:
                break;
        }
    } else {
        /* 安全退出 */
        MMPopupItemHandler block = ^(NSInteger index){
            if (index == 0) {
                return ;
            }
            if (index == 1) {
                /* 将当前的uid置为空 */
                [SingletonManager sharedManager].uid = @"";
                [SingletonManager sharedManager].isRealName = @"0";
                [SingletonManager sharedManager].isCard_id = @"0";
                [[NSUserDefaults standardUserDefaults] setObject:[SingletonManager sharedManager].isRealName forKey:@"isRealName"];
                [[NSUserDefaults standardUserDefaults] setObject:[SingletonManager sharedManager].isCard_id forKey:@"isCard_id"];
                [[NSUserDefaults standardUserDefaults] setValue:[SingletonManager sharedManager].uid forKey:@"uid"];
                [[NSUserDefaults standardUserDefaults] synchronize];
#warning 待定
                //可能退出时也要删除手势密码
//                [KeychainData forgotPsw];
                [[SingletonManager sharedManager] removeHandGestureInfoDefault];
                
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                loginVC.loginIden = @"login";
                loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                UINavigationController *loginNa = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNa animated:YES completion:^{
                }];
                [self.navigationController popViewControllerAnimated:YES];
            }
        };
        NSArray *items =
        @[MMItemMake(@"取消", MMItemTypeNormal, block),
          MMItemMake(@"确定", MMItemTypeNormal, block)];
        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                             detail:@"是否确定退出"
                                                              items:items];
        [alertView show];
    }
}

#pragma mark - 修改交易密码接口
- (void)resetPasswordMethod {
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"请稍后"];
    [manager postDataWithUrlActionStr:@"User/new_set_trade_pwd" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                
                NSDictionary *dataDic = obj[@"data"];
                NSString *redirect_url = dataDic[@"redirect_url"];
                RestPassWordViewController *restPassVC = [[RestPassWordViewController alloc]initWithNibName:@"RestPassWordViewController" bundle:nil];
                restPassVC.redirect_url = redirect_url;
                [self.navigationController pushViewController:restPassVC animated:YES];
                [SVProgressHUD dismiss];
                return ;
            }
            if ([obj[@"result"] isEqualToString:@"1000"]) {
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

//修改姓名
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 308) {
        if (buttonIndex == 0) {
            return;
        }
        UITextField *text = [alertView textFieldAtIndex:0];
        //修改用户信息
        NetManager *manager = [[NetManager alloc] init];
//        [SVProgressHUD showInfoWithStatus:@""]
        [SVProgressHUD showWithStatus:@"修改中"];
        [manager postDataWithUrlActionStr:@"User/change" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"name":text.text} withBlock:^(id obj) {
            if (obj) {
//                NSLog(@"2 === %@", obj);
                UserInfoModel *model2 = [[UserInfoModel alloc] init];
                [model2 setValuesForKeysWithDictionary:obj[@"data"]];
                UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                for (UIView *aView in cell.contentView.subviews) {
                    if ([aView isKindOfClass:[UILabel class]]) {
                        UILabel *aLable = (UILabel *)aView;
                        aLable.text = model2.name;
                    }
                }
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
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
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
