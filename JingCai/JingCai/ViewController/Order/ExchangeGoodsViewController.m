//
//  ExchangeGoodsViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ExchangeGoodsViewController.h"
#import "JCTextView.h"
@interface ExchangeGoodsViewController()<UITextViewDelegate>
@property (nonatomic,weak)JCTextView *textView;
@end
@implementation ExchangeGoodsViewController

-(void)viewDidLoad{
 
    [super viewDidLoad ];
    self.title = @"换货申请";
    [self setup];
    
    
}
-(void)viewDidLayoutSubviews{
 
    [super viewDidLayoutSubviews];
}
-(void)setup{
 
    UILabel *label = [[UILabel alloc]init];
    label.font = fontSystemOfSize(16.0);
    label.numberOfLines = 4;
    label.textColor = [UIColor darkGrayColor];
    label.text = [NSString stringWithFormat:@"原商品：%@  %@  %@   价格 %.2f \n 换成:",self.listModel.productName,self.listModel.colorValue,self.listModel.sizeValue,self.listModel.money];
    [self.view addSubview:label];
        CGSize sizeThatFitsLabel = [label sizeThatFits:CGSizeMake(IPHONE_WIDTH - 20, MAXFLOAT)];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(IOS7_TOP_Y + 10.0);
        make.left.mas_equalTo(10.0f);
        make.right.mas_equalTo(-10.0f);
        make.height.mas_equalTo(sizeThatFitsLabel.height);
    }];
    
    JCTextView *textView = [[JCTextView alloc]init];
    textView.placeholder = @"请输入你要换的产品信息，只能换同等价格或更高的价格，系统会自动补差价";
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 1;
    textView.layer.borderWidth = 0.8;
    textView.layer.borderColor = ColorWithRGB(239.0, 240.0, 241.0, 1.0).CGColor;
    [self.view addSubview:textView];
    _textView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(label);
        make.top.mas_equalTo(label.mas_bottom).offset(7.0);
        make.height.mas_equalTo(100.0f);
    }];
    
    UIButton *outButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [outButton setBackgroundColor:ColorWithRGB(60.0, 168.0, 250.0, 1.0)];
    outButton.layer.masksToBounds = YES;
    outButton.layer.cornerRadius = 5.0f;
    [outButton setTitle:@"提交申请" forState:UIControlStateNormal];
    outButton.titleLabel.font = fontSystemOfSize(16.0);
    [outButton addTarget:self action:@selector(actionButton) forControlEvents:UIControlEventTouchUpInside];
    [outButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:outButton];
    
    [outButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_left).offset(10.0);
        make.right.mas_equalTo(label.mas_right).offset(-10.0f);
        make.top.mas_equalTo(textView.mas_bottom).offset(20.0f);
        make.height.mas_equalTo(40.0);
    }];
    
}
-(void)actionButton{
    
    [UIView show_loading_progress:@"申请中.."];
    [[RequestClient sharedClient]order_exchange_remark:[NSString stringWithFormat:@"原商品：%@  %@  %@   价格 %.2f \n 换成:%@",self.listModel.productName,self.listModel.colorValue,self.listModel.sizeValue,self.listModel.money,_textView.text] bookingId:[NSString stringWithFormat:@"%ld",(long)_model.bookingId] progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        
        [UIView show_success_progress:respone.msg];
        self.block(_textView.text);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self leftBtnAction:nil];
        });
        
        
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        [UIView show_loading_progress:respone.msg];
    }];
  
}
@end
