//
//  ShowBigImageView.h
//  ShowBigImage
//
//  Created by baimifan on 15/8/14.
//  Copyright (c) 2015年 lyl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowBigImageCollectionViewCell;

typedef void(^ShowBigImageCollectionViewCellBlock)(NSInteger currentIndex);
@interface ShowBigImageView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
{

}


@property (nonatomic,assign) BOOL                                hiddenTitleNumberLabel;/**< 是否显示标题label，默认显示 2/9 */
@property (nonatomic,assign) NSInteger                           selectIndex;/**< 选择图片索引 */
@property (nonatomic,strong) UILabel                             *titleNumberLabel;/**< 标题label */
@property (nonatomic,strong) UICollectionView                    *collectionView;
@property (nonatomic,strong) NSArray                             *imageArray;/**< 图片数组 */
@property (nonatomic,strong) NSArray                             *textArray;/**< 底部文字描述 */
@property (nonatomic,assign) BOOL                                showDelete;/**< 是否在长按时显示底部删除按钮 ，默认只显示保存到本地*/
@property (nonatomic,copy  ) __block ShowBigImageCollectionViewCellBlock block;

- (void)show;

/**
 *  删除按钮回调
 *
 *  @param block 回调
 */
- (void)ShowBigImageViewDeleteBlock:(ShowBigImageCollectionViewCellBlock)block;

@end



typedef void(^blockState)(id sender);
@interface ShowBigImageCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView  *imageView;
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UIView       *textBgView;
@property (nonatomic,strong) UILabel      *textLabel;
@property (nonatomic,copy  ) NSString     *textLabelStr;



@property (nonatomic,copy) __block blockState block;
- (void)ShowBigImageCollectionViewCellDismissBlock:(blockState)block; /*回调，dismissed */


@end

