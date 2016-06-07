
typedef NS_ENUM(NSInteger, ShopStyle) {
    ShopStyle_addShopCart = 0,
    ShopStyle_buySHop,
};

typedef void(^BuyBlock)(id);
typedef void(^AddBlock)(id);
typedef void(^DeleteBolck)(id);

#import <UIKit/UIKit.h>

@interface ShopStyleView : UIView

@property (nonatomic, copy) BuyBlock buy;
@property (nonatomic, copy) AddBlock add;
@property (nonatomic, copy) DeleteBolck delet;

@property (nonatomic, assign) ShopStyle shopStyle;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic,strong)ShopDetailModel *detailModel;
@end
