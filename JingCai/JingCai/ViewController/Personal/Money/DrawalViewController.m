//
//  DrawalViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DrawalViewController.h"
#import "UIImage+Color.h"
@interface DrawalViewController ()<UITextFieldDelegate>
@property (nonatomic,weak)UITextField *textFiled;
@property (nonatomic,weak)UIButton *comButton;

@property (nonatomic,copy)NSArray *titleArray;
@property (nonatomic,copy)NSArray *placeholderArray;

@property (nonatomic,weak)UIButton *wxButton;
@property (nonatomic,weak)UIButton *aliButton;
@end

@implementation DrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    
    self.tableViewStyle = UITableViewStyleGrouped;
    [self setup];
}
-(void)setup{
    
    self.titleArray = @[@"提现金额:",@"提现账号:",@"账号姓名:"];
    self.placeholderArray = @[@"请输入提现金额(不能小于1元)",@"请输入提现账号",@"请输入提现账号真实姓名"];
    [self header];
    [self footer];
}
-(void)header{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 60.0)];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = view;
    
    UIButton *aliButton = [self ini_button:111 title:@"支付宝"];
    UIButton *wxButton = [self ini_button:222 title:@"微信"];
    [view addSubview:aliButton];
    [view addSubview:wxButton];
    
    aliButton.selected = YES;
    wxButton.frame = aliButton.frame = CGRectMake(60.0, 10, 100, 40.0);
    wxButton.left = aliButton.right;
    
    _wxButton = wxButton;
    _aliButton = aliButton;
    
    
}
-(void)sButtonAction:(UIButton *)button{
    
   _wxButton.selected = !_wxButton.selected;
   _aliButton.selected = !_aliButton.selected;
    
}
-(UIButton *)ini_button:(NSInteger)tag title:(NSString *)title{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = fontSystemOfSize(16.0);
    [button setImage:imageNamed(@"adresssChoose_normal_icon") forState:UIControlStateNormal];
    [button setImage:imageNamed(@"select_icon") forState:UIControlStateSelected];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -17, 0, 0);
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    return button;
    
    
}
-(void)footer{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 100.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.masksToBounds = YES;
    button.enabled = NO;
    button.layer.cornerRadius = 4.0f;
    [button setBackgroundImage:[UIImage imageWithColor:colorWithHex(@"#CACACA")] forState:UIControlStateDisabled];
    [button setBackgroundImage:[UIImage imageWithColor:colorWithHex(@"#00B2DD")] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"确定提现" forState:UIControlStateNormal];
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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}
-(void)rightBtnAction:(id)sender{
    
    [self.view endEditing:YES];
    
    if(![self isSccuess]){
        [UIView show_fail_progress:@"请填写所有信息"];
        return;
    }
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    for(UITableViewCell * cell in self.tableView.visibleCells){
        
        for(UIView *view in cell.contentView.subviews){
            if([view isKindOfClass:[UITextField class]]){
                
                UITextField *textFiled = (UITextField *)view;
                DLog(@"te = %@",textFiled.text);
                switch (textFiled.tag) {
                    case 9909:
                    {
                        if(SINGLE.moneyModel.useMoney < [textFiled.text floatValue]){
                            
                            [UIView show_fail_progress:@"您的账户余额不足"];
                           // [UIView show_fail_progress:[NSString stringWithFormat:@"提现金额不能大于%.2f",SINGLE.moneyModel.useMoney]];
                            return;
                        }
                        [dict setObject:textFiled.text forKey:@"money"];
                    }
                        break;
                    case 9910: //账号
                    {
                       [dict setObject:textFiled.text forKey:@"cardNo"];
                        
                    }
                        break;
                    case 9911: //姓名
                    {
                        
                         [dict setObject:textFiled.text forKey:@"realName"];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
        }
        
        
    }
    
    [dict setObject:_aliButton.selected ? @"2":@"3" forKey:@"cardType"];
     [dict setObject:@"提现" forKey:@"remark"];
    [self request:dict];
  
}
-(void)request:(NSDictionary *)dic{
 
    [UIView show_loading_progress_HUDMaskType:@"请求中..."];
    [[RequestClient sharedClient]user_mony_tix:dic progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        [Single updateWithMoneyModel];
        [UIView show_success_progress:respone.msg];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self leftBtnAction:nil];
        });
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        [UIView show_fail_progress:respone.msg];
    }];
}
-(BOOL)isSccuess{
   
    for(UITableViewCell * cell in self.tableView.visibleCells){
     
        for(UIView *view in cell.contentView.subviews){
            if([view isKindOfClass:[UITextField class]]){
                
                UITextField *textFiled = (UITextField *)view;
                if(textFiled.text.length <=0){
                    return NO;
                }
                
            }
        }
        
        
    }
    return YES;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indetiferi = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetiferi];
    UITextField *textFiled = [cell.contentView viewWithTag:9909+indexPath.row];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indetiferi];
        if(!textFiled){
            textFiled = [[UITextField alloc]initWithFrame:CGRectMake(5.0, 0, IPHONE_WIDTH - 10, cell.height)];
            textFiled.placeholder = self.placeholderArray[indexPath.row];
            textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
            textFiled.leftViewMode = UITextFieldViewModeAlways;
            UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100.0, cell.height)];
            textLabel.font = fontSystemOfSize(15.0);
            textLabel.text = self.titleArray[indexPath.row];
            textFiled.leftView = textLabel;
            textFiled.delegate = self;
            textFiled.tag = 9909 +indexPath.row;
            textFiled.font = fontSystemOfSize(15.0);
            [cell.contentView addSubview:textFiled];
            [textFiled addTarget:self action:@selector(textFieldChane:) forControlEvents:UIControlEventEditingChanged];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
 //   _textFiled = textFiled;
    
    
    return cell;
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
       if(textField.tag != 9909)
           return YES;
    
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
    
    self.comButton.enabled = [self isSccuess];
}

@end
