//
//  PerformanceCell.m
//  AnalysisHtmlDemo
//
//  Created by Roger on 2016/5/18.
//  Copyright © 2016年 qihui. All rights reserved.
//

//适配系数
#define KScreenScale ([UIScreen mainScreen].bounds.size.width/320.0f)

#import "PerformanceCell.h"

@implementation PerformanceCell{
    CGFloat currX;
}

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
 {
// NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"status";
// 1.缓存中取
    PerformanceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
// 2.创建
    if (cell == nil) {
        cell = [[PerformanceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *testLabel;
        for (int i = 0; i < 4 ; i ++) {
            UILabel * label = [[UILabel alloc]init];
            label.lineBreakMode = NSLineBreakByTruncatingMiddle;
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:14];
//            label.minimumScaleFactor = 0.5;
            label.textAlignment = 1;
            [self.contentView addSubview:label];
            
            switch (i) {
                case 0:
                {
                    label.frame = CGRectMake(0, 0, 80*KScreenScale, 44);
                    self.nameLabel = label;
                }
                    break;
                case 1:
                {
                    label.adjustsFontSizeToFitWidth = YES;
                    label.frame = CGRectMake(testLabel.right, 0, IPHONE_WIDTH - (220*KScreenScale), testLabel.height);
                    self.closeNameLabel = label;
                }
                    break;
                case 2:
                {
                 
                    label.frame = CGRectMake(testLabel.right, 0, 70*KScreenScale, testLabel.height);
                       self.countLabel = label;
                    
                }
                    break;
                case 3:
                {
                    
                    label.frame = CGRectMake(testLabel.right, 0, 70*KScreenScale, testLabel.height);
                    self.fanMoneyLabel = label;
                }
                    break;
                    
                    
                default:
                    break;
            }
            
            testLabel = label;
            
        }
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
