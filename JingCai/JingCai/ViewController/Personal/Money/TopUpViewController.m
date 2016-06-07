//
//  TopUpViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TopUpViewController.h"
#import "UIImage+Color.h"
#import "PayModel.h"
#import "WeiXinHelper.h"
#import <OpenShare/OpenShare.h>
@interface TopUpViewController()<UITextFieldDelegate>{

    NSIndexPath *_indexPath;

}

@property (nonatomic,weak)UITextField *textFiled;
@property (nonatomic,weak)UIButton *comButton;
@property (nonatomic,copy)NSString *priceString;

@end
@implementation TopUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    
    self.tableViewStyle = UITableViewStyleGrouped;
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView reloadData];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 10.0)];
    [self setup];
    
}

///充值
-(void)topUpButton:(id)sender{
 
    if([_priceString componentsSeparatedByString:@"."].count >2){
        [UIView show_fail_progress:@"金额输入错误"];
        return;
    }else if ([_priceString length]>9){
        [UIView show_fail_progress:@"充值金额过大"];
        return;
    }else if ([_priceString floatValue]<0.00){
        [UIView show_fail_progress:@"充值金额必须大于0.00"];
        return;
    }
    
    
    
    [self aliPay:_priceString];
    //[self leftBtnAction:nil];
    
}


#pragma mark ------ 支付 ------
-(void)aliPay:(NSString *)str{
  
     [PayModel sharePayModelWithMoney:str toPayModelType:_indexPath.row block:^(BOOL isSccuess, NSString *money, NSString *message) {
         if(isSccuess){
             
             [Single updateWithMoneyModel]; //更新用户钱的数据
             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"充值成功" message:[NSString stringWithFormat:@"你成功充值%@元",money] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [alertView show];
         }else{
             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"支付失败" message:@"您取消了充值" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [alertView show];
         }
     }];
 
}


-(void)setup{
  
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 100.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.masksToBounds = YES;
    button.enabled = NO;
    button.layer.cornerRadius = 4.0f;
    [button setBackgroundImage:[UIImage imageWithColor:colorWithHex(@"#CACACA")] forState:UIControlStateDisabled];
    [button setBackgroundImage:[UIImage imageWithColor:colorWithHex(@"#00B2DD")] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(topUpButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"确定充值" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footerView.mas_centerX);
        make.centerY.mas_equalTo(footerView.mas_centerY);
        make.left.mas_equalTo(10.0);
        make.right.mas_equalTo(-10.0);
        make.height.mas_equalTo(40.0f);
    }];
    
    self.comButton = button;
    

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1){
        return 2;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


     static NSString *_indetiferi = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_indetiferi];
    UITextField *textFiled = [cell.contentView viewWithTag:9909];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:_indetiferi];
        if(!textFiled){
            textFiled = [[UITextField alloc]initWithFrame:CGRectMake(70, 0, IPHONE_WIDTH - 6, cell.height)];
            textFiled.placeholder = @"请输入充值金额";
            textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
            textFiled.delegate = self;
            textFiled.tag = 9909;
            [cell.contentView addSubview:textFiled];
            [textFiled addTarget:self action:@selector(textFieldChane:) forControlEvents:UIControlEventEditingChanged];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    _textFiled = textFiled;
    
    
     cell.accessoryType = UITableViewCellAccessoryNone;
    if(indexPath == _indexPath)
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    switch (indexPath.section) {
        case 0:
        {
            _textFiled.hidden = NO;
            cell.imageView.hidden = YES;
            cell.textLabel.text = @"金额";
        
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 1:
                {
                    cell.imageView.image = imageNamed(@"alipay_Logo_icon");
                    cell.imageView.hidden = NO;
                    _textFiled.hidden = YES;
                    cell.textLabel.text = @"支付宝";
                }
                    break;
                case 0:
                {
                    
                    cell.imageView.image = imageNamed(@"weiLogo");
                    cell.imageView.hidden = NO;
                    _textFiled.hidden = YES;
                    cell.textLabel.text = @"微信";
                    
                }
                    break;
                    
                default:
                    break;
            }
         
            
        }
            break;
    
            //
    
        default:
            break;
    }
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==1){
        _indexPath = indexPath;
        [tableView reloadData];
    }
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
   
    if([string isEqualToString:@"."] && [textField.text rangeOfString:@"."].location != NSNotFound)
        return NO;
    
    BOOL canChange = [string isEqualToString:filtered];
    
    if(string.length > 0 && textField.text.length == 5)
        return NO;
    
    return canChange;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldChane:(UITextField *)textField{
   
    self.priceString = textField.text;
    self.comButton.enabled = textField.text.length;
}

@end
