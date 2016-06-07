//
//  VipViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/6/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "VipViewController.h"
#import "UIAlertView+Block.h"
#import "JCPayViewController.h"
#import "DrawalViewController.h"
#import "TopUpViewController.h"
#import "PaymentViewController.h"
@interface VipViewController()
@property (nonatomic,copy)NSArray *sectionArray;
@property (nonatomic,copy)NSArray *detailArray;
@property (nonatomic,copy)NSArray *imgArray;
@end
@implementation VipViewController


-(void)viewDidLoad{

    [super viewDidLoad];
    self.title = @"代言人";
    self.leftBtn.hidden = YES;
    [self setup];

}
-(void)viewWillAppear:(BOOL)animated{
 
    [super viewWillAppear:animated];
    [self setupSetion];
}
-(void)setup{
 
    self.leftBtn.hidden = YES;
    self.tableViewStyle = UITableViewStyleGrouped;
//    self.tableView.left = 18.0f;
//    self.tableView.width = IPHONE_WIDTH - 36.0f;
    self.tableView.rowHeight = 60;
    
    NSArray *array = @[@[@"充值",@"提现",@"收入明细"],@[@"成为代言人",@"成为合作商"]];
    [self.dataSoureArray addObjectsFromArray:array];
    
    _imgArray = @[@[@"money_cz",@"money_tx",@"money_detail"],@[@"vip_name",@"vip_hz"]];
    _detailArray = @[@[@"",@"",@""],@[@"支付16.8即可成为晶彩代言人",@"合作商拿货轻松打半价"]];
    [self setupSetion];
    [self getData];
}
-(void)setupSetion{
   
    NSString *str = [NSString stringWithFormat:@"当前身份:%@",[LoginModel getRoleName]];
    NSString *str1 = [NSString stringWithFormat:@"余额:%.2f",SINGLE.moneyModel.useMoney];
    _sectionArray = @[str1,str];
    [self.tableView reloadData];
}

-(void)getData{
    
    [[RequestClient sharedClient]user_account_info_progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        
        
        MoneyModel *model = [MoneyModel mj_objectWithKeyValues:respone.data];
        SINGLE.moneyModel = model;
        [MoneyModel saveToDB:model where:nil];
        [self setupSetion];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        
        [UIView show_fail_progress:respone.msg];
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
    return _sectionArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.dataSoureArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *intiferi = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:intiferi];
    if(!cell){
      
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:intiferi];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
//        cell.layer.cornerRadius = 4.0f;
//        cell.layer.masksToBounds = YES;
        cell.textLabel.numberOfLines = 3;
    }
    cell.imageView.image = imageNamed(_imgArray[indexPath.section][indexPath.row]);
    cell.textLabel.text = self.dataSoureArray[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = _detailArray[indexPath.section][indexPath.row];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    switch (indexPath.section) {
        case 1:
            return 60.0;
            break;
            
        default:
            break;
    }
    return 44.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 40.0f)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(13, 12, view.width, 28);
    label.textColor = [UIColor darkGrayColor];
    label.font = fontSystemOfSize(15.0);
    label.text = _sectionArray[section];
    [view addSubview:label];
    return view;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hiddenTabBar];
    switch (indexPath.section) {
        case 1:
        {
            
            if(indexPath.row == 0){
                if([LoginModel shareLogin].roleId > roleTypeNormal){
                    [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                        ;
                    } title:@"您已经拥有这个权限,无需开次开通" message:nil cancelButtonName:@"确定" otherButtonTitles:nil, nil];
                    return;
                }
                CGFloat money = 16.8;
                
                [self setOpen:roleTypeSpokesman money:money];
                
            }else{
                if([LoginModel shareLogin].roleId > roleTypeSpokesman){
                    [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                        ;
                    } title:@"您已经拥有这个权限,无需开次开通" message:nil cancelButtonName:@"确定" otherButtonTitles:nil, nil];
                    return;
                }
                CGFloat money = 10016.8;
                
                [self setOpen:roleTypeAgent money:[LoginModel shareLogin].roleId == roleTypeSpokesman ? 10000.0 : money];
            }
            
           
            
        }
            break;
        case 0:{
            switch (indexPath.row) {
                case 0:
                {
                    TopUpViewController *walView = [TopUpViewController new];
                    [self.navigationController pushViewController:walView animated:YES];
                    
                    
                }
                    break;
                case 1:{
                    
                    DrawalViewController *walView = [DrawalViewController new];
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
            break;
            
        default:
            break;
    }
    
}

-(void)setOpen:(roleType)type money:(CGFloat)money{
    
    JCPayViewController *pay = [JCPayViewController new];
    pay.money = money;
    pay.type = type;
    [self.navigationController pushViewController:pay animated:YES];
    
}

@end
