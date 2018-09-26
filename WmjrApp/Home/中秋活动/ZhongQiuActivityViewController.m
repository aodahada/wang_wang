//
//  ZhongQiuActivityViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/9/11.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "ZhongQiuActivityViewController.h"
#import "ZhongQiuQuestionModel.h"

@interface ZhongQiuActivityViewController ()
{
    UIButton *zhongjiangResultBtn;//中奖结果
    UIButton *activityRuleBtn;//活动规则
    UIButton *activityContentBtn;//活动内容
    UILabel *questionLabel;
    UILabel *a_answerLabel;
    UIButton *a_imageView;
    UILabel *b_answerLabel;
    UIButton *b_imageView;
    UILabel *c_answerLabel;
    UIButton *c_imageView;
    UILabel *c_title;
    UILabel *d_answerLabel;
    UIButton *d_imageView;
    UILabel *d_title;
    UILabel *rightAnswer;//正确答案
}

@property (nonatomic, strong)UIWindow *window;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *buttonArray;//选项按钮数组
@property (nonatomic, strong)ZhongQiuQuestionModel *currentModel;//当前Model
@property (nonatomic, assign)NSInteger currentIndex;//当前第几题
@property (nonatomic, assign)NSInteger randomIndex;//随机数
@property (nonatomic, strong)UIView *blackView;
@property (nonatomic, strong)UIImageView *activityImageView;
@property (nonatomic, strong)UIButton *closeButton;
@property (nonatomic, strong)UITapGestureRecognizer *tap;

@property (nonatomic, strong)UIImageView *endQuestionImage1;
@property (nonatomic, strong)UIImageView *endQuestionImage2;
@property (nonatomic, strong)UIImageView *endQuestionImage3;
@property (nonatomic, strong)UILabel *endQuestionNumber1;
@property (nonatomic, strong)UILabel *endQuestionNumber2;
@property (nonatomic, strong)UILabel *endQuestionNumber3;
@property (nonatomic, strong)UILabel *endQuestionTitle1;
@property (nonatomic, strong)UILabel *endQuestionTitle2;
@property (nonatomic, strong)UILabel *endQuestionTitle3;
@property (nonatomic, strong)UIImageView *endQuestionQuanImage;
@property (nonatomic, strong)UILabel *endQuestionContent;
@property (nonatomic, strong)UIButton *endQuestionBtn;//知道了

@property(nonatomic, assign)NSInteger rightNumber;
@property(nonatomic, assign)NSInteger wrongNumber;

@property(nonatomic, strong)NSMutableArray *randomArray;

@property (nonatomic, assign)BOOL isAnswer;//用户是否答过题
@property (nonatomic, copy)NSString *rate_plus;//答题中奖的利率

@end

@implementation ZhongQiuActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"闹中秋·猜灯谜";
    self.view.backgroundColor = [UIColor whiteColor];
    self.window = [[UIApplication sharedApplication].delegate window];
    _dataArray = [[NSMutableArray alloc]init];
    _buttonArray = [[NSMutableArray alloc]init];
    _currentIndex = -1;
    _rightNumber = 0;
    _wrongNumber = 0;
    
    [self gerUserAnswerRecordMethod];
}

