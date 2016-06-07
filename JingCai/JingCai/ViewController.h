

#import <UIKit/UIKit.h>
#import "ShopCartViewController.h"
#import "ShopViewController.h"
#import "PersonalViewController.h"
#import "ZoneViewController.h"

@interface ViewController : UITabBarController

@property (nonatomic, strong) UIButton *selectBtn; //临时按钮
@property (nonatomic, strong) UIButton *shopCartBtn; //购物车按钮
@property (nonatomic, strong) UIImageView *tabBarImg; //标签栏底部图片视图
@property (nonatomic, strong) ShopViewController *shopVC; //首页商品页
@property (nonatomic, strong) ZoneViewController *zoneVC; //晶彩圈
@property (nonatomic, strong) ShopCartViewController *shopCartVC; //购物车页
@property (nonatomic, strong) PersonalViewController *persoanlVC; //个人中心页

- (void)handleSeletedTabBar:(UIButton *)sender;

@end
@interface tabBarButton : UIButton

@end

