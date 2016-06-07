//
//  ChooseAddressCellTableViewCell.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChooseAddressCellTableViewCell.h"
@interface ChooseAddressCellTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *defButton;//选择

@end
@implementation ChooseAddressCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(AddressModel *)model{
    
    self.nameLabel.text = model.contact;
    self.phoneLabel.text = model.phone;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.district,model.detail_address];
    
    _defButton.selected = model.isdefalt;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
