//
//  AvatorChangeView.h
//  wangmajinrong
//
//  Created by Baimifan on 15/7/13.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^callBtnEvent)(UIButton *sender);

@interface AvatorChangeView : UIView <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIButton *takePicture;
@property (nonatomic, strong) UIButton *selectAlbum;

@property (nonatomic, copy) __block callBtnEvent block;
- (void)callBtnEventBlock:(callBtnEvent)block;

@end
