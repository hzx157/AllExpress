//
//  MyOderCell.m
//  JingCai
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyOderCell.h"
#import "ShopInfoView.h"
#import "OrderViewModel.h"
#import "UIAlertView+Block.h"
@interface MyOderCell ()

@property (nonatomic ,weak) ShopInfoView *shopInfoView;
@property (nonatomic,weak)UILabel *orderNoLabel;//订单号
@property (nonatomic,weak)UILabel *stausLabel;//状态
@property (nonatomic,weak)UILabel *caluLabel;//统计
@end

@implementation MyOderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = RGB(241, 241, 241);
        [self setSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSubviews
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, IPHONE_WIDTH, 180)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    
    //订单号
    UILabel *orderNoLabel = [UILabel new];
    orderNoLabel.backgroundColor = [UIColor clearColor];
    orderNoLabel.textColor = [UIColor darkGrayColor];
    orderNoLabel.font = fontSystemOfSize(14.0);
    [backView addSubview:orderNoLabel];
    [orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8.0f);
        make.height.mas_equalTo(30.0f);
        make.right.mas_equalTo(-7.0);
        make.top.mas_equalTo(0.0);
        
    }];
     _orderNoLabel = orderNoLabel;
    
    //显示状态
    UILabel *stausLabel = [UILabel new];
    stausLabel.textAlignment = NSTextAlignmentRight;
    stausLabel.backgroundColor = [UIColor clearColor];
    stausLabel.textColor = [UIColor redColor];
    stausLabel.adjustsFontSizeToFitWidth = YES;
    stausLabel.font = fontSystemOfSize(14.0);
    stausLabel.alpha = 0.8;
    [orderNoLabel addSubview:stausLabel];
    [stausLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(orderNoLabel);
        
    }];
    _stausLabel = stausLabel;
    
    //线
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = ColorWithRGB(230.0, 230.0, 230.0, 1.0);
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.0f);
        make.top.mas_equalTo(stausLabel.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
   
    
   
    
    
    ShopInfoView *shopInfoView = [[ShopInfoView alloc] initWithFrame:CGRectMake(20, 40, IPHONE_WIDTH - 30, 90)];
    [backView addSubview:shopInfoView];
    _shopInfoView = shopInfoView;
    shopInfoView.carModel = nil;
    //线
    UIImageView *imageView2 = [[UIImageView alloc]init];
    imageView2.backgroundColor = line.backgroundColor;
    [backView addSubview:imageView2];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-40.0);
        make.left.right.mas_equalTo(0.0f);
        make.height.mas_equalTo(0.5);
    }];
    
    
    
    //显示总价
    UILabel *caluLabel = [UILabel new];
    caluLabel.font = fontSystemOfSize(15.0);
    [backView addSubview:caluLabel];
    [caluLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8.0f);
        make.bottom.mas_equalTo(-8.0);
        make.height.mas_equalTo(25.0f);
        
    }];
    _caluLabel = caluLabel;
    
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    payBtn.backgroundColor = kselectColor;
    [payBtn setTitle:@"付款" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [payBtn addTarget:self action:@selector(payBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:payBtn];
    _payBtn = payBtn;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.backgroundColor = RGB(241, 241, 241);
    [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:cancelBtn];
    cancelBtn.hidden = YES;
    _cancelBtn = cancelBtn;
    
   
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10.0f);
        make.bottom.mas_equalTo(caluLabel.mas_bottom);
        make.height.mas_equalTo(caluLabel.mas_height);
        make.width.mas_equalTo(65.0);
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(payBtn.mas_left).offset(-10);
        make.bottom.mas_equalTo(caluLabel.mas_bottom);
        make.height.mas_equalTo(caluLabel.mas_height);
        make.width.mas_equalTo(65.0);
    }];
}

- (void)setModel:(OrderModel *)model
{
    _model = model;
    
    DetailListModel *detail = [model.detailList firstObject];
    [_shopInfoView.shopImg sd_setImageWithURL:[NSURL URLWithString:detail.mainImage] placeholderImage:defaultLogo];
    _shopInfoView.shopTitle.text = detail.productName;
    _shopInfoView.shopColor.text = [NSString stringWithFormat:@"颜色分类：%@",detail.colorValue];
    _shopInfoView.shopSize.text = [NSString stringWithFormat:@"尺码：%@",detail.sizeValue];
    _shopInfoView.shopMoney.text = [NSString stringWithFormat:@"%.2f",detail.money];
    _shopInfoView.shopCount.text = [NSString stringWithFormat:@"%ld件",(long)detail.buyNum];
    _orderNoLabel.text = [NSString stringWithFormat:@"订单号：%@",model.outTradeNo];
    _caluLabel.text = [NSString stringWithFormat:@"共%ld件商品 共%.2f元",(long)model.buyNum,model.money];
    //更新状态
    [OrderViewModel updateStausWithPayBtn:_payBtn toCancel:_cancelBtn toStaus:_stausLabel type:model.type];
    

}


- (void)payBtnAction:(UIButton *)sender
{
    
    NSString *string = [NSString stringWithFormat:@"确定%@操作吗",sender.titleLabel.text];
    if(_model.type == OrderTypeWaitRecive){ //完成订单
          string = @"确认收货操作吗 一旦确定将不允许退换货";
    }else if (_model.type == OrderTypeWaitPay){
        
        if(self.payBlock)
        self.payBlock(_model,self.indexPath);
        
        return;
    }
    
    [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if(buttonIndex == 1){
            if(self.payBlock)
            self.payBlock(_model,self.indexPath);
            
        }
        
    } title:string message:nil cancelButtonName:@"取消" otherButtonTitles:@"确定", nil];
  
}

- (void)cancelBtnAction:(UIButton *)sender
{
    if([sender.titleLabel.text isEqualToString:@"查看物流"]){
        if(self.cancelBlock){
           self.cancelBlock(_model,self.indexPath);
           
        }
        return;
    }
    
    [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if(buttonIndex == 1){
            if(self.cancelBlock)
            self.cancelBlock(_model,self.indexPath);
            
        }
        
    } title:[NSString stringWithFormat:@"确定%@操作吗",sender.titleLabel.text] message:nil cancelButtonName:@"取消" otherButtonTitles:@"确定", nil];
    

}

@end
