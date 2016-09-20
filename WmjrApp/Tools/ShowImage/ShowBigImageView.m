



//
//  ShowBigImageView.m
//  ShowBigImage
//
//  Created by baimifan on 15/8/14.
//  Copyright (c) 2015年 lyl. All rights reserved.
//

#import "ShowBigImageView.h"



@interface ShowBigImageView()

@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,strong) UIButton *saveImageButton;

@end


@implementation ShowBigImageView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _selectIndex = 1;
        self.alpha = 0;
        self.backgroundColor = [UIColor redColor];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        _collectionView.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleWidth;
        [self addSubview:_collectionView];
        [_collectionView registerClass:[ShowBigImageCollectionViewCell class] forCellWithReuseIdentifier:@"bigCell"];
        _titleNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, frame.size.width - 100, 30)];
        _titleNumberLabel.textColor = [UIColor whiteColor];
        _titleNumberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleNumberLabel];
        self.autoresizesSubviews = YES;
        
        
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imageArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShowBigImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bigCell" forIndexPath:indexPath];
    if (_imageArray.count > 0) {
        if ([_imageArray[indexPath.row] isKindOfClass:[NSString class]]) {
            NSString *imageStr = _imageArray[indexPath.row];
            if ([imageStr hasPrefix:@"http"]) {
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"user_mesicon_icon.png"]];
            }else{
                cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
            }
            
        }else if ([_imageArray[indexPath.row] isKindOfClass:[UIImage class]]){
            cell.imageView.image = _imageArray[indexPath.row];
        }
    }
    if (_textArray.count > 0) {
        if (_textArray.count == _imageArray.count) {
            cell.textLabelStr = _textArray[indexPath.row];
        }else {
            cell.textLabelStr = _textArray[0];
        }
    }
    
    __block ShowBigImageView *safeSelf = self;
    [cell ShowBigImageCollectionViewCellDismissBlock:^(id sender) {
        NSString *str = (NSString *)sender;
        if ([str isEqualToString:@"dismiss"]) {
            [safeSelf removeSelf];
        }else if ([str isEqualToString:@"longGes"]) {
            [safeSelf showBottomButtons];
        }
        
    }];
    return cell;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self dismissBottomButton];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat width = CGRectGetWidth(self.bounds);
    NSInteger page = contentOffset.x/width;
    _titleNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)page + 1,(long)_imageArray.count];
    _selectIndex = page + 1;
}

/* 父试图上添加 */
- (void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.35f animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        weakSelf.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}
/* 移除 */
- (void)removeSelf{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25f animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        weakSelf.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_hiddenTitleNumberLabel) {
        _titleNumberLabel.hidden = YES;
    }
    
    if (_imageArray) {
        [_collectionView reloadData];
        _titleNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)_selectIndex,(long)_imageArray.count];
    }
    
    
}
/* set 选择的索引 */
- (void)setSelectIndex:(NSInteger)selectIndex{
    if (_selectIndex != selectIndex) {
        _selectIndex = selectIndex;
        _titleNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)_selectIndex,(long)_imageArray.count];
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_selectIndex - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

/**
 *  显示底部按钮
 */
- (void)showBottomButtons {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 40);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonSelect) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitleColor:[UIColor colorWithRed:0.13f green:0.14f blue:0.13f alpha:1.00f] forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
        [self addSubview:_cancelButton];
    }
    
    if (!_saveImageButton) {
        _saveImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveImageButton addTarget:self action:@selector(saveImageButtonSelect) forControlEvents:UIControlEventTouchUpInside];
        _saveImageButton.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 40);
        [_saveImageButton setTitle:@"保存图片" forState:UIControlStateNormal];
        [_saveImageButton setTitleColor:[UIColor colorWithRed:0.13f green:0.14f blue:0.13f alpha:1.00f] forState:UIControlStateNormal];
        _saveImageButton.backgroundColor = [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
        [self addSubview:_saveImageButton];
    }
    
    if (_showDelete) {
        if (!_deleteButton) {
            _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_deleteButton addTarget:self action:@selector(deleteButtonSelect) forControlEvents:UIControlEventTouchUpInside];
            _deleteButton.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 40);
            [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
            [_deleteButton setTitleColor:[UIColor colorWithRed:0.13f green:0.14f blue:0.13f alpha:1.00f] forState:UIControlStateNormal];
            _deleteButton.backgroundColor = [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
            [self addSubview:_deleteButton];
        }
        
    }
    
    
    [UIView animateWithDuration:0.35 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        if (_showDelete) {
            _saveImageButton.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 130, CGRectGetWidth(self.frame), 40);
            _deleteButton.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 85, CGRectGetWidth(self.frame), 40);
        }else {
            _saveImageButton.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 85, CGRectGetWidth(self.frame), 40);
        }
        _cancelButton.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 40, CGRectGetWidth(self.frame), 40);
        
    }];
    
    
    
}
/**
 *  隐藏底部按钮
 */
