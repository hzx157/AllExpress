//
//  UIView+NotData.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIView+NotData.h"

@implementation UIView (NotData)

- (UILabel *)messageLabel {
    UILabel *label = objc_getAssociatedObject(self, _cmd);
    if (!label) {
        label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor darkGrayColor];
         [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.pimageView.mas_bottom);
            make.width.mas_equalTo(self.width - 20);
            make.height.mas_equalTo(HeightScaleSize(40.0));
        }];
       
        objc_setAssociatedObject(self, _cmd, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return label;
}

- (UIImageView *)pimageView {
    UIImageView *imageView = objc_getAssociatedObject(self, _cmd);
    if (!imageView) {
        imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_centerY).offset(-80.0);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        
        objc_setAssociatedObject(self, _cmd, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return imageView;
}
-(void)addNotMsg:(NSString *)message type:(NotDataType)type{
    
    self.pimageView.hidden = NO;
    self.messageLabel.hidden = NO;
    self.messageLabel.text = message;
    
    switch (type) {
        case NotDataTypeCard:
        {
            self.pimageView.image = imageNamed(@"ic_empty_shoppingcar");
            
        }
            break;
        case NotDataTypeOrder:
        {
            self.pimageView.image = imageNamed(@"ic_empty_order_list");
            
        }
            break;
        case NotDataTypeFaovi:
        {
            self.pimageView.image = imageNamed(@"ic_empty_collect_list");
            
        }
            break;
            
        default:
            break;
    }
}
-(void)hideNotMsg{
    self.pimageView.hidden = YES;
    self.messageLabel.hidden = YES;
}
@end