#pragma mark - 获取用户是否已经答过题
- (void)gerUserAnswerRecordMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Redpacket/queCoupon" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSArray *dataArray = obj[@"data"];
                if (dataArray.count == 0) {
                    _isAnswer = NO;
                } else {
                    _isAnswer = YES;
                    _rate_plus = dataArray[0][@"returnrate_plus"];
                }
                
                [SVProgressHUD dismiss];
                
                [self layoutMethod];
                return ;
            } else {
                [SVProgressHUD dismiss];
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

#pragma mark - 界面布局
- (void)layoutMethod {
    //随机数从这里边产生
    NSMutableArray *startArray=[[NSMutableArray alloc] initWithObjects:@0,@1,@2,@3,@4,@5,@6,@7,@8,@9, nil];
    //随机数产生结果
    _randomArray =[[NSMutableArray alloc] initWithCapacity:0];
    //随机数个数
    NSInteger m=10;
    for (int i=0; i<m; i++) {
        int t=arc4random()%startArray.count;
        _randomArray[i]=startArray[t];
        startArray[t]=[startArray lastObject]; //为更好的乱序，故交换下位置
        [startArray removeLastObject];
    }
    
    
    UIImageView *backImageView = [[UIImageView alloc]init];
    [backImageView setUserInteractionEnabled:YES];
    backImageView.image = [UIImage imageNamed:@"zhongqiushouye"];
    [self.view addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    CGFloat bottomDistance=0;
    if ([[UIDeviceHardware platformString] isEqualToString:@"iPhone X"]) {
        bottomDistance = -RESIZE_UI(40);
    } else {
        bottomDistance = 0;
        //        bottomDistance = -RESIZE_UI(40);
    }
    
    zhongjiangResultBtn = [[UIButton alloc]init];
    [zhongjiangResultBtn addTarget:self action:@selector(watchZhongJiangResult) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:zhongjiangResultBtn];
    [zhongjiangResultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImageView.mas_centerX);
        make.top.equalTo(backImageView.mas_top).with.offset(RESIZE_UI(207)-bottomDistance);
        make.width.height.mas_offset(RESIZE_UI(70));
    }];
    
    activityContentBtn = [[UIButton alloc]init];
    [activityContentBtn addTarget:self action:@selector(watchActivityContent) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:activityContentBtn];
    [activityContentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(zhongjiangResultBtn.mas_centerY);
        make.left.equalTo(backImageView.mas_left).with.offset(RESIZE_UI(50));
        make.width.height.mas_offset(RESIZE_UI(70));
    }];
    
    activityRuleBtn = [[UIButton alloc]init];
    [activityRuleBtn addTarget:self action:@selector(watchActivityRule) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:activityRuleBtn];
    [activityRuleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(zhongjiangResultBtn.mas_centerY);
        make.right.equalTo(backImageView.mas_right).with.offset(-RESIZE_UI(60));
        make.height.width.mas_offset(RESIZE_UI(70));
    }];
    
    questionLabel = [[UILabel alloc]init];
    //    questionLabel.text = @"旺马财富平台的质押标的为________签发并承兑的电子商业承兑汇票或银行承兑汇票。";
    questionLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
    questionLabel.textColor = [UIColor whiteColor];
    questionLabel.numberOfLines = 2;
    [backImageView addSubview:questionLabel];
    [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backImageView.mas_bottom).with.offset(-RESIZE_UI(195)+bottomDistance);
        make.centerX.equalTo(backImageView.mas_centerX);
        make.width.mas_offset(RESIZE_UI(272));
    }];
    
    
    //选项A
    a_imageView = [[UIButton alloc]init];
    a_imageView.tag = 0;
    [a_imageView setBackgroundImage:[UIImage imageNamed:@"weidianji"] forState:UIControlStateNormal];
    [a_imageView addTarget:self action:@selector(selectAnswerMethod:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:a_imageView];
    [a_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backImageView.mas_bottom).with.offset(-RESIZE_UI(139)+bottomDistance);
        make.left.equalTo(backImageView.mas_left).with.offset(40);
        make.width.mas_offset(RESIZE_UI(142));
        make.height.mas_offset(RESIZE_UI(40));
    }];
    
    [_buttonArray addObject:a_imageView];
    
    UILabel *a_title = [[UILabel alloc]init];
    a_title.text = @"A";
    a_title.textColor = RGBA(212, 105, 82, 1.0);
    a_title.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [a_imageView addSubview:a_title];
    [a_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(a_imageView.mas_left).with.offset(RESIZE_UI(16));
        make.centerY.equalTo(a_imageView.mas_centerY);
    }];
    
    a_answerLabel = [[UILabel alloc]init];
    a_answerLabel.textColor = RGBA(89, 53, 40, 1.0);
    //    a_answerLabel.text = @"私企、民营企业、外企";
    a_answerLabel.textAlignment = NSTextAlignmentCenter;
    a_answerLabel.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
    [a_imageView addSubview:a_answerLabel];
    [a_answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(a_imageView.mas_left).with.offset(RESIZE_UI(38));
        make.right.equalTo(a_imageView.mas_right);
        make.centerY.equalTo(a_imageView.mas_centerY);
    }];
    
    //选项B
    b_imageView = [[UIButton alloc]init];
    b_imageView.tag = 1;
    [b_imageView setBackgroundImage:[UIImage imageNamed:@"weidianji"] forState:UIControlStateNormal];
    [b_imageView addTarget:self action:@selector(selectAnswerMethod:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:b_imageView];
    [b_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(a_imageView.mas_bottom);
        make.right.equalTo(backImageView.mas_right).with.offset(-RESIZE_UI(49));
        make.width.mas_equalTo(a_imageView.mas_width);
        make.height.mas_equalTo(a_imageView.mas_height);
    }];
    
    [_buttonArray addObject:b_imageView];
    
    UILabel *b_title = [[UILabel alloc]init];
    b_title.text = @"B";
    b_title.textColor = RGBA(212, 105, 82, 1.0);
    b_title.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [b_imageView addSubview:b_title];
    [b_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(b_imageView.mas_left).with.offset(RESIZE_UI(16));
        make.centerY.equalTo(b_imageView.mas_centerY);
    }];
    
    b_answerLabel = [[UILabel alloc]init];
    b_answerLabel.textColor = RGBA(89, 53, 40, 1.0);
    //    b_answerLabel.text = @"央企、国企、上市公司";
    b_answerLabel.textAlignment = NSTextAlignmentCenter;
    b_answerLabel.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
    [b_imageView addSubview:b_answerLabel];
    [b_answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(b_imageView.mas_left).with.offset(RESIZE_UI(38));
        make.right.equalTo(b_imageView.mas_right);
        make.centerY.equalTo(b_imageView.mas_centerY);
    }];
    
    //选项C
    c_imageView = [[UIButton alloc]init];
    c_imageView.tag = 2;
    [c_imageView setBackgroundImage:[UIImage imageNamed:@"weidianji"] forState:UIControlStateNormal];
    [c_imageView addTarget:self action:@selector(selectAnswerMethod:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:c_imageView];
    [c_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(a_imageView.mas_left);
        make.top.equalTo(a_imageView.mas_bottom).with.offset(RESIZE_UI(6));
        make.width.mas_equalTo(a_imageView.mas_width);
        make.height.mas_equalTo(a_imageView.mas_height);
    }];
    
    [_buttonArray addObject:c_imageView];
    
    c_title = [[UILabel alloc]init];
    c_title.text = @"C";
    c_title.textColor = RGBA(212, 105, 82, 1.0);
    c_title.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [c_imageView addSubview:c_title];
    [c_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(c_imageView.mas_left).with.offset(RESIZE_UI(16));
        make.centerY.equalTo(c_imageView.mas_centerY);
    }];
    
    c_answerLabel = [[UILabel alloc]init];
    c_answerLabel.textColor = RGBA(89, 53, 40, 1.0);
    //    c_answerLabel.text = @"个体户";
    c_answerLabel.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
    c_answerLabel.textAlignment = NSTextAlignmentCenter;
    [c_imageView addSubview:c_answerLabel];
    [c_answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(c_imageView.mas_left).with.offset(RESIZE_UI(38));
        make.right.equalTo(c_imageView.mas_right);
        make.centerY.equalTo(c_imageView.mas_centerY);
    }];
    
    //选项D
    d_imageView = [[UIButton alloc]init];
    d_imageView.tag = 3;
    [d_imageView setBackgroundImage:[UIImage imageNamed:@"weidianji"] forState:UIControlStateNormal];
    [d_imageView addTarget:self action:@selector(selectAnswerMethod:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:d_imageView];
    [d_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(c_imageView.mas_top);
        make.right.equalTo(b_imageView.mas_right);
        make.width.mas_equalTo(c_imageView.mas_width);
        make.height.mas_equalTo(c_imageView.mas_height);
    }];
    
    [_buttonArray addObject:d_imageView];
    
    d_title = [[UILabel alloc]init];
    d_title.text = @"D";
    d_title.textColor = RGBA(212, 105, 82, 1.0);
    d_title.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [d_imageView addSubview:d_title];
    [d_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(d_imageView.mas_left).with.offset(RESIZE_UI(16));
        make.centerY.equalTo(d_imageView.mas_centerY);
    }];
    
    d_answerLabel = [[UILabel alloc]init];
    d_answerLabel.textColor = RGBA(89, 53, 40, 1.0);
    //    d_answerLabel.text = @"企业法人";
    d_answerLabel.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
    d_answerLabel.textAlignment = NSTextAlignmentCenter;
    [d_imageView addSubview:d_answerLabel];
    [d_answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(d_imageView.mas_left).with.offset(RESIZE_UI(38));
        make.right.equalTo(d_imageView.mas_right);
        make.centerY.equalTo(d_imageView.mas_centerY);
    }];
    
    rightAnswer = [[UILabel alloc]init];
    //    rightAnswer.text = @"正确答案B";
    rightAnswer.textColor = RGBA(72, 30, 21, 1.0);
    rightAnswer.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
    [backImageView addSubview:rightAnswer];
    [rightAnswer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(c_imageView.mas_bottom).with.offset(RESIZE_UI(5));
        make.left.equalTo(backImageView.mas_left).with.offset(RESIZE_UI(82));
        make.height.mas_offset(RESIZE_UI(15));
    }];
    
    UIButton *nextButton = [[UIButton alloc]init];
    [nextButton setTitle:@"下一关" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextMethod) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImageView.mas_centerX);
        make.top.equalTo(rightAnswer.mas_bottom).with.offset(RESIZE_UI(0));
        make.width.mas_offset(RESIZE_UI(100));
        make.height.mas_offset(RESIZE_UI(30));
    }];
    
    //获取源数据
    [self getDataResourceMethod];
    //获取第一个对象
    [self nextMethod];
}

