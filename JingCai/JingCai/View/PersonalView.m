//
//  PersonalView.m
//  JingCai
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 apple. All rights reserved.
//  个人中心顶部视图

#import "PersonalView.h"
@interface PersonalView()
@property (nonatomic,strong)UIButton *button;
@end

@implementation PersonalView

- (UIImageView *)headImg{
    if(!_headImg){
        _headImg = [[UIImageView alloc] init];
        _headImg.layer.masksToBounds = YES;
        _headImg.layer.cornerRadius = 40.0;
        WEAKSELF;
        [_headImg addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            weakSelf.imageBlock();
            
        }];
        [self addSubview:_headImg];
    }
    return _headImg;
}

- (UILabel *)nick{
    if(!_nick){
        _nick = [[UILabel alloc] init];
        _nick.textColor = [UIColor darkGrayColor];
        _nick.font = [UIFont systemFontOfSize:15];
//        _nick.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nick];
    }
    return _nick;
}

- (UILabel *)member{
    if(!_member){
        _member = [[UILabel alloc] init];
        _member.textColor = [UIColor darkGrayColor];
        _member.font = [UIFont systemFontOfSize:15];
//        _member.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_member];
    }
    return _member;
}
-(UIButton *)button{
  
    if(!_button){
     
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_button setTitleColor:ColorWithRGB(0, 185, 255, 1.0) forState:UIControlStateNormal];
       //  [_button setTitleColor:ColorWithRGB(0, 185, 255, 1.0) forState:UIControlStateNormal];
        _button.titleLabel.font = fontSystemOfSize(14);
        [_button setTitle:@"点击链接成为代言人" forState:UIControlStateNormal];
        [_button setTitle:@"查看我的邀请码" forState:UIControlStateSelected];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _button.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_button addTarget:self action:@selector(didButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
    }
    return _button;
    
}
-(void)didButtonAction:(UIButton *)button{
    self.buttonBlock(button);
}
- (id)init{
    if(self = [super init]){
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:imageNamed(@"ic_person_bg")];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self insertSubview:imageView atIndex:0];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
      
    }
    return self;
}


- (void)setDic:(NSDictionary *)dic{
    
    self.headImg.frame = CGRectMake(40.0, 30, 80, 80);
    self.nick.frame = CGRectMake(self.headImg.right+10, self.headImg.top +8, IPHONE_WIDTH - self.headImg.right + 20, 17);
    self.member.frame = CGRectMake(self.nick.left, self.nick.bottom + 8, self.nick.width, 17);
    self.button.frame = CGRectMake(self.nick.left, self.member.bottom + 8, self.nick.width, 20);
    
    [self.headImg sd_setImageWithURL:urlNamed([Common getNULLString:[LoginModel shareLogin].userImage]) placeholderImage:defaultLogo];
    self.nick.text = [LoginModel shareLogin].nickName;
    self.member.text = [LoginModel getRoleName];
    self.button.selected = [LoginModel shareLogin].roleId >roleTypeNormal;
}




@end