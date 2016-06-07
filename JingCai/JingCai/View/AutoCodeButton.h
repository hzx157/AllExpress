
/*
 @brief: 自定义获取验证码按钮
 */

#import <UIKit/UIKit.h>

@interface AutoCodeButton : UIButton<UIAlertViewDelegate>{
    int count;          //获取验证码的时间 (默认 60 秒)
    NSTimer *tempTimer;
}

@property (nonatomic, assign) BOOL isReisgter;
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, copy) NSString *code;

- (void)setButton;


@end