#pragma mark - 中奖结果介绍
- (void)watchZhongJiangResult {
    //zhongiangjieguo1%  zhongjiangjieguo1.5%  zhongjiangjieguo2%  zhongjiangjieguo5‰
    if (_isAnswer) {
        NSString *pic_name;
        if ([_rate_plus isEqualToString:@"0.005"]) {
            pic_name = @"zhongjiangjieguo5‰";
        } else if ([_rate_plus isEqualToString:@"0.01"]) {
            pic_name = @"zhongiangjieguo1%";
        } else if ([_rate_plus isEqualToString:@"0.015"]) {
            pic_name = @"zhongjiangjieguo1.5%";
        } else{
            pic_name = @"zhongjiangjieguo2%";
        }
        [self activityLayout:pic_name];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"您还未参与该活动" message:@"" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - 活动内容
- (void)watchActivityContent {
    //huodongneirong
    [self activityLayout:@"huodongneirong"];
}

#pragma mark - 活动规则
- (void)watchActivityRule {
    //huoodngguize
    [self activityLayout:@"huoodngguize"];
}

- (void)activityLayout:(NSString *)imageName {
    _blackView = [[UIView alloc]init];
    _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:_blackView];
    [_blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeActivityMethod)];
    [_blackView addGestureRecognizer:_tap];
    
    CGFloat height=0;
    if ([imageName isEqualToString:@"huoodngguize"]) {
        height = RESIZE_UI(294);
    } else {
        height = RESIZE_UI(270);
    }
    _activityImageView = [[UIImageView alloc]init];
    _activityImageView.image = [UIImage imageNamed:imageName];
    [_blackView addSubview:_activityImageView];
    [_activityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.window.mas_centerY);
        make.centerX.equalTo(self.window.mas_centerX);
        make.width.mas_offset(RESIZE_UI(285));
        make.height.mas_offset(height);
    }];
    
    _closeButton = [[UIButton alloc]init];
    [_closeButton setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeActivityMethod) forControlEvents:UIControlEventTouchUpInside];
    [_blackView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_activityImageView.mas_bottom).with.offset(RESIZE_UI(10));
        make.centerX.equalTo(_blackView.mas_centerX);
        make.width.height.mas_offset(RESIZE_UI(40));
    }];
    
}

