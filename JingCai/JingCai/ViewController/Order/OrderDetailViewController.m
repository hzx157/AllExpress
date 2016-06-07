//
//  OrderDetailViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "ConsigneeInfoCell.h"
#import "OrderDetailCell.h"
#import "ChooseAddressViewController.h"
#import "AddressModel.h"
#import "PayModel.h"
#import "OrderModel.h"
#import "UIAlertView+Block.h"
#import "OrderViewModel.h"
#import "OrderPaySheet.h"
#import "ExchangeGoodsViewController.h"
#import "CourierViewController.h"
#import "WriteExpressViewController.h"
@interface OrderDetailViewController ()

@property (nonatomic ,weak) UIButton *payBtn;
@property (nonatomic ,weak) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) AddressModel*addressModel;//地址
@property (nonatomic, strong) OrderModel*orderModel;//订单
@property (nonatomic,  weak) UIButton *sureBtn; //结算
@property (nonatomic, strong) NSMutableArray*orderDetailArray;//s
@end

@implementation OrderDetailViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"订单详情";
    self.view.backgroundColor = RGB(241, 241, 241);
    
    [self setSubviews];
    [self getData];
}
-(void)getData{
 
     [[RequestClient sharedClient]order_info_bookId:[NSString stringWithFormat:@"%ld",self.sid] progress:^(NSProgress *uploadProgress) {
         ;
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
         
         self.dataSoureDic = respone.data;
         self.addressModel = [AddressModel mj_objectWithKeyValues:[respone.data objectForKey:@"booking"]];
         self.orderModel = [OrderModel mj_objectWithKeyValues:[respone.data objectForKey:@"booking"]];
         self.orderDetailArray = [DetailListModel mj_objectArrayWithKeyValuesArray:(NSArray *)respone.data[@"bookDetail"]];
         [self subData:respone];
         [self.tableView reloadData];
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
         ;
     }];
    
    
}
-(void)subData:(JCRespone * )respone{
    
    [self.dataSoureArray removeAllObjects];
    //必须存在
    [self.dataSoureArray addObject:[NSString stringWithFormat:@"订单号码：%@",[Common getNULLString:[respone.data[@"booking"] objectForKey:@"outTradeNo"]]]];
    [self.dataSoureArray addObject:[NSString stringWithFormat:@"下单时间：%@",[self stringFromTimeInterval: [respone.data[@"booking"] objectForKey:@"createTime"]]]];
    //下面三个可能不存在
    [self.dataSoureArray addObject:[NSString stringWithFormat:@"支付时间：%@",[self stringFromTimeInterval: [respone.data[@"booking"] objectForKey:@"payTime"]]]];
    [self.dataSoureArray addObject:[NSString stringWithFormat:@"发货时间：%@",[self stringFromTimeInterval:[respone.data[@"booking"] objectForKey:@"receiptTime"]]]];
    [self.dataSoureArray addObject:[NSString stringWithFormat:@"确认时间：%@",[self stringFromTimeInterval:[respone.data[@"booking"] objectForKey:@"finishTime"]]]];
    
    OrderType type = [[respone.data[@"booking"] objectForKey:@"status"] integerValue];
    switch (type) {
          
         
        case OrderTypeClose://订单关闭10
        case OrderTypeWaitPay:{ //等待付款2
            [self.dataSoureArray removeObjectsAtIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 3)]];
        }
            break;
            
    
        case OrderTypeWaitSend: //等待发货6
        case OrderTypeApplyGoods:{ //11:退款申请（尚未发货，不需要填退货）
            [self.dataSoureArray removeObjectsAtIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 2)]];
        }
            break;
             case OrderTypeWaitRecive://等待收货 8
            case OrderTypeAgreeReturn:
            case OrderTypeRefusedurn:
            case OrderTypeRefusedGoods:
        case OrderTypeApplyReturnGoods:{ //退货退款申请   7
            [self.dataSoureArray removeObjectsAtIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(4, 1)]];
        }
            break;
            
        default:
            break;
    }
    
    //更新状态
    [OrderViewModel updateStausWithPayBtn:_payBtn toCancel:_cancelBtn toStaus:[UILabel new]  type:type];
   
}
- (NSString *)stringFromTimeInterval:(NSString *)timeInterval
{
  if([Common getNULLString:timeInterval].length <=0)
      return  @"";
 #define DKormat @"yyyy-MM-dd HH:mm"
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeInterval longLongValue]/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DKormat];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return [Common getNULLString:destDateString];
}


