//
//  TopUpViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "JCPayViewController.h"
#import "UIImage+Color.h"
#import "PayModel.h"
#import "AutoCodeButton.h"
@interface JCPayViewController()<UITextFieldDelegate>{
    
    NSIndexPath *_indexPath;  //选择支付宝，微信
    NSIndexPath *_yuIndexPath; //余额
}

@property (nonatomic,weak)UITextField *textFiled;
@property (nonatomic,weak)UIButton *comButton;
@property (nonatomic,assign)BOOL isRole;//是否成为代言人

//@property (nonatomic,copy)NSString *priceString;


@end
@implementation JCPayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付订单";
    
    _isRole = self.money>0.00;
    
    self.tableViewStyle = UITableViewStyleGrouped;
    _yuIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView reloadData];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 5)];
    [self setup];
    
}

///充值
-(void)topUpButton:(id)sender{
    
    if(_isRole){
     
        [self rolePay:[NSString stringWithFormat:@"%.2f",self.money]];
        return;
    }
    
    [self aliPay:[NSString stringWithFormat:@"%.2f",self.model.money]];
    //[self leftBtnAction:nil];
    
}
#pragma mark ------代言人支付 ------

-(void)rolePay:(NSString *)str{
  [OrderModel payRoleMoney:str toPayModelType:_indexPath.row roleType:self.type toYu:_yuIndexPath success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
      [self leftBtnAction:nil];
      
      [UIView show_success_progress:respone.msg];
  } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        [UIView show_fail_progress:respone.msg];
  }];
}
#pragma mark ------订单支付 ------
-(void)aliPay:(NSString *)str{
    
    [OrderModel setValicode:_textFiled.text];
    [OrderModel payBookId:[NSString stringWithFormat:@"%ld",(long)self.model.bookingId] money:str toPayModelType:_indexPath.row toYu:_yuIndexPath success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        [UIView show_success_progress:@"订单已提交。"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self leftBtnAction:nil];
        });
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        ;
    }];
    
    
}


-(void)setup{
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 100.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.masksToBounds = YES;
    button.enabled = _isRole;
    button.layer.cornerRadius = 4.0f;
    [button setBackgroundImage:[UIImage imageWithColor:colorWithHex(@"#CACACA")] forState:UIControlStateDisabled];
    [button setBackgroundImage:[UIImage imageWithColor:colorWithHex(@"#00B2DD")] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(topUpButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:[NSString stringWithFormat:@"确定支付 ￥%.2f",_isRole ? self.money:self.model.money]forState:UIControlStateNormal];
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
    
    if(_isRole)
        return 2;
    
    
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:{
            
            return 1;
        }
            break;
            
        default:
            break;
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
            textFiled = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, IPHONE_WIDTH - 6, cell.height)];
            textFiled.placeholder = @"请输入收到的验证码";
            textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
            textFiled.font = fontSystemOfSize(16.0);
            textFiled.delegate = self;
            textFiled.tag = 9909;
            textFiled.rightViewMode = UITextFieldViewModeAlways;
           
            [cell.contentView addSubview:textFiled];
            [textFiled addTarget:self action:@selector(textFieldChane:) forControlEvents:UIControlEventEditingChanged];
            //获取验证码按钮
             UITextField*phoneTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            phoneTextFiled.text = [LoginModel shareLogin].phone;
            phoneTextFiled.hidden = YES;
            [cell.contentView addSubview:phoneTextFiled];
            AutoCodeButton *authCodeBtn = [AutoCodeButton buttonWithType:UIButtonTypeCustom];
            authCodeBtn.textField = phoneTextFiled;
            authCodeBtn.isReisgter = YES;
            authCodeBtn.frame = CGRectMake(0, 0, 80, cell.height);
            [authCodeBtn setTitle:@"获取验证码" forState:0];
            [authCodeBtn setTitleColor:[UIColor grayColor] forState:0];
            authCodeBtn.alpha = 0.6;
            textFiled.rightView = authCodeBtn;
           
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    _textFiled = textFiled;
    
    cell.textLabel.hidden = YES;
    cell.imageView.hidden = YES;
    _textFiled.hidden = YES;
    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    if(indexPath == _indexPath)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    if(indexPath == _yuIndexPath)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    switch (indexPath.section) {
            
        case 0:{
           cell.textLabel.hidden = NO;
            cell.textLabel.text = [NSString stringWithFormat:@"账户余额:%.2f",SINGLE.moneyModel.useMoney];
        }
            break;
        case 2:
        {
            _textFiled.hidden = NO;
          
        }
            break;
        case 1:
        {
            cell.textLabel.hidden = NO;
            
            
            switch (indexPath.row) {
                case 1:
                {
                    cell.imageView.image = imageNamed(@"alipay_Logo_icon");
                    cell.imageView.hidden = NO;
                    cell.textLabel.text = @"支付宝";
                }
                    break;
                case 0:
                {
                    
                    cell.imageView.image = imageNamed(@"weiLogo");
                    cell.imageView.hidden = NO;
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==1){
        _indexPath = indexPath;
    
    }else if (indexPath.section == 0){
        
       if(_yuIndexPath)
           _yuIndexPath = nil;
        else
            _yuIndexPath = indexPath;
    }
        [tableView reloadData];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldChane:(UITextField *)textField{
    
//    self.priceString = textField.text;
    self.comButton.enabled = textField.text.length;
}

@end
