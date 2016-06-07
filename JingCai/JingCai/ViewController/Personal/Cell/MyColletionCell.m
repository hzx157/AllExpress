//
//  MyColletionCell.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyColletionCell.h"
@interface MyColletionCell()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
@implementation MyColletionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(id)model{

   
    [_logoImageView sd_setImageWithURL:urlNamed(model[@"main_pic"]) placeholderImage:defaultLogo];
    _name.text = model[@"fav_title"];
    NSString *price = [NSString stringWithFormat:@"￥%@", [Common getNULLString:model[@"pro_price"]]];
    NSMutableAttributedString *attstring = [[NSMutableAttributedString alloc]initWithString:price];
    [attstring addAttribute:NSFontAttributeName value:fontSystemOfSize(12) range:[price rangeOfString:@"￥"]];
    _priceLabel.attributedText = attstring;
    
    
}

@end
