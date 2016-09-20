//
//  AboutUsViewController.m
//  wangmajinrong
//
//  Created by 1 & 0 on 15/6/25.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tabBarController.tabBar.hidden = YES;
    self.title = @"关于我们";
    self.view.backgroundColor = VIEWBACKCOLOR;
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineHeightMultiple =1.5;
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attribute=@{
                              NSParagraphStyleAttributeName:paragraphStyle,
                              NSForegroundColorAttributeName:TITLE_COLOR,
                              NSFontAttributeName:[UIFont systemFontOfSize:15],
                              NSWritingDirectionAttributeName:@[@(NSWritingDirectionLeftToRight)],
                              };
    UILabel *label=[[UILabel alloc]init];
    label.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, 280);
    label.numberOfLines=0;
    label.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@", @"公司名称:", @"      旺马财富信息服务(上海)有限公司", @"公司地址:", @"      上海市 闸北区广中西路555号608", @"客服电话: 4006001169", @"客服QQ/微信: 2128765741", @"客服邮箱: wangma555hao@163.com", @"邮编: 200070"];
    label.attributedText = [[NSAttributedString alloc] initWithString:label.text attributes:attribute];
    [self.view addSubview:label];
    
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
