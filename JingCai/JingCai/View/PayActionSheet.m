//
//  PayActionSheet.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PayActionSheet.h"
#import "NSDate+Extension.h"
#import "UIButton+Block.h"
@interface PayActionSheet()
@property (nonatomic,weak)UILabel *titleLabel;
@property (nonatomic,weak)UILabel *messageLabel;
@property (nonatomic,weak)UIView *view;
@property (nonatomic,weak)UIButton *simButton;
@property (nonatomic,copy)returnBlock block;
@end

@implementation PayActionSheet

-(instancetype)init{
 
    if(self = [super init ]){
        [self setup];
    }
    return self;
}
-(void)setup{

 
    self.frame = [[[[UIApplication sharedApplication] delegate] window] bounds];
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    UIView *bottomView = [[UIView alloc]init];
    bottomView.userInteractionEnabled = YES;
    bottomView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:bottomView];

    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0.0);
        make.height.bottom.mas_equalTo(250.0f);
    }];
    self.view = bottomView;
    
    UILabel *tisLabel = [UILabel new];
    tisLabel.text = @"成为代言人";
    tisLabel.userInteractionEnabled = YES;
    tisLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:tisLabel];
    [tisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.0);
        make.height.mas_equalTo(50.0);
    }];
    self.titleLabel = tisLabel;
    
    WEAKSELF;
    UIButton *cancelImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelImageView setImage:imageNamed(@"delete_clear") forState:UIControlStateNormal];
    cancelImageView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cancelImageView.userInteractionEnabled = YES;
    [cancelImageView addActionHandler:^(NSInteger tag) {
        [weakSelf dis];
    }];
    [tisLabel addSubview:cancelImageView];
    [cancelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0.0f);
        make.width.mas_equalTo(40.0);
    }];
    
    
    
    
    
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = ColorWithRGB(221.0, 222.0, 223.0, 1);
    [bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.0f);
        make.height.mas_equalTo(0.8);
        make.top.mas_equalTo(tisLabel.mas_bottom);
    }];
    
    
    
    UILabel *messageLabel = [UILabel new];
    messageLabel.font = fontSystemOfSize(15.0);
    messageLabel.textColor = [UIColor darkGrayColor];
    messageLabel.numberOfLines = 0;
    [bottomView addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0);
        make.right.mas_equalTo(-20.0);
        make.top.mas_equalTo(line.mas_bottom).offset(10.0f);
        make.bottom.mas_equalTo(-50.0f);
    }];
    self.messageLabel = messageLabel;
    
    UIButton *simbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [simbtn setTitle:@"确定" forState:UIControlStateNormal];
    simbtn.userInteractionEnabled = YES;
    simbtn.layer.cornerRadius = 4.0f;
    simbtn.layer.masksToBounds = YES;
    simbtn.backgroundColor = ColorWithRGB(20.0, 152.0, 233.0, 1);
    simbtn.titleLabel.font = fontSystemOfSize(16.0);
    [simbtn addTarget:self action:@selector(button) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:simbtn];
    [simbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.7);
        make.height.mas_equalTo(44.0f);
        make.bottom.mas_equalTo(-20.0f);
        
    }];
    _simButton = simbtn;
    
}
-(void)button{
    self.block(YES);
    self.block = nil;
    [self dis];
}

//userType		int	3:代言人  4：代理商
-(void)show:(NSString *)title type:(NSInteger)userType toBlock:(returnBlock)block{

    self.block = block;
    self.titleLabel.text = title;
    
    NSString *string;
    switch (userType) {
        case 3: //成为代言人
        {
             NSString *money = [[[NSDate date] formatYMD] isEqualToString:@"2016-05-29"] ? @"9.9" :@"16.8";
             string = [NSString stringWithFormat:@"开通代言人需要%@元,当前您的余额为%.2f元，确定要成为晶彩代言人吗",money, SINGLE.moneyModel.useMoney];
        }
            break;
        case 4: //成为合作商
        {
            if([LoginModel shareLogin].roleId == roleTypeSpokesman){ //当前是代言人
              string = [NSString stringWithFormat:@"开通合适商需要10000.0元,当前您的余额为%.2f元，确定要成为晶彩合作商吗", SINGLE.moneyModel.useMoney];
            }else{
                 NSString *money = [[[NSDate date] formatYMD] isEqualToString:@"2016-05-29"] ? @"10009.9" :@"10016.8";
              string = [NSString stringWithFormat:@"开通合作商需要%@元,当前您的余额为%.2f元，确定要成为晶彩合作商吗",money, SINGLE.moneyModel.useMoney];
            }
        }
            break;
            
        default:
            break;
    }
    
    self.messageLabel.text = string;
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0.0f);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
           self.userInteractionEnabled = YES;
        self.view.userInteractionEnabled = YES;
        self.titleLabel.userInteractionEnabled = YES;
        self.simButton.userInteractionEnabled = YES;
        
    }];
    
    
}
-(void)dis{
    
    if(self.block){
      self.block(NO);
        self.block = nil;
    }
    
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(200.0f);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0f;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
           [self removeFromSuperview];
    }];

}

@end
