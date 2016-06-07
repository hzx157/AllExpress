//
//  OrderSelectView.m
//  JingCai
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//



#import "OrderSelectView.h"

@implementation OrderSelectView
{
    UIButton *_currentBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews
{
    self.backgroundColor = ColorWithRGB(216.0, 217.0, 218.0, 1.0);
    
    NSArray *titleArray = @[@"全部",@"待付款",@"待发货",@"待收货",@"已收货",@"退款"];
    NSArray *typeArray = @[@(OrderTypeAll),@(OrderTypeWaitPay),@(OrderTypeWaitSend),@(OrderTypeWaitRecive),@(OrderTypeOrderSuccess),@(OrderTypeAllBack)];
    for (int i = 0; i < titleArray.count; i ++) {
        
        CGFloat buttonW = self.width/titleArray.count;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * buttonW + i*0.5,0.5, buttonW, self.height - 1.0);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:RGB(103, 103, 103) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundColor:knormalColor];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = [typeArray[i] integerValue] +100;
        [self insertSubview:button atIndex:0];
        
        if (i == 0) {
            button.backgroundColor = kselectColor;
            button.selected = YES;
            _currentBtn = button;
        }
        
     
    }
    

}

- (void)buttonAction:(UIButton *)sender
{
    if (sender == _currentBtn) {
        return;
    }
    _currentBtn.selected = NO;
    _currentBtn.backgroundColor = knormalColor;
    sender.selected = YES;
    sender.backgroundColor = kselectColor;
    _currentBtn = sender;
    OrderType index = sender.tag -100;
    if (self.OrderSelectViewBlock) {
        self.OrderSelectViewBlock(index);
    }
}

- (void)setSelectIndicateAtType:(OrderType)type
{
    _currentBtn.selected = NO;
    _currentBtn.backgroundColor = knormalColor;

    _currentBtn = (UIButton *)[self viewWithTag:type + 100];
    _currentBtn.selected = YES;
    _currentBtn.backgroundColor = kselectColor;
}

@end