#pragma mark - 关闭
- (void)closeActivityMethod {
//    [_closeButton removeFromSuperview];
//    _closeButton = nil;
//    [_activityImageView removeFromSuperview];
//    _activityImageView = nil;
//    [_blackView removeGestureRecognizer:_tap];
//    _tap = nil;
    [_blackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_blackView removeFromSuperview];
    _blackView = nil;
}

#pragma mark - 选择答案
- (void)selectAnswerMethod:(UIButton *)btn {
    if (_isAnswer) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"您已参加该活动" message:@"" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        [btn setBackgroundImage:[UIImage imageNamed:@"dianji"] forState:UIControlStateNormal];
        for (int i=0; i<_buttonArray.count; i++) {
            UIButton *buttonImage = _buttonArray[i];
            buttonImage.userInteractionEnabled = NO;
        }
        rightAnswer.text = [NSString stringWithFormat:@"正确答案%@",_currentModel.right_answer];
        switch (btn.tag) {
            case 0:
                _currentModel.select_answer = @"A";
                break;
            case 1:
                _currentModel.select_answer = @"B";
                break;
            case 2:
                _currentModel.select_answer = @"C";
                break;
            case 3:
                _currentModel.select_answer = @"D";
                break;
                
            default:
                break;
        }
        if ([_currentModel.select_answer isEqualToString:_currentModel.right_answer]) {
            _currentModel.isRight = YES;
        } else {
            _currentModel.isRight = NO;
        }
    }
}

