//
//  ViewForProductCategory.h
//  WmjrApp
//
  
//

#import <UIKit/UIKit.h>
@class HomeProductCatModel;
@interface ViewForProductCategory : UIView

@property (nonatomic, copy) void(^buttonClickMethod)(NSString *productId);

- (instancetype)initWithProductModel:(HomeProductCatModel *)productModel;

@end
