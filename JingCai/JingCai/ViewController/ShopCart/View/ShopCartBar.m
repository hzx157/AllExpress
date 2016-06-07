//
//  ShopCartBar.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShopCartBar.h"

@interface ShopCartBar()
@property (nonatomic,strong)UIButton *chooseButton;
@property (nonatomic,strong)UILabel *priLabel;
@property (nonatomic,strong)UIButton *actionButton;
@property (nonatomic,strong)NSMutableAttributedString *attString;
@end
@implementation ShopCartBar

-(instancetype)initWithFrame:(CGRect)frame{
 
    if(self = [super initWithFrame: frame]){
        
    }
    return self;
}
-(instancetype)init{
 
    if(self = [super init ]){
        
    }
    return self;
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    self.backgroundColor = [UIColor whiteColor];
    self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.actionButton setTitle:@"结算" forState:UIControlStateNormal];
    [self.actionButton setTitle:@"删除" forState:UIControlStateSelected];
    [self.actionButton setBackgroundColor:ColorWithRGB(250.0, 40.0, 63.0, 1.0)];
    [self.actionButton.titleLabel setFont:fontSystemOfSize(15.0) ];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.actionButton.selected = NO;
     [self.actionButton addTarget:self action:@selector(actionButtonClilk:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.actionButton];
    
    
    self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseButton setTitle:@"全选" forState:UIControlStateNormal];
    [self.chooseButton setImage:imageNamed(@"adresssChoose_normal_icon") forState:UIControlStateNormal];
    [self.chooseButton setImage:imageNamed(@"adresssChoose_select_icon") forState:UIControlStateSelected];
    [self.chooseButton.titleLabel setFont:fontSystemOfSize(15.0)];
    [self.chooseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.chooseButton.imageEdgeInsets = UIEdgeInsetsMake(0, -16.0, 0, 0);
    [self.chooseButton addTarget:self action:@selector(chooseButtonClilk:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.chooseButton];
    
    self.priLabel = [[UILabel alloc]init];
    self.priLabel.textAlignment = NSTextAlignmentRight;
    self.priLabel.font = fontSystemOfSize(14);
    
    [self addSubview:self.priLabel];
    
    [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(3.0f);
        make.top.bottom.mas_equalTo(0.0);
        make.width.mas_equalTo(90.0);
        
    }];
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0.0f);
        make.width.mas_equalTo(70.0f);
    }];
    
    [self.priLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.actionButton.mas_left).offset(-5.0);
        make.bottom.top.mas_equalTo(0.0);
        make.left.mas_equalTo(self.chooseButton.mas_left);
    }];
    self.attString = [[NSMutableAttributedString alloc]init];
    

}
-(void)actionButtonClilk:(UIButton *)button{
    
    self.actionBlock(button);
    
}
-(void)chooseButtonClilk:(UIButton *)button{
   
    button.selected = !button.selected;
    self.chooseBlock(button);
}

-(void)setPri:(CGFloat)pri num:(NSInteger)num{
 
    NSString *sting = [NSString stringWithFormat:@"合计：%.2f  \t  共计%ld件",pri,num];
    self.attString = [[NSMutableAttributedString alloc]initWithString:sting];
    [self.attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[sting rangeOfString:[NSString stringWithFormat:@"%.2f",pri]]];
    self.priLabel.attributedText = self.attString;

}

-(void)setIsDelete:(BOOL)isDelete{
    _isDelete = isDelete;
    self.chooseButton.selected = NO;
     [self setPri:0.00 num:0];
    self.actionButton.selected = isDelete;
    self.priLabel.hidden = isDelete;
    
    if(isDelete){
    
        
    }else{
    
    }
}

@end