#pragma mark - 下一关
- (void)nextMethod {
    if (_currentIndex<9) {
        if (![_currentModel.select_answer isEqualToString:@""]) {
            _currentIndex++;
            rightAnswer.text = @"";
            //所有按钮图片恢复
            for (int i=0; i<_buttonArray.count; i++) {
                UIButton *buttonImage = _buttonArray[i];
                [buttonImage setBackgroundImage:[UIImage imageNamed:@"weidianji"] forState:UIControlStateNormal];
                buttonImage.userInteractionEnabled = YES;
            }
            /**获取0-10随机数**/
//            NSString *numberString = _randomArray[_currentIndex];
//            _randomIndex = [numberString integerValue];
            _randomIndex = _currentIndex;
            /**获取0-10随机数**/
            _currentModel = _dataArray[_randomIndex];
            [self converValueMethod:_currentModel];
        } else {
            if (_isAnswer) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"您已参加该活动" message:@"" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请先做出选择哦" message:@"" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    } else {
        //答完所有题
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"您已全部答完啦" message:@"" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//        [alertView show];
        if (_isAnswer) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"您已参加该活动" message:@"" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
        } else {
            NSInteger rightRow=0;
            NSInteger wrongRow=0;
            for (int i=0; i<_dataArray.count; i++) {
                ZhongQiuQuestionModel *model = _dataArray[i];
                if (model.isRight) {
                    rightRow++;
                } else {
                    wrongRow++;
                }
            }
            _rightNumber = rightRow;
            _wrongNumber = wrongRow;
            //答完题调用接口
            [self endanswerMethod];
        }
    }
}

