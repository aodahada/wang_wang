//
//  ProgressView.m
//  利得行
//
//  Created by huorui on 15/12/8.
//  Copyright © 2015年 杭州稳瞻信息科技有限公司. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()<CAAnimationDelegate>

@property (nonatomic, strong) CAShapeLayer *arcLayer;

@property (nonatomic, strong) NSTimer *progressTimer;

@property (nonatomic, assign) float currentPercent;

@end

@implementation ProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _percent = 0;
        _width = 0;
        _currentPercent = 0;
    }
    
    return self;
}

- (void)setPercent:(float)percent{
    _percent = percent;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [self addArcBackColor];
    [self drawArc];
    [self addCenterBack];
    [self addCenterLabel];
}

- (void)addArcBackColor{
    CGColorRef color = (_arcBackColor == nil) ? [UIColor lightGrayColor].CGColor : _arcBackColor.CGColor;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGSize viewSize = self.bounds.size;
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    
    // Draw the slices.
    CGFloat radius = viewSize.width / 2;
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    CGContextAddArc(contextRef, center.x, center.y, radius,0-M_PI_2,2*M_PI-M_PI_2, 0);
    CGContextSetFillColorWithColor(contextRef, color);
    CGContextFillPath(contextRef);
}

- (void)drawArc{
//    if (_percent == 0 || _percent > 1) {
//        return;
//    }
//    
//    if (_percent == 1) {
//        CGColorRef color = (_arcFinishColor == nil) ? [UIColor greenColor].CGColor : _arcFinishColor.CGColor;
//        
//        CGContextRef contextRef = UIGraphicsGetCurrentContext();
//        CGSize viewSize = self.bounds.size;
//        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
//        // Draw the slices.
//        CGFloat radius = viewSize.width / 2;
//        CGContextBeginPath(contextRef);
//        CGContextMoveToPoint(contextRef, center.x, center.y);
//        CGContextAddArc(contextRef, center.x, center.y, radius,0,2*M_PI, 0);
//        CGContextSetFillColorWithColor(contextRef, color);
//        CGContextFillPath(contextRef);
//    }else{
//        
//        float endAngle = 2*M_PI*_percent;
//        
//        CGColorRef color = (_arcUnfinishColor == nil) ? [UIColor blueColor].CGColor : _arcUnfinishColor.CGColor;
//        CGContextRef contextRef = UIGraphicsGetCurrentContext();
//        CGSize viewSize = self.bounds.size;
//        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
//        // Draw the slices.
//        CGFloat radius = viewSize.width / 2;
//        CGContextBeginPath(contextRef);
//        CGContextMoveToPoint(contextRef, center.x, center.y);
//        CGContextAddArc(contextRef, center.x, center.y, radius,-M_PI_2,-M_PI_2, 0);
//        [UIView animateWithDuration:2.0 animations:^{
//            CGContextAddArc(contextRef, center.x, center.y, radius,-M_PI_2,endAngle-M_PI_2, 0);
//        }];
//        CGContextSetFillColorWithColor(contextRef, color);
//        CGContextFillPath(contextRef);
//    }
    
    CGSize viewSize = self.bounds.size;
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    CGFloat radius = viewSize.width / 2;
    float endAngle = 2*M_PI*_percent;
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(center.x,center.y) radius:radius startAngle:-M_PI_2 endAngle:endAngle-M_PI_2 clockwise:YES];
    _arcLayer=[CAShapeLayer layer];
    _arcLayer.path=path.CGPath;//46,169,230
    _arcLayer.fillColor = [UIColor clearColor].CGColor;
//    _arcLayer.strokeColor=_arcUnfinishColor.CGColor;
    _arcLayer.lineWidth=RESIZE_UI(5);
    if (_percent == 1) {
        _arcLayer.strokeColor=RGBA(237, 237, 237, 1.0).CGColor;
    } else {
        _arcLayer.strokeColor=_arcUnfinishColor.CGColor;
    }
    _arcLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.layer addSublayer:_arcLayer];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self drawLineAnimation:_arcLayer];
        });
    if (_percent > 1) {
        NSLog(@"传入数值范围为 0-1");
        _percent = 1;
    }else if (_percent < 0){
        NSLog(@"传入数值范围为 0-1");
        _percent = 0;
        return;
    }
    if (_percent > 0) {
        NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(newThread) object:nil];
        [thread start];
    }
    
}

-(void)newThread
{
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timeLabel) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];
}
//NSTimer不会精准调用
-(void)timeLabel
{
    _currentPercent += 0.01;
//    label.text = [NSString stringWithFormat:@"%.0f%%",_currentPercent*100];
    if (_currentPercent >= _percent) {
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
  }
//定义动画过程
-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=_percent;//动画时间
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

- (void)drawRoundView:(CGPoint)centerPoint withStartAngle:(CGFloat)startAngle withEndAngle:(CGFloat)endAngle withRadius:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:centerPoint radius:radius startAngle:startAngle endAngle:endAngle  clockwise:YES];
    _arcLayer = [CAShapeLayer layer];
    _arcLayer.path = path.CGPath;
    //arcLayer.strokeColor可设置画笔颜色
    _arcLayer.lineWidth = 4;
    _arcLayer.frame = self.bounds;
    _arcLayer.fillColor = _arcUnfinishColor.CGColor;
    [self.layer addSublayer:_arcLayer];
    
    //动画显示圆则调用
    [self drawLineAnimation:_arcLayer];
}

-(void)addCenterBack{
    float width = (_width == 0) ? 5 : _width;
    
    CGColorRef color = (_centerColor == nil) ? [UIColor whiteColor].CGColor : _centerColor.CGColor;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGSize viewSize = self.bounds.size;
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    // Draw the slices.
    CGFloat radius = viewSize.width / 2 - width;
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    CGContextAddArc(contextRef, center.x, center.y, radius,0,2*M_PI, 0);
    CGContextSetFillColorWithColor(contextRef, color);
    CGContextFillPath(contextRef);
}

- (void)addCenterLabel{
    NSString *percent = @"";
    
    float fontSize = RESIZE_UI(12);
    UIColor *arcColor = [UIColor blueColor];
    if (_percent == 1) {
        percent = @"100%";
        fontSize = RESIZE_UI(11);
        arcColor = (_arcFinishColor == nil) ? [UIColor greenColor] : RGBA(67, 68, 67, 1.0);
        
    }else if(_percent < 1 && _percent >= 0){
        
        fontSize = RESIZE_UI(12);
        arcColor = (_arcUnfinishColor == nil) ? [UIColor blueColor] : RGBA(67, 68, 67, 1.0);
        percent = [NSString stringWithFormat:@"%.2f",_percent*100];
        percent = [percent substringToIndex:[percent length]-3];
        percent = [NSString stringWithFormat:@"%@%%",percent];
    }
    
    CGSize viewSize = self.bounds.size;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:fontSize],NSFontAttributeName,arcColor,NSForegroundColorAttributeName,[UIColor clearColor],NSBackgroundColorAttributeName,paragraph,NSParagraphStyleAttributeName,nil];
    
    [percent drawInRect:CGRectMake(5, (viewSize.height-fontSize)/2, viewSize.width-10, fontSize)withAttributes:attributes];
}


@end