- (void)dismissBottomButton {
    [UIView animateWithDuration:0.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        if (_showDelete) {
            _deleteButton.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 40);
        }
        _saveImageButton.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 40);
        _cancelButton.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 40);
        
    }];
}

/**
 *  取消按钮事件
 */
- (void)cancelButtonSelect {
    [self dismissBottomButton];
}
/**
 *  保存图片按钮逻辑
 */
- (void)saveImageButtonSelect {
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex - 1 inSection:0]];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:10089];
    if (imageView) {
        if ([imageView image]) {
            UIImageWriteToSavedPhotosAlbum([imageView image], nil, nil, nil);
            [self dismissBottomButton];
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        }
    }
    
}
/**
 *  删除按钮，用block回调
 */
- (void)deleteButtonSelect {
    [self dismissBottomButton];
    [self removeSelf];
    self.block(_selectIndex);
}

- (void)ShowBigImageViewDeleteBlock:(ShowBigImageCollectionViewCellBlock)block {
    self.block = block;
}


@end

#pragma mark ------------------------

@implementation ShowBigImageCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _bgScrollView.backgroundColor = [UIColor blackColor];
        _bgScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        _bgScrollView.delegate = self;
        _bgScrollView.maximumZoomScale = 4;
        _bgScrollView.minimumZoomScale = 1;
        [self.contentView addSubview:_bgScrollView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.tag = 10089;
        [_bgScrollView addSubview:_imageView];
        
        _textBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _textBgView.alpha = 0.3;
        _textBgView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_textBgView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.numberOfLines = 2;
        _textLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:_textLabel];
        
        UITapGestureRecognizer *tapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        tapGser.numberOfTouchesRequired = 1;
        tapGser.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGser];
        UITapGestureRecognizer *doubleTapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBig:)];
        doubleTapGser.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGser];
        [tapGser requireGestureRecognizerToFail:doubleTapGser];
        
        UILongPressGestureRecognizer *longGesToSave = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureSave:)];
        longGesToSave.minimumPressDuration = 0.6f;
        [self addGestureRecognizer:longGesToSave];
        
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_textLabelStr) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:textLabel];
    }
    
}

- (void)resetTextLabelHaveImg{
    
}
-(void)setTextLabelStr:(NSString *)textLabelStr{
    
    _textLabelStr = textLabelStr;
    _textBgView.frame = CGRectMake(0, self.bounds.size.height - 50, self.bounds.size.width, 50);
    _textLabel.frame = CGRectMake(10, self.bounds.size.height - 50, self.bounds.size.width - 20, 50);
    _textLabel.text = _textLabelStr;
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

- (void)ShowBigImageCollectionViewCellDismissBlock:(blockState)block{
    self.block = block;
}

- (void)disappear{
    self.block(@"dismiss");
}
/* 点击图片，放大*/

- (void)changeBig:(UITapGestureRecognizer *)tapGes{
    CGFloat newscale = 1.9;
    static BOOL doubleClick = YES;
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[tapGes locationInView:tapGes.view] andScrollView:_bgScrollView];
    if (doubleClick == YES)  {
        [_bgScrollView zoomToRect:zoomRect animated:YES];
    }else {
        [_bgScrollView zoomToRect:_bgScrollView.frame animated:YES];
    }
    doubleClick = !doubleClick;
}
- (CGRect)zoomRectForScale:(CGFloat)newscale withCenter:(CGPoint)center andScrollView:(UIScrollView *)scrollV{
    CGRect zoomRect = CGRectZero;
    zoomRect.size.height = scrollV.frame.size.height / newscale;
    zoomRect.size.width = scrollV.frame.size.width  / newscale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
    
}

/* 长按保存*/
- (void)longGestureSave:(UILongPressGestureRecognizer *)longGes{
    
    if (longGes.state == UIGestureRecognizerStateBegan) {
        self.block(@"longGes");
    }
}



@end













