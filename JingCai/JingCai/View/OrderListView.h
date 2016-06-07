

typedef void(^OrderBlock)(NSInteger);

#import <UIKit/UIKit.h>

@interface OrderListView : UIView

@property (nonatomic, copy) OrderBlock block;

@end
