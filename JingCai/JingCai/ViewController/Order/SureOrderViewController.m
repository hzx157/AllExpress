//
//  SureOrderViewController.m
//  JingCai
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SureOrderViewController.h"
#import "ConsigneeInfoCell.h"
#import "SureOderShopCell.h"
#import "ChooseAddressViewController.h"
#import "AddressModel.h"
#import "PayModel.h"
#import "OrderModel.h"
#import "UIAlertView+Block.h"
#import "OrderPaySheet.h"
#import "JCPayViewController.h"
@interface SureOrderViewController ()

@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, weak) UILabel *footerLbl;//产品总数
@property (nonatomic, strong) AddressModel*addressModel;//地址
@property (nonatomic,  weak) UIButton *sureBtn; //结算

@end

@implementation SureOrderViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
 
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"确认订单";
    self.view.backgroundColor = RGB(241, 241, 241);
    
    [self setSubviews];
}

- (void)setSubviews
{
    self.tableViewStyle = UITableViewStylePlain;
    self.tableView.frame = CGRectMake(0, IOS7_TOP_Y, IPHONE_WIDTH, IPHONE_HEIGHT-IOS7_TOP_Y - 50);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH - 10, 40)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentRight;
    //label.text = [NSString stringWithFormat:@"共%ld件产品",(long)self.carModel.snum];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 40)];
    [footerView addSubview:label];
    _footerLbl = label;

    self.tableView.tableFooterView = footerView;
    [self.view addSubview:self.bottomBar];
    
    [ChooseAddressViewController getDefaultAddress:^(AddressModel *model) {
        if (model) {
            _sureBtn.enabled = YES;
            self.addressModel = model;
            [self.tableView reloadData];
        }else{
            
              [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                  if(buttonIndex == 1)
                  [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
              } title:@"您还未设置收货地址" message:nil cancelButtonName:@"取消" otherButtonTitles:@"设置", nil];
            _sureBtn.enabled = NO;
        }
    }];
    [self calculate];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }else if (section == 1) {
        
        return self.dataSoureArray.count;
    }else {
        
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }else if(indexPath.section == 1) {
        return 170;
    }else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *ID = @"congineeCell";
        ConsigneeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[ConsigneeInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.addressModel = self.addressModel;
        return cell;
    }else if (indexPath.section == 1) {
        
        static NSString *ID = @"shopInfoCell";
        SureOderShopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[SureOderShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        cell.indexPath = indexPath;
        cell.carModel = self.dataSoureArray[indexPath.row];
        WEAKSELF;
        [cell setCountBlock:^(NSIndexPath *indexPath, ShopCarModel *carModel) {
            [weakSelf.dataSoureArray replaceObjectAtIndex:indexPath.row withObject:carModel];
            [weakSelf.tableView reloadData];
             [weakSelf calculate];
        }];
        return cell;
    }else if (indexPath.section == 2) {
        
        static NSString *ID = @"numCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        
        UIView *view1 = [cell viewWithTag:999];
        [view1 removeFromSuperview];
        UIView *view2 = [cell viewWithTag:909];
        [view2 removeFromSuperview];
        UIView *view3 = [cell viewWithTag:908];
        [view3 removeFromSuperview];
        
        if (indexPath.row == 0) {
            UILabel *styleLbl = [[UILabel alloc] init];
            styleLbl.frame = CGRectMake(10, 0, IPHONE_WIDTH - 20, 50);
            styleLbl.textColor = [UIColor blackColor];
            styleLbl.font = [UIFont systemFontOfSize:14];
            styleLbl.text = @"配送方式：快递";
            styleLbl.tag = 999;
            [cell addSubview:styleLbl];

        }else {
            UILabel *messageLbl = [[UILabel alloc] init];
            messageLbl.frame = CGRectMake(10, 0, 70, 50);
            messageLbl.textColor = [UIColor blackColor];
            messageLbl.font = [UIFont systemFontOfSize:14];
            messageLbl.text = @"买家留言：";
            messageLbl.tag = 909;
            [cell addSubview:messageLbl];
            
            UITextField *textfield = [[UITextField alloc] init];
            textfield.frame = CGRectMake(messageLbl.right, 0, IPHONE_WIDTH - 85, 50);
            textfield.textColor = [UIColor blackColor];
            textfield.font = [UIFont systemFontOfSize:14];
            textfield.tag = 908;
            textfield.returnKeyType = UIReturnKeyGo;
            [cell addSubview:textfield];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ChooseAddressViewController *addVC = [[ChooseAddressViewController alloc] init];
        [addVC setBlock:^(AddressModel *address) {
            self.addressModel = address;
            [self.tableView reloadData];
             self.sureBtn.enabled = YES;
        }];
        [self.navigationController pushViewController:addVC animated:YES];
    }
}

- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, IPHONE_HEIGHT - 40, IPHONE_WIDTH, 40)];
        UILabel *countLbl = [[UILabel alloc] init];
        countLbl.frame = CGRectMake(0, 0, IPHONE_WIDTH * 0.66, _bottomBar.height);
        countLbl.backgroundColor = [UIColor blackColor];
        countLbl.font = [UIFont systemFontOfSize:13];
        countLbl.textAlignment = NSTextAlignmentCenter;
        countLbl.textColor = [UIColor whiteColor];
        countLbl.tag = 123;
        countLbl.text = @"合计：0.00";
        [_bottomBar addSubview:countLbl];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(countLbl.right, 0, IPHONE_WIDTH * 0.34, _bottomBar.height);
        sureBtn.backgroundColor = [UIColor redColor];
        [sureBtn setTitle:@"确认订单" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureBtnAcion:) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        sureBtn.tag = 897;
        [_bottomBar addSubview:sureBtn];
        _sureBtn = sureBtn;
    }
    return _bottomBar;
}


