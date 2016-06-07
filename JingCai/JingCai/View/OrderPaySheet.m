//
//  OrderPaySheet.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OrderPaySheet.h"
@interface OrderPaySheet()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,copy)NSArray *titleArray;
@property (nonatomic,copy)NSString *money;
@property (nonatomic,copy)backBlock block;
@end
@implementation OrderPaySheet


-(instancetype)init{
 
    if(self = [super init]){
        self.frame = [[[[UIApplication sharedApplication] delegate] window] bounds];
        [self setup];
    }
    return self;
}

-(void)show:(NSString *)money block:(backBlock)block{
   
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    self.block = block;
    self.money = money;
      [UIView animateWithDuration:0.25 animations:^{
          
          self.tableView.bottom = IPHONE_HEIGHT;
         
      } completion:^(BOOL finished) {
          ;
      }];
    
}
-(void)dis{
    
    if(self.block)
        self.block(NO);
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.top = IPHONE_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)actionButton{
  
    [self showAler:NO];
  
    
    
}
-(void)setup{
   
    
    
   self.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5];
    self.titleArray = @[@"产品总价",@"账户余额",@"需充值"];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, IPHONE_HEIGHT, IPHONE_WIDTH, 44*4 + 100.0) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = NO;
    [self addSubview:tableView];
    self.tableView = tableView;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 44.0)];
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    label.font = fontSystemOfSize(15.0f);
    label.backgroundColor = [UIColor clearColor];
    label.text = @"订单支付详情";
    tableView.tableHeaderView = label;
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:imageNamed(@"delete_clear") forState:UIControlStateNormal];
    cancelButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cancelButton.userInteractionEnabled = YES;
    [cancelButton addTarget:self action:@selector(dis) forControlEvents:UIControlEventTouchUpInside];
    [label addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0.0f);
        make.width.mas_equalTo(40.0);
    }];
    
    
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 70.0)];
    footerView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = footerView;
    
    UIButton *outButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [outButton setBackgroundColor:[UIColor redColor]];
    outButton.alpha = 0.7;
    outButton.layer.masksToBounds = YES;
    outButton.layer.cornerRadius = 5.0f;
    [outButton setTitle:@"下单支付" forState:UIControlStateNormal];
    outButton.titleLabel.font = fontSystemOfSize(15.0);
    [outButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    outButton.frame = CGRectMake(20, 20.0, IPHONE_WIDTH-40, 40.0);
    [footerView addSubview:outButton];
    [outButton addTarget:self action:@selector(actionButton) forControlEvents:UIControlEventTouchUpInside];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
     static NSString *_indetifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_indetifer];
    if(!cell){
     
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:_indetifer
                 ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = fontSystemOfSize(15.0);
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.detailTextLabel.text = self.money;
        }
            break;
        case 1:
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",SINGLE.moneyModel.useMoney];
        }
            break;
        case 2:
        {
            CGFloat mackk = 0.0;
            mackk = SINGLE.moneyModel.useMoney >= [self.money floatValue] ? 0.0 : [self.money floatValue] - SINGLE.moneyModel.useMoney;
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",mackk];
        }
            break;
            
            
        default:
            break;
    }
    
    
    cell.detailTextLabel.text = [@"￥" stringByAppendingString:cell.detailTextLabel.text];
    
    return cell;
    
}
-(void)showAler:(BOOL)agn{
 
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.top = IPHONE_HEIGHT;
    } completion:^(BOOL finished) {
        
    }];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入登录密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alertView show];
    if(agn){
        alertView.title = @"密码错误，请重新输入";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [alertView CABasicAnimation];
        });
      
    
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if(buttonIndex == 0){
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.bottom = IPHONE_HEIGHT;
        } completion:^(BOOL finished) {
            
        }];
    }else{
      
        UITextField *textField = [alertView textFieldAtIndex:0];
        if([textField.text isEqualToString:[LoginModel shareLogin].pass]){
            if(self.block)
                self.block(YES);
            self.block = nil;
            [self dis];
        }else{
           
            [self showAler:YES];
            
        }
        
    }
    
}

@end
