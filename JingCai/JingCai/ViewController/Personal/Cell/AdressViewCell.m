//
//  AdressViewCell.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AdressViewCell.h"
@interface AdressViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *defButton;//选择
@property (weak, nonatomic) IBOutlet UIButton *edirButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@end

@implementation AdressViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(AddressModel *)model{
      self.nameLabel.text = model.contact;
      self.phoneLabel.text = model.phone;

      self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.district,model.detail_address];
    
    _defButton.selected = model.isdefalt;

}

- (IBAction)buttonAction:(UIButton *)sender {
    
    self.block(sender.tag,self.indexPath,_model);
    switch (sender.tag) {
        case 111: //默认
        {
            sender.selected = !sender.selected;
        }
            break;
        case 222:
        {
            
        }
            break;
        case 333:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

@end
