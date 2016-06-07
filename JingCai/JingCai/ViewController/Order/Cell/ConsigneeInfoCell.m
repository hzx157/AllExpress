//
//  ConsigneeInfoCell.m
//  JingCai
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ConsigneeInfoCell.h"

@interface ConsigneeInfoCell ()

@property (nonatomic, strong) UIImageView *locationIcon;
@property (nonatomic, strong) UIImageView *arrowImgV;
@property (nonatomic, strong) UILabel *nameTitleLbl;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *addressTitleLbl;
@property (nonatomic, strong) UILabel *addressLbl;

@end

@implementation ConsigneeInfoCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews
{
    [self addSubview:self.locationIcon];
    [self addSubview:self.nameTitleLbl];
    [self addSubview:self.addressTitleLbl];
    [self addSubview:self.nameLbl];
    [self addSubview:self.addressLbl];
    [self addSubview:self.arrowImgV];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(25);
    }];
    
    [self.nameTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(50);
        make.top.equalTo(self).offset(20);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(13);
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameTitleLbl.mas_right).offset(5);
        make.top.equalTo(_nameTitleLbl);
        make.width.mas_equalTo(IPHONE_WIDTH - 150);
        make.height.mas_equalTo(13);
    }];
    
    [self.addressTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameTitleLbl);
        make.top.equalTo(_nameTitleLbl.mas_bottom).offset(20);
        make.width.mas_equalTo(66);
        make.height.mas_equalTo(13);
    }];
    
    [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addressTitleLbl.mas_right).offset(5);
        make.top.equalTo(_addressTitleLbl);
        make.width.mas_equalTo(IPHONE_WIDTH - 150);
        make.height.mas_equalTo(13);
    }];
    
    [self.arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(20);
    }];
    
}

- (UIImageView *)locationIcon
{
    if (!_locationIcon) {
        _locationIcon = [[UIImageView alloc] init];
        _locationIcon.contentMode = UIViewContentModeScaleAspectFit;
        _locationIcon.image = [UIImage imageNamed:@"address"];
    }
    return _locationIcon;
}

- (UILabel *)nameTitleLbl
{
    if (!_nameTitleLbl) {
        _nameTitleLbl = [[UILabel alloc] init];
        _nameTitleLbl.textColor = [UIColor blackColor];
        _nameTitleLbl.font = [UIFont systemFontOfSize:13];
        _nameTitleLbl.text = @"收货人：";
    }
    return _nameTitleLbl;
}


- (UILabel *)nameLbl
{
    if (!_nameLbl) {
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.textColor = [UIColor blackColor];
        _nameLbl.font = [UIFont systemFontOfSize:13];
    }
    return _nameLbl;
}

- (UILabel *)addressTitleLbl
{
    if (!_addressTitleLbl) {
        _addressTitleLbl = [[UILabel alloc] init];
        _addressTitleLbl.textColor = [UIColor blackColor];
        _addressTitleLbl.font = [UIFont systemFontOfSize:13];
        _addressTitleLbl.text = @"收货地址：";
    }
    return _addressTitleLbl;
}

- (UILabel *)addressLbl
{
    if (!_addressLbl) {
        _addressLbl = [[UILabel alloc] init];
        _addressLbl.textColor = [UIColor blackColor];
        _addressLbl.font = [UIFont systemFontOfSize:13];
    }
    return _addressLbl;
}

- (UIImageView *)arrowImgV
{
    if (!_arrowImgV) {
        _arrowImgV = [[UIImageView alloc] init];
        _arrowImgV.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImgV.image = [UIImage imageNamed:@"jiantou"];
    }
    return _arrowImgV;
}

- (void)setAddressModel:(AddressModel *)addressModel
{
    _addressModel = addressModel;
    if(addressModel == nil){
        
        return;
    }
    self.nameLbl.text = [NSString stringWithFormat:@"%@          %@",addressModel.contact,addressModel.phone];
    self.addressLbl.text = [NSString stringWithFormat:@"%@%@%@%@",addressModel.province,addressModel.city,addressModel.district,addressModel.detail_address];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setOrderDetailHide{
   
    self.arrowImgV.hidden = YES;
    self.addressLbl.text = [Common getNULLString:_addressModel.addressDetail];
}

@end
