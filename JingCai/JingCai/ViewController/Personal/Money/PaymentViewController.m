//
//  PaymentViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PaymentViewController.h"
#import "PaymentModel.h"
#import "OrderSelectView.h"
@interface PaymentViewController()

@end
@implementation PaymentViewController

-(void)viewDidLoad{
   
    [super viewDidLoad];
    self.title = @"收支明细";
    self.tableViewStyle = UITableViewStylePlain;
    self.tableView.rowHeight = 55.0f;
    [self data];
    [self.tableView hzxAddLegendHeaderWithRefreshingBlock:^{
        self.pageNo = 1;
        [self data];
    }];
    [self.tableView hzxAddLegendFooterWithRefreshingBlock:^{
        self.pageNo ++;
        [self data];
    }];
    
}
-(void)data{
   
    [[RequestClient sharedClient]user_paymanet_list_pagesize:kPageSize pageno:self.pageNo progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        if(self.pageNo == 1){
         
            [self.tableView hzxHeaderEndRefreshing];
            [self.dataSoureArray removeAllObjects];
        }else{
          
            [self.tableView hzxFooterEndRefreshing];
        }
        
        
        NSArray *array = respone.data[@"list"];
        [self.dataSoureArray addObjectsFromArray:[PaymentModel mj_objectArrayWithKeyValuesArray:array]];
        [self.tableView hzxHiddenFooter:!(array.count == kPageSize)];
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        [UIView show_fail_progress:respone.msg];
        if(self.pageNo == 1){
            [self.tableView hzxHeaderEndRefreshing];
        }else{
            
            [self.tableView hzxFooterEndRefreshing];
        }
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return self.dataSoureArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
     static NSString *_indetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_indetifier];
    
    UILabel * moneyLabel = [cell.contentView viewWithTag:indexPath.row + 100];
     UILabel * nameLabel = [cell.contentView viewWithTag:indexPath.row + 10000];
    if(!cell){
     
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_indetifier];
        cell.textLabel.font = fontSystemOfSize(16.0f);
        cell.detailTextLabel.font = fontSystemOfSize(12.0f);
        cell.textLabel.textColor = cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        
        moneyLabel = [[UILabel alloc]init];
        moneyLabel.tag = indexPath.row + 100;
        moneyLabel.textColor = [UIColor greenColor];
        [cell.contentView addSubview:moneyLabel];
        
        
        nameLabel = [[UILabel alloc]init];
        nameLabel.tag = indexPath.row + 10000;
        nameLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:nameLabel];
        
         nameLabel.font = moneyLabel.font = fontSystemOfSize(14.0);
         nameLabel.textAlignment = moneyLabel.textAlignment = NSTextAlignmentRight;
        
          [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
              make.right.mas_equalTo(-10.0f);
              make.top.mas_equalTo(cell.textLabel.mas_top);
              make.height.mas_equalTo(cell.textLabel.mas_height);
              make.width.mas_equalTo(200.0);
          }];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(moneyLabel.mas_right);
            make.top.mas_equalTo(cell.detailTextLabel.mas_top);
            make.height.mas_equalTo(cell.detailTextLabel.mas_height);
            make.width.mas_equalTo(200.0);
        }];
        
    }
    
    PaymentModel *model = self.dataSoureArray[indexPath.row];
    
    cell.textLabel.text = [Common getNULLString:[self getBookingType:model.bookingType]];//updateTime
    cell.detailTextLabel.text = [self stringFromTimeInterval:[NSString stringWithFormat:@"%ld",(long)model.createTime]];
    
    nameLabel.text = [Common getNULLString:[self getBookingstuatus:model.status]];//[Common getNULLString:model.contact];
    
    
    if(model.fundType ==0){ //支出
          moneyLabel.textColor =  ColorWithRGB(225, 46, 39.0, 1.0);
        moneyLabel.text = [NSString stringWithFormat:@"-%0.2f",model.money];
    }else{
   
         moneyLabel.textColor =  ColorWithRGB(78, 171, 14, 1.0);
        moneyLabel.text = [NSString stringWithFormat:@"+%0.2f",model.money];
    }
    
    
    return cell;
}
- (NSString *)stringFromTimeInterval:(NSString *)timeInterval
{
#define DKormat @"yyyy-MM-dd HH:mm"
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeInterval longLongValue]/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DKormat];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return [Common getNULLString:destDateString];//updateTimedestDateString;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString *)getBookingType:(NSString *)type{
  
    switch ([type integerValue]) {
        case 1:
            return @"充值";
            break;
        case 2:
            return @"提现";
            break;
        case 3:
            return @"购物";
            break;
        case 4:
            return @"购物返利";
            break;
        case 5:
            return @"返利收入";
            break;
        case 6:
            return @"入会";
            break;
        case 7:
            return @"入会返利";
            break;
        case 8:
            return @"退款收入";
            break;
        case 9:
            return @"业绩返利";
            break;
        case 10:
            return @"充值返利";
            break;
        case 11:
            return @"补差价";
            break;
            
        default:
            break;
    }
    return @"购物";
    
}
-(NSString *)getBookingstuatus:(NSString *)type{
    
    switch ([type integerValue]) {
        case OrderTypeAll:
            return @"产生订单";
            break;
        case 2:
            return @"等待付款";
            break;
        case 3:
            return @"失败";
            break;
        case 4:
            return @"提现申请";
            break;
        case 5:
            return @"成功";
            break;
        case 6:
            return @"等待发货";
            break;
        case 7:
            return @"换货申请";
            break;
        case 8:
            return @"待收货";
            break;
        case 9:
            return @"退款申请";
            break;
        case 10:
            return @"订单关闭";
            break;
        case 11:
            return @"同意退款";
            break;
        case 12:
            return @"已收货";
            break;
        case 13:
            return @"同意换货";
            break;
            
        default:
            break;
    }
    return @"购物";
    
}

@end
