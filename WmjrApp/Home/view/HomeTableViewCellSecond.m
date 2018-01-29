//
//  HomeTableViewCellSecond.m
//  WmjrApp
//
//  Created by horry on 2016/10/31.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "HomeTableViewCellSecond.h"
#import "SDCycleScrollView.h"
#import "ImgHomeModel.h"

@interface HomeTableViewCellSecond ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrayForImageModel;

@end

@implementation HomeTableViewCellSecond

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithImageArray:(NSMutableArray *)imageArray {
    self = [super init];
    if (self) {
        _arrayForImageModel = imageArray;
        NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
        for (int i=0; i<imageArray.count; i++) {
            ImgHomeModel *imageModel = imageArray[i];
            [imagesURLStrings addObject:imageModel.picurl];
        }
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RESIZE_UI(229)) imageURLStringsGroup:nil]; // 模拟网络延时情景
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView.delegate = self;
        if (imageArray.count == 1) {
            cycleScrollView.autoScroll = NO;
        } else {
            cycleScrollView.autoScroll = YES;
        }
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
        //             --- 模拟加载延迟
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            cycleScrollView.imageURLStringsGroup = imagesURLStrings;
        });
        [self addSubview:cycleScrollView];
    }
    return self;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    ImgHomeModel *imgModel = _arrayForImageModel[index];
    if (self.cycleImage) {
        self.cycleImage(imgModel);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
