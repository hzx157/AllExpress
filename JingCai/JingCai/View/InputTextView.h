
/*
 * brief: 自定义输入框
 */

#import <UIKit/UIKit.h>

@interface InputTextView : UIView

@property (nonatomic, strong) UILabel *leftName; //左侧名称

@property (nonatomic, strong) UIImageView *icon; //左侧名称

@property (nonatomic, strong) UILabel *rightName; //右侧

@property (nonatomic, strong) UITextField *myTextField; //输入文本

@property (nonatomic, strong) UIImageView *imgBg;

- (void)setViewFrame;

@end
