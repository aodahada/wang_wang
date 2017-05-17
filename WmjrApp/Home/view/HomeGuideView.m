//
//  HomeGuideView.m
//  WmjrApp
//
//  Created by horry on 2016/11/15.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "HomeGuideView.h"

@interface HomeGuideView ()

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) CGRect viewFrame;
@property (nonatomic, strong) UIButton *buttonForLearn;
@property (nonatomic, strong) UIImageView * imageViewForLearn;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger newsListCount;
@end

@implementation HomeGuideView

- (instancetype)initWithFrame:(CGRect)frame andNewsListCount:(NSInteger)newsListCount{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewFrame = frame;
        self.newsListCount = newsListCount;
        self.count = 1;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureTapClick:)];
//        [self addGestureRecognizer:tap];
        //create path 重点来了（**这里需要添加第一个路径）
        _path = [UIBezierPath bezierPathWithRect:frame];
        // 这里添加第二个路径 （这个是圆）
        //    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width - 30, 42) radius:30 startAngle:0 endAngle:2*M_PI clockwise:NO]];
        // 这里添加第二个路径 （这个是矩形）
        [_path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(SCREEN_WIDTH/2-RESIZE_UI(208)/2-RESIZE_UI(10), RESIZE_UI(110), RESIZE_UI(228), RESIZE_UI(56)) cornerRadius:5] bezierPathByReversingPath]];
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.path = _path.CGPath;
        //shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        [self.layer setMask:self.shapeLayer];
        
        
        _imageViewForLearn = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2,RESIZE_UI(110)+RESIZE_UI(56),RESIZE_UI(85), RESIZE_UI(184))];
        _imageViewForLearn.image = [UIImage imageNamed:@"image_ptjj"];
        [self addSubview:_imageViewForLearn];
    
        
        _buttonForLearn = [[UIButton alloc]init];
        _buttonForLearn.backgroundColor = [UIColor clearColor];
        _buttonForLearn.layer.borderColor = [UIColor whiteColor].CGColor;
        _buttonForLearn.layer.borderWidth = 1.0f;
        [_buttonForLearn setTitle:@"朕知道了" forState:UIControlStateNormal];
        [_buttonForLearn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buttonForLearn.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        [_buttonForLearn addTarget:self action:@selector(sureTapClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_buttonForLearn];
        [_buttonForLearn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(RESIZE_UI(110));
            make.height.mas_offset(RESIZE_UI(35));
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(368));
        }];
        
    }
    return self;
}

/**
 *   新手指引确定
 */
- (void)sureTapClick
{
//    UIView * view = tap.view;
//    [view removeFromSuperview];
//    [view removeAllSubviews];
//    [view removeGestureRecognizer:tap];
    
    if (self.shapeLayer) {
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
        _path = nil;
    }
    _path = [UIBezierPath bezierPathWithRect:self.viewFrame];
    self.count++;
    switch (self.count) {
        case 2:{
            [_path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(SCREEN_WIDTH-3-33, 26, 33, 33) cornerRadius:5] bezierPathByReversingPath]];
            self.shapeLayer = [CAShapeLayer layer];
            self.shapeLayer.path = _path.CGPath;
            //shapeLayer.strokeColor = [UIColor blueColor].CGColor;
            [self.layer setMask:self.shapeLayer];
            
            _imageViewForLearn.frame = CGRectMake(SCREEN_WIDTH-3-33-RESIZE_UI(99), 26+33, RESIZE_UI(101), RESIZE_UI(85));
            _imageViewForLearn.image = [UIImage imageNamed:@"image_xx"];
            
            [_buttonForLearn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(220));
            }];
        }
            break;
        case 3:{
            [_path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, RESIZE_UI(202+12+109+14), RESIZE_UI(102), RESIZE_UI(32)) cornerRadius:5] bezierPathByReversingPath]];
            self.shapeLayer = [CAShapeLayer layer];
            self.shapeLayer.path = _path.CGPath;
            //shapeLayer.strokeColor = [UIColor blueColor].CGColor;
            [self.layer setMask:self.shapeLayer];
            
            _imageViewForLearn.frame = CGRectMake(RESIZE_UI(60),RESIZE_UI(202+12+109+14)-RESIZE_UI(111), RESIZE_UI(229), RESIZE_UI(111));
            _imageViewForLearn.image = [UIImage imageNamed:@"image_wmxrg"];
            
            [_buttonForLearn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(346));
            }];
        }
            break;
        case 4:{
            [_path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, RESIZE_UI(202+12+109+54+109+14), RESIZE_UI(82), RESIZE_UI(32)) cornerRadius:5] bezierPathByReversingPath]];
            self.shapeLayer = [CAShapeLayer layer];
            self.shapeLayer.path = _path.CGPath;
            //shapeLayer.strokeColor = [UIColor blueColor].CGColor;
            [self.layer setMask:self.shapeLayer];
            
            _imageViewForLearn.frame = CGRectMake(RESIZE_UI(19),RESIZE_UI(202+12+109+54+109+14)-RESIZE_UI(101), RESIZE_UI(121), RESIZE_UI(101));
            _imageViewForLearn.image = [UIImage imageNamed:@"image_wmyx"];
            
            [_buttonForLearn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(306));
            }];
        }
            break;
        case 5:{
            if (self.forthLearnMethod) {
                self.forthLearnMethod();
            }
            [_path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, SCREEN_HEIGHT-RESIZE_UI(117)*self.newsListCount-RESIZE_UI(36)-49, RESIZE_UI(82), RESIZE_UI(32)) cornerRadius:5] bezierPathByReversingPath]];
            self.shapeLayer = [CAShapeLayer layer];
            self.shapeLayer.path = _path.CGPath;
            //shapeLayer.strokeColor = [UIColor blueColor].CGColor;
            [self.layer setMask:self.shapeLayer];
            
            _imageViewForLearn.frame = CGRectMake(RESIZE_UI(15), SCREEN_HEIGHT-RESIZE_UI(117)*self.newsListCount-RESIZE_UI(36)-49-RESIZE_UI(98), RESIZE_UI(111), RESIZE_UI(98));
            _imageViewForLearn.image = [UIImage imageNamed:@"image_hytt"];
            
//            [_buttonForLearn mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(self.mas_centerX);
//                make.centerY.equalTo(self.mas_centerY);
//            }];
        }
            break;
        case 6:{
            [self removeFromSuperview];
            if (self.destroySelfMethod) {
                self.destroySelfMethod();
            }
        }
            break;
            
        default:
            break;
    }
    
    
}

@end