- (void)setSubviews
{
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH - 10, 40)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentRight;
 
    
    [self.view addSubview:self.bottomBar];
 
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }else if (section == 1) {
        
        return self.orderDetailArray.count + 1;
    }else {
        
        return self.dataSoureArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }else if(indexPath.section == 1) {
        if(indexPath.row == self.orderDetailArray.count)
        return 40.0f;
        return 100.0f;
    }else {
        return 30;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  
    return 8.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
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
        [cell setOrderDetailHide];
        return cell;
    }else if (indexPath.section == 1) {
        
        if(indexPath.row <= self.orderDetailArray.count-1 && self.orderDetailArray.count >0){
            static NSString *ID = @"shopInfoCell";
            OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.indexPath = indexPath;
            cell.aModel = self.orderModel;
            cell.model = self.orderDetailArray[indexPath.row];
            WEAKSELF;
            [cell setBlock:^(DetailListModel *model){ //退货申请
                [weakSelf pushExchange:model];
            }];
            return cell;
        }else{
            
            static NSString *ID = @"numCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
      
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
        
            
            cell.textLabel.font = fontSystemOfSize(15.0);
            cell.textLabel.text = [NSString stringWithFormat:@"共%ld件商品合计",(long)self.orderModel.buyNum];
            cell.textLabel.numberOfLines = 0;
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.font = fontSystemOfSize(17.0);
            cell.detailTextLabel.textColor = [UIColor redColor];
            NSString *string = [NSString stringWithFormat:@"￥: %.2f",self.orderModel.money];
            cell.detailTextLabel.text = string;
            
            /*
            NSMutableAttributedString *attasting = [[NSMutableAttributedString alloc]initWithString:string];
            [attasting addAttribute:NSFontAttributeName value:fontSystemOfSize(17.0) range:[string rangeOfString:[NSString stringWithFormat:@"%.2f",self.orderDetail.money]]];
            [attasting addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]range:[string rangeOfString:[NSString stringWithFormat:@"%.2f",self.orderDetail.money]]];
            
            cell.detailTextLabel.attributedText = attasting;
            */
            return cell;
        }
       
    }else if (indexPath.section == 2) {
        
        static NSString *ID = @"numallCell";
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
   
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
          
        }
        
        
        cell.textLabel.font = fontSystemOfSize(13);
        cell.textLabel.text = self.dataSoureArray[indexPath.row];
        cell.textLabel.numberOfLines = 1;
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}

- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, IPHONE_HEIGHT - 50, IPHONE_WIDTH, 50)];
        _bottomBar.backgroundColor = [UIColor whiteColor];
        UIImageView *line = [[UIImageView alloc]init];
        line.backgroundColor = ColorWithRGB(221.0, 222.0, 223.0, 1.0);
        [_bottomBar addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0.0f);
            make.height.mas_equalTo(0.7);
        }];
        
        UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        payBtn.frame = CGRectMake(IPHONE_WIDTH - 85, 0, 65, 30.0);
        payBtn.backgroundColor = kselectColor;
        [payBtn setTitle:@"付款" forState:UIControlStateNormal];
        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        payBtn.titleLabel.font = fontSystemOfSize(14.0);
        [payBtn addTarget:self action:@selector(payBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBar addSubview:payBtn];
        _payBtn = payBtn;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelBtn.frame = CGRectMake(payBtn.left - 85, 0, 65, 30);
        cancelBtn.backgroundColor = RGB(241, 241, 241);
        [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = fontSystemOfSize(14.0);
        [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBar addSubview:cancelBtn];
        cancelBtn.hidden = YES;
        _cancelBtn = cancelBtn;
        
        _payBtn.centerY = _cancelBtn.centerY = _bottomBar.height/2;
        
       
    }
    return _bottomBar;
}
- (void)payBtnAction:(UIButton *)sender
{
    
    if(_orderModel.type == OrderTypeWaitPay){
        
        OrderPaySheet *paySheet = [[OrderPaySheet alloc]init];
        [paySheet show:[NSString stringWithFormat:@"%.2f",_orderModel.money] block:^(BOOL isSccuess) {
            
            if(!isSccuess){
                
            }else{
                [self payRequest];
            }
            
        }];
        
        
        return ;
        
    }
    
    [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if(buttonIndex == 1){
           [self payRequest];
        }
        
    } title:[NSString stringWithFormat:@"确定%@操作吗",sender.titleLabel.text] message:nil cancelButtonName:@"取消" otherButtonTitles:@"确定", nil];
    
}

- (void)cancelBtnAction:(UIButton *)sender
{
  
    if(_orderModel.type == OrderTypeWaitRecive){ //查看物流
        
        CourierViewController *view = [CourierViewController new];
        view.bookingId = _orderModel.bookingId;
        view.type = 1;
        [self.navigationController pushViewController:view animated:YES];
        return;
    }
    
    [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if(buttonIndex == 1){
            [self cancelRequest];
        }
        
    } title:[NSString stringWithFormat:@"确定%@操作吗",sender.titleLabel.text] message:nil cancelButtonName:@"取消" otherButtonTitles:@"确定", nil];
    
    
}

//确定订单的操作
-(void)payRequest{

    if(_orderModel.type == OrderTypeAgreeGoods){
        WriteExpressViewController *express = [WriteExpressViewController new];
        express.model = _orderModel;
        [self.navigationController pushViewController:express animated:YES];
        return;
    }
    [OrderViewModel payRequestWithModel:self.orderModel  toViewController:self  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        [UIView show_success_progress:respone.msg];
        [self leftBtnAction:nil];
        self.block(self.orderModel);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        [UIView show_fail_progress:respone.msg];
    }];
}



//取消订单的操作，，删除订单等
-(void)cancelRequest{

    
    [OrderViewModel cancelRequestWithModel:self.orderModel success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        [UIView show_success_progress:respone.msg];
        self.orderModel.status = [NSString stringWithFormat:@"%ld",(long)OrderTypeClose];
         [self leftBtnAction:nil];
         self.block(self.orderModel);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        [UIView show_fail_progress:respone.msg];
    }];
    
    
}

#pragma mark----换货
-(void)pushExchange:(DetailListModel *)model{
    ExchangeGoodsViewController *goods = [ExchangeGoodsViewController new];
    goods.model = self.orderModel;
    goods.listModel = model;
    [goods setBlock:^(NSString *text) {
        [self getData];
    }];
    [self.navigationController pushViewController:goods animated:YES];
}
@end
