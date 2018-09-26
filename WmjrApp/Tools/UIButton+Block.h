//
//  UIButton+Block.h
//  Meitu
//
//  Created by 石少庸 on 16/1/5.
//  Copyright © 2016年 M2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Block)

/**
 *  @brief  替换系统的target-action 机制为block回调机制，
 *          这样方便数据的存取，不需要在方法外做额外的操作，直接写在button申明的地方
 *
 *  @param clickCallBack 回调block
 */
- (void)clickActionBlock:(void(^)(UIButton *button))clickCallBack;

@end
