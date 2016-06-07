//
//  SureOderShopCell.m
//  JingCai
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SureOderShopCell.h"
#import "ShopInfoView.h"

@interface SureOderShopCell ()

@property (nonatomic, weak) ShopInfoView *shopInfoView;
@property (nonatomic, weak) UILabel *numLbl;
@property (nonatomic, strong) UIView *shopNumView;
@property (nonatomic ,assign) NSInteger count;

@end

@implementation SureOderShopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews
{
    ShopInfoView *shopInfoView = [[ShopInfoView alloc] initWithFrame:CGRectMake(10, 10, IPHONE_WIDTH - 20, 80)];
    [self addSubview:shopInfoView];
    _shopInfoView = shopInfoView;
    [self addSubview:self.shopNumView];
}


- (UIView *)shopNumView
{
    if (!_shopNumView) {
        _shopNumView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, IPHONE_WIDTH, 70)];
        
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.frame = CGRectMake(10, 15, 100, 14);
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.font = [UIFont systemFontOfSize:14];
        titleLbl.text = @"购买数量";
        [_shopNumView addSubview:titleLbl];
        
        CGFloat w = 34;
        CGFloat h = 25;
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(IPHONE_WIDTH - w - 10, 30, w, h);
        [addBtn setBackgroundImage:[UIImage imageNamed:@"max"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_shopNumView addSubview:addBtn];
        
        UILabel *numLbl = [[UILabel alloc] init];
        numLbl.frame = CGRectMake(IPHONE_WIDTH - 2 * w - 10, addBtn.top, w, h);
        numLbl.textColor = [UIColor blackColor];
        numLbl.textAlignment = NSTextAlignmentCenter;
        numLbl.font = [UIFont systemFontOfSize:12];
        numLbl.text = @"1";
        _numLbl = numLbl;
        [_shopNumView addSubview:numLbl];
        
        UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        subBtn.frame = CGRectMake(IPHONE_WIDTH - 3 * w - 10, addBtn.top, w, h);
        [subBtn setBackgroundImage:[UIImage imageNamed:@"minmux"] forState:UIControlStateNormal];
        [subBtn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_shopNumView addSubview:subBtn];
        
    }
    return _shopNumView;
}

- (void)setCarModel:(ShopCarModel *)carModel
{
    _carModel = carModel;
    _shopInfoView.carModel = carModel;
    
    
    [_shopInfoView.shopImg sd_setImageWithURL:urlNamed(carModel.simage) placeholderImage:defaultLogo];
    _shopInfoView.shopTitle.text = carModel.productName;
    _shopInfoView.shopColor.text = [NSString stringWithFormat:@"颜色分类：%@",[Common getNULLString:carModel.scolor]];
    _shopInfoView.shopSize.text = [NSString stringWithFormat:@"尺码：%@",[Common getNULLString:carModel.ssize]];
    _shopInfoView.shopMoney.text = [NSString stringWithFormat:@"%.@",carModel.sprice];
    _numLbl.text = [NSString stringWithFormat:@"%ld",(long)carModel.snum ];
    _count = carModel.snum ;

}

- (void)addBtnAction:(UIButton *)sender
{
    _count = [_numLbl.text integerValue];
    _count ++;
    NSString *countStr = [NSString stringWithFormat:@"%ld",_count];
    _numLbl.text = countStr;
    _carModel.snum = _count;
    
    self.countBlock(_indexPath,_carModel);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addOrderNum" object:nil];
}

- (void)subBtnAction:(UIButton *)sender
{
    if (_count == 0) {
        
        return;
    }
    _count = [_numLbl.text integerValue];
    _count --;
    NSString *countStr = [NSString stringWithFormat:@"%ld",_count];
    _numLbl.text = countStr;
    _carModel.snum = _count;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"subOrderNum" object:nil];
     self.countBlock(_indexPath,_carModel);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