#pragma mark - 答完题调用接口
- (void)endanswerMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Redpacket/gainCoupon" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid,@"correct":@(_rightNumber),@"total":@"10"} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSDictionary *dataDic = obj[@"data"];
                
                [self endQuestionLayout:dataDic[@"returnrate_plus"]];
                _isAnswer = YES;
                _rate_plus = dataDic[@"returnrate_plus"];
                [SVProgressHUD dismiss];
                
                return ;
            } else {
                [SVProgressHUD dismiss];
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

- (void)converValueMethod:(ZhongQiuQuestionModel *)model {
    questionLabel.text = model.questuonContent;
    a_answerLabel.text = model.answer_a;
    b_answerLabel.text = model.answer_b;
    if ([model.answer_c isEqualToString:@""]) {
        c_answerLabel.hidden = YES;
        c_imageView.hidden = YES;
        c_title.hidden = YES;
    } else {
        c_answerLabel.hidden = NO;
        c_imageView.hidden = NO;
        c_title.hidden = NO;
        c_answerLabel.text = model.answer_c;
    }
    if ([model.answer_d isEqualToString:@""]) {
        d_answerLabel.hidden = YES;
        d_imageView.hidden = YES;
        d_title.hidden = YES;
    } else {
        d_answerLabel.hidden = NO;
        d_imageView.hidden = NO;
        d_title.hidden = NO;
        d_answerLabel.text = model.answer_d;
    }
}

#pragma mark - 答题结束UI
- (void)endQuestionLayout:(NSString *)returnrate_plus {
    _blackView = [[UIView alloc]init];
    _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:_blackView];
    [_blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeActivityMethod)];
    [_blackView addGestureRecognizer:_tap];
    
    _activityImageView = [[UIImageView alloc]init];
    _activityImageView.image = [UIImage imageNamed:@"datijiesu"];
    [_blackView addSubview:_activityImageView];
    [_activityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.window.mas_centerY);
        make.centerX.equalTo(self.window.mas_centerX);
        make.width.mas_offset(RESIZE_UI(291));
        make.height.mas_offset(RESIZE_UI(306));
    }];
    
    _endQuestionImage1 = [[UIImageView alloc]init];
    _endQuestionImage1.image = [UIImage imageNamed:@"datushu"];
    [_activityImageView addSubview:_endQuestionImage1];
    [_endQuestionImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_activityImageView.mas_centerX);
        make.top.equalTo(_activityImageView.mas_top).with.offset(RESIZE_UI(67));
        make.width.height.mas_offset(RESIZE_UI(50));
    }];
    
    _endQuestionTitle1 = [[UILabel alloc]init];
    _endQuestionTitle1.text = @"答对";
    _endQuestionTitle1.textColor = [UIColor whiteColor];
    _endQuestionTitle1.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
    [_activityImageView addSubview:_endQuestionTitle1];
    [_endQuestionTitle1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_endQuestionImage1.mas_bottom);
        make.centerX.equalTo(_endQuestionImage1.mas_centerX);
    }];
    
    _endQuestionNumber1 = [[UILabel alloc]init];
    _endQuestionNumber1.text = [NSString stringWithFormat:@"%ld",(long)_rightNumber];
    _endQuestionNumber1.textColor = RGBA(212, 105, 82, 1.0);
    _endQuestionNumber1.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [_endQuestionImage1 addSubview:_endQuestionNumber1];
    [_endQuestionNumber1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_endQuestionImage1.mas_centerX);
        make.centerY.equalTo(_endQuestionImage1.mas_centerY).with.offset(RESIZE_UI(2));
    }];
    
    _endQuestionImage2 = [[UIImageView alloc]init];
    _endQuestionImage2.image = [UIImage imageNamed:@"datushu"];
    [_activityImageView addSubview:_endQuestionImage2];
    [_endQuestionImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_activityImageView.mas_left).with.offset(RESIZE_UI(53));
        make.centerY.equalTo(_endQuestionImage1.mas_centerY);
        make.width.height.mas_offset(RESIZE_UI(50));
    }];
    
    _endQuestionTitle2 = [[UILabel alloc]init];
    _endQuestionTitle2.text = @"答题";
    _endQuestionTitle2.textColor = [UIColor whiteColor];
    _endQuestionTitle2.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
    [_activityImageView addSubview:_endQuestionTitle2];
    [_endQuestionTitle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_endQuestionImage2.mas_bottom);
        make.centerX.equalTo(_endQuestionImage2.mas_centerX);
    }];
    
    _endQuestionNumber2 = [[UILabel alloc]init];
    _endQuestionNumber2.text = [NSString stringWithFormat:@"%ld",(long)10];
    _endQuestionNumber2.textColor = RGBA(212, 105, 82, 1.0);
    _endQuestionNumber2.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [_endQuestionImage2 addSubview:_endQuestionNumber2];
    [_endQuestionNumber2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_endQuestionImage2.mas_centerX);
        make.centerY.equalTo(_endQuestionImage2.mas_centerY).with.offset(RESIZE_UI(2));
    }];
    
    _endQuestionImage3 = [[UIImageView alloc]init];
    _endQuestionImage3.image = [UIImage imageNamed:@"datushu"];
    [_activityImageView addSubview:_endQuestionImage3];
    [_endQuestionImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_endQuestionImage1.mas_centerY);
        make.right.equalTo(_activityImageView.mas_right).with.offset(-RESIZE_UI(53));
        make.width.height.mas_offset(RESIZE_UI(50));
    }];
    
    _endQuestionTitle3 = [[UILabel alloc]init];
    _endQuestionTitle3.text = @"答错";
    _endQuestionTitle3.textColor = [UIColor whiteColor];
    _endQuestionTitle3.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
    [_activityImageView addSubview:_endQuestionTitle3];
    [_endQuestionTitle3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_endQuestionImage3.mas_bottom);
        make.centerX.equalTo(_endQuestionImage3.mas_centerX);
    }];
    
    _endQuestionNumber3 = [[UILabel alloc]init];
    _endQuestionNumber3.text = [NSString stringWithFormat:@"%ld",(long)_wrongNumber];
    _endQuestionNumber3.textColor = RGBA(212, 105, 82, 1.0);
    _endQuestionNumber3.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [_endQuestionImage3 addSubview:_endQuestionNumber3];
    [_endQuestionNumber3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_endQuestionImage3.mas_centerX);
        make.centerY.equalTo(_endQuestionImage3.mas_centerY).with.offset(RESIZE_UI(2));
    }];
    
    NSString *pic_name;
    NSString *quan_content;
    if ([returnrate_plus isEqualToString:@"0.005"]) {
        pic_name = @"jiacijuan5‰";
//        quan_content = @"5‰";
    } else if ([returnrate_plus isEqualToString:@"0.01"]) {
        pic_name = @"jiaxijuan1%";
//        quan_content = @"1%";
    } else if ([returnrate_plus isEqualToString:@"0.015"]) {
        pic_name = @"jiaxijuan1.5%";
//        quan_content = @"1.5%";
    } else {
        pic_name = @"jiaxijuan2%";
//        quan_content = @"2%";
    }
    CGFloat returnrate_plusFlo = [returnrate_plus floatValue];
    //转化成百分比
    CGFloat baifenFloat = returnrate_plusFlo*100;
    if (baifenFloat<1) {
        CGFloat qianfenFloat = returnrate_plusFlo*1000;
        quan_content = [NSString stringWithFormat:@"%g%‰",qianfenFloat];
    } else {
        quan_content = [NSString stringWithFormat:@"%g%%",baifenFloat];
    }
    _endQuestionQuanImage = [[UIImageView alloc]init];
    _endQuestionQuanImage.image = [UIImage imageNamed:pic_name];
    [_activityImageView addSubview:_endQuestionQuanImage];
    [_endQuestionQuanImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_endQuestionTitle2.mas_bottom).with.offset(RESIZE_UI(15));
        make.centerX.equalTo(_activityImageView.mas_centerX);
        make.width.mas_offset(RESIZE_UI(219));
        make.height.mas_offset(RESIZE_UI(86));
    }];
    
    _endQuestionContent = [[UILabel alloc]init];
    _endQuestionContent.text = [NSString stringWithFormat:@"恭喜你获得了%@的加息劵，财富在像你招手,快去出借使用吧!",quan_content];
    _endQuestionContent.textAlignment = NSTextAlignmentCenter;
    _endQuestionContent.numberOfLines = 2;
    _endQuestionContent.textColor = [UIColor whiteColor];
    _endQuestionContent.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
    [_activityImageView addSubview:_endQuestionContent];
    [_endQuestionContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_endQuestionQuanImage.mas_top).with.offset(RESIZE_UI(77));
        make.centerX.equalTo(_activityImageView.mas_centerX);
        make.width.mas_offset(RESIZE_UI(199));
    }];
    
    _endQuestionBtn = [[UIButton alloc]init];
    [_endQuestionBtn setBackgroundImage:[UIImage imageNamed:@"zhidaole"] forState:UIControlStateNormal];
    [_endQuestionBtn addTarget:self action:@selector(closeActivityMethod) forControlEvents:UIControlEventTouchUpInside];
    [_activityImageView addSubview:_endQuestionBtn];
    [_endQuestionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_activityImageView.mas_bottom).with.offset(-RESIZE_UI(12));
        make.centerX.equalTo(_activityImageView.mas_centerX);
        make.width.mas_offset(RESIZE_UI(117));
        make.height.mas_offset(RESIZE_UI(49));
    }];
    
    
    
}