//计算产品
-(void)calculate{
  
    CGFloat pri = 0.00f;
    NSInteger num = 0;
    for(ShopCarModel *model in self.dataSoureArray){
        num += model.snum;
        pri += ([model.sprice floatValue] * model.snum);
    }
  
    UILabel *label = [_bottomBar viewWithTag:123];
    label.text = [NSString stringWithFormat:@"合计：%.2f",pri];
    _footerLbl.text = [NSString stringWithFormat:@"共%ld件产品",(long)num];
    
    if([LoginModel shareLogin].roleId == roleTypeAgent){
        
        label.text =[NSString stringWithFormat:@"合计:%.2f 合作商合计:%.2f",pri,pri/2];
        NSMutableAttributedString *attsring = [[NSMutableAttributedString alloc]initWithString:label.text];
        [attsring addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid) range:[label.text rangeOfString:[NSString stringWithFormat:@"合计:%.2f",pri]]];
        [attsring addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[label.text rangeOfString:[NSString stringWithFormat:@"合计:%.2f",pri]]];
        label.attributedText = attsring;
      
    }
    
}

- (void)sureBtnAcion:(UIButton *)sender
{
    
    if(self.addressModel.address_id == 0){
        [UIView show_fail_progress:@"请选择收货地址"];
        return;
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for(ShopCarModel *model in self.dataSoureArray){
        
       if(model.snum == 0)
           continue;
        
        NSDictionary *dict = @{@"buyNum":@(model.snum),
                               @"skuId":@(model.skuId)};
        [array addObject:dict];
    }
    
 
    NSString *addId = [NSString stringWithFormat:@"%ld",self.addressModel.address_id];
    
    [UIView show_loading_progress:@"正在下单，请稍后..."];
    [[RequestClient sharedClient] order_sure_addressId:addId orderJson:[array mj_JSONString] progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, JCRespone *respone) {
        
    
        [UIView dismiss_progress];
        if(self.successBlock)
        self.successBlock(self.dataSoureArray);
        
        JCPayViewController *pay = [JCPayViewController new];
        pay.model = [OrderModel mj_objectWithKeyValues:respone.data];
        [self.navigationController pushViewController:pay animated:YES];
        
 
        
        /*
        OrderPaySheet *paySheet = [[OrderPaySheet alloc]init];
        [paySheet show:[Common getNULLString:respone.data[@"money"]] block:^(BOOL isSccuess) {
            
            if(!isSccuess){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self leftBtnAction:nil];
                });
               
                return ;
            }
            
            [UIView show_loading_progress:@"下单中.."];
            [self payBookId:[Common getNULLString:respone.data[@"bookingId"]] money:[Common getNULLString:respone.data[@"money"]]];
            
        }];
    */
        
        
     
  
       // DLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error, JCRespone *respone) {
        [UIView show_fail_progress:@"提交失败。"];
        DLog(@"error");
    }];
}






@end
