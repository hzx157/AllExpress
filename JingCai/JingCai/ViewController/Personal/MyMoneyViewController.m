//
//  MyMoneyViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyMoneyViewController.h"
#import "DrawalViewController.h"
#import "TopUpViewController.h"
#import "PaymentViewController.h"
#import "MoneyModel.h"
@interface MyMoneyViewController ()
@property (nonatomic,copy)NSArray *titleArray;
@property (nonatomic,weak) UILabel *priceLabel;
@end

@implementation MyMoneyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"我的余额";
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.rowHeight = 44.0f;
    _titleArray = @[@"提现",@"充值",@"收入明细"];
    [self setupHeadView];
    [self getData];
    
}
-(void)viewWillAppear:(BOOL)animated{
 
    [super viewWillAppear:animated];
     self.priceLabel.text = [NSString stringWithFormat:@"%.2f元",SINGLE.moneyModel.useMoney];
}

-(void)getData{

     [[RequestClient sharedClient]user_account_info_progress:^(NSProgress *uploadProgress) {
         ;
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
         
        
         MoneyModel *model = [MoneyModel mj_objectWithKeyValues:respone.data];
         SINGLE.moneyModel = model;
         [MoneyModel saveToDB:model where:nil];
          self.priceLabel.text = [NSString stringWithFormat:@"%.2f元",model.useMoney];
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
         
         [UIView show_fail_progress:respone.msg];
         
     }];
}

-(void)setupHeadView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 140.0f)];
    view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = view;
    
    UILabel *priceLabel = [UILabel new];
    priceLabel.text = @"0.00元";
    priceLabel.font = fontSystemOfSize(18.0);
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:priceLabel];
    _priceLabel = priceLabel;
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.centerY.mas_equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(200.0, 60.0));
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indetifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
    if(!cell){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indetifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    cell.textLabel.font = fontSystemOfSize(15.0);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
//            if(self.aModel.useMoney < 1){
//                
//                [UIView show_fail_progress:@"金额小于1元"];
//                return;
//            }
            
            DrawalViewController *walView = [DrawalViewController new];
            [self.navigationController pushViewController:walView animated:YES];
        }
            break;
        case 1:{
            TopUpViewController *walView = [TopUpViewController new];
            [self.navigationController pushViewController:walView animated:YES];
        
        }
            break;
        case 2:
        {
            PaymentViewController *view = [PaymentViewController new];
            [self.navigationController pushViewController:view animated:YES];
         
        }
            break;
            
        default:
            break;
    }
    
}

@end