//- (void)closeEndActivityMethod {
//
//    [_activityImageView removeFromSuperview];
//    _activityImageView = nil;
//    [_blackView removeGestureRecognizer:_tap];
//    _tap = nil;
//    [_blackView removeFromSuperview];
//    _blackView = nil;
//}

- (void)getDataResourceMethod {
    ZhongQiuQuestionModel *model1 = [[ZhongQiuQuestionModel alloc]init];
    model1.number = 0;
    model1.questuonContent = @"嫦娥下凡(打一花名) ";
    model1.answer_a = @"月季";
    model1.answer_b = @"桂花";
    model1.answer_c = @"玫瑰";
    model1.answer_d = @"牡丹";
    model1.right_answer = @"A";
    model1.select_answer = @"";
    model1.isRight = NO;
    [_dataArray addObject:model1];
    
    ZhongQiuQuestionModel *model2 = [[ZhongQiuQuestionModel alloc]init];
    model2.number = 1;
    model2.questuonContent = @"旺马财富获得的AAA级企业信用认证是企业最高的信用评级。这句话对还是错";
    model2.answer_a = @"对";
    model2.answer_b = @"错";
    model2.answer_c = @"";
    model2.answer_d = @"";
    model2.right_answer = @"A";
    model2.select_answer = @"";
    model2.isRight = NO;
    [_dataArray addObject:model2];
    
    ZhongQiuQuestionModel *model3 = [[ZhongQiuQuestionModel alloc]init];
    model3.number = 2;
    model3.questuonContent = @"明天日全食(打一字)";
    model3.answer_a = @"暗";
    model3.answer_b = @"光";
    model3.answer_c = @"月";
    model3.answer_d = @"阳";
    model3.right_answer = @"C";
    model3.select_answer = @"";
    model3.isRight = NO;
    [_dataArray addObject:model3];
    
    ZhongQiuQuestionModel *model4 = [[ZhongQiuQuestionModel alloc]init];
    model4.number = 3;
    model4.questuonContent = @"旺马财富平台的质押标的为________签发并承兑的电子商业承兑汇票或银行承兑汇票";
    model4.answer_a = @"私企、民营企业、外企";
    model4.answer_b = @"央企、国企、上市公司";
    model4.answer_c = @"个体户";
    model4.answer_d = @"企业法人";
    model4.right_answer = @"B";
    model4.select_answer = @"";
    model4.isRight = NO;
    [_dataArray addObject:model4];
    
    ZhongQiuQuestionModel *model5 = [[ZhongQiuQuestionModel alloc]init];
    model5.number = 4;
    model5.questuonContent = @"东征西讨（打一字）";
    model5.answer_a = @"行";
    model5.answer_b = @"仁";
    model5.answer_c = @"付";
    model5.answer_d = @"证";
    model5.right_answer = @"D";
    model5.select_answer = @"";
    model5.isRight = NO;
    [_dataArray addObject:model5];
    
    ZhongQiuQuestionModel *model6 = [[ZhongQiuQuestionModel alloc]init];
    model6.number = 5;
    model6.questuonContent = @"旺马财富平台的产品的历史年化收益率为？";
    model6.answer_a = @"7%~11%";
    model6.answer_b = @"10%~15%";
    model6.answer_c = @"12%~20%";
    model6.answer_d = @"20%~25%";
    model6.right_answer = @"A";
    model6.select_answer = @"";
    model6.isRight = NO;
    [_dataArray addObject:model6];
    
    ZhongQiuQuestionModel *model7 = [[ZhongQiuQuestionModel alloc]init];
    model7.number = 6;
    model7.questuonContent = @"举头望明月(打一中药名) ";
    model7.answer_a = @"连翘";
    model7.answer_b = @"当归";
    model7.answer_c = @"陈皮";
    model7.answer_d = @"黄连";
    model7.right_answer = @"B";
    model7.select_answer = @"";
    model7.isRight = NO;
    [_dataArray addObject:model7];
    
    ZhongQiuQuestionModel *model8 = [[ZhongQiuQuestionModel alloc]init];
    model8.number = 7;
    model8.questuonContent = @"旺马财富产品类型中，哪个是针对新用户的产品？";
    model8.answer_a = @"旺 利宝";
    model8.answer_b = @"旺 智选";
    model8.answer_c = @"旺 稳盈";
    model8.answer_d = @"旺 稳益";
    model8.right_answer = @"B";
    model8.select_answer = @"";
    model8.isRight = NO;
    [_dataArray addObject:model8];
    
    ZhongQiuQuestionModel *model9 = [[ZhongQiuQuestionModel alloc]init];
    model9.number = 8;
    model9.questuonContent = @"明月一钩云脚下，残花两瓣马蹄前（打一字）";
    model9.answer_a = @"熊";
    model9.answer_b = @"赢";
    model9.answer_c = @"酝";
    model9.answer_d = @"照";
    model9.right_answer = @"A";
    model9.select_answer = @"";
    model9.isRight = NO;
    [_dataArray addObject:model9];
    
    ZhongQiuQuestionModel *model10 = [[ZhongQiuQuestionModel alloc]init];
    model10.number = 9;
    model10.questuonContent = @"旺马财富APP中推荐好友参与即可获得奖励的是什么计划？";
    model10.answer_a = @"好友推荐计划";
    model10.answer_b = @"大富翁计划";
    model10.answer_c = @"呼朋唤友计划";
    model10.answer_d = @"共赢计划";
    model10.right_answer = @"B";
    model10.select_answer = @"";
    model10.isRight = NO;
    [_dataArray addObject:model10];
    
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
