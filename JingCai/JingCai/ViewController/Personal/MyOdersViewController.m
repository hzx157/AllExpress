//
//  MyOdersViewController.m
//  JingCai
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyOdersViewController.h"
#import "OrderModel.h"
#import "OrderDetailViewController.h"
#import "OrderViewModel.h"
#import "CourierViewController.h"
#import "UIView+NotData.h"
#import "OrderPaySheet.h"
#import "WriteExpressViewController.h"
@interface MyOdersViewController ()

@property (nonatomic, strong) OrderSelectView *selectView;

@end

@implementation MyOdersViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _orderType = OrderTypeAll;
        self.pageNo = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的订单";
    [self setSubviews];
    [self loadData];
}

- (void)setSubviews
{
    self.tableViewStyle = UITableViewStylePlain;

    self.tableView.separatorColor = [UIColor clearColor];

    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 190;
    
    [self.tableView hzxAddLegendHeaderWithRefreshingBlock:^{
        self.pageNo = 1;
        [self loadData];
    }];
    [self.tableView hzxAddLegendFooterWithRefreshingBlock:^{
        self.pageNo ++;
        [self loadData];
    }];
 
    [self.view addSubview:self.selectView];
    self.tableView.top = self.selectView.bottom;
    self.tableView.height = self.view.height - self.selectView.bottom;
    
}
-(OrderSelectView *)selectView{
   
    if(!_selectView){
        
      _selectView = [[OrderSelectView alloc] initWithFrame:CGRectMake(0, IOS7_TOP_Y, IPHONE_WIDTH, 40)];
      [_selectView setSelectIndicateAtType:_orderType];
      WEAKSELF;
      [_selectView setOrderSelectViewBlock:^(NSInteger index) {
        
        weakSelf.orderType = index;
        if(weakSelf.dataSoureArray.count > 0) {
            
            [weakSelf.dataSoureArray removeAllObjects];
            
          }
        weakSelf.pageNo = 1;
        [weakSelf loadData];
          
          
       }];
        
    }
    return _selectView;
}


- (void)loadData
{
    NSString *status = [NSString stringWithFormat:@"0%ld",_orderType];
    NSString *page = [NSString stringWithFormat:@"%ld",self.pageNo];
    if(_orderType >9 )
        status = [NSString stringWithFormat:@"%ld",_orderType];;
    [[RequestClient sharedClient] order_list_pageSize:@"10" pageno:page status:status progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, JCRespone *respone) {
        
        
        NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
        [OrderModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"detailList":[DetailListModel class]};
        }];
        
        if(self.pageNo == 1){
            [self.dataSoureArray removeAllObjects];
            [self.tableView hzxHeaderEndRefreshing];
            [self.tableView addNotMsg:@"暂时没有订单" type:NotDataTypeOrder];
            if(array.count>0)
                [self.tableView hideNotMsg];
        }else{
            [self.tableView hzxFooterEndRefreshing];
        }
        [self.dataSoureArray addObjectsFromArray:[OrderModel mj_objectArrayWithKeyValuesArray:array]];
    
        [self.tableView hzxHiddenFooter:!(array.count == 10)];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error, JCRespone *respone) {
        [self requestFail];
        [UIView show_fail_progress:respone.msg];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSoureArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"orderCell";
    MyOderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MyOderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = self.dataSoureArray[indexPath.row];
    cell.indexPath = indexPath;
    WEAKSELF;
    [cell setPayBlock:^(OrderModel *aModel, NSIndexPath *_indexPath) {
        
      
        
        [weakSelf payRequestWithModel:aModel indexPath:_indexPath];
        
    }];
    
    
    
    [cell setCancelBlock:^(OrderModel *aModel, NSIndexPath *_indexPath) {
        [weakSelf cancelRequestWithModel:aModel indexPath:_indexPath];
    }];
  
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    MyOderCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderDetailViewController *detail = [OrderDetailViewController new];
    detail.sid = cell.model.bookingId;
    detail.block = ^(id obj){
        self.pageNo = 1;
        [self loadData];
    };
    [self.navigationController pushViewController:detail animated:YES];

}


//确定订单的操作
-(void)payRequestWithModel:(OrderModel *)model indexPath:(NSIndexPath *)indexPath{

    
    
    if(model.type == OrderTypeAgreeGoods){
        WriteExpressViewController *express = [WriteExpressViewController new];
        express.model = model;
        [self.navigationController pushViewController:express animated:YES];
        return;
    }

    void (^block)(NSIndexPath *_indexPath) = ^(NSIndexPath *_indexPath){
        [self.tableView beginUpdates];
        [self.dataSoureArray removeObjectAtIndex:_indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    };
    
    
    [OrderViewModel payRequestWithModel:model toViewController:self success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        [UIView show_success_progress:respone.msg];
        block(indexPath);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
         [UIView show_fail_progress:respone.msg];
    }];
}

   

//取消订单的操作，，删除订单等
-(void)cancelRequestWithModel:(OrderModel *)model indexPath:(NSIndexPath *)indexPath{

     if(model.type == OrderTypeWaitRecive){ //查看物流
         
         CourierViewController *view = [CourierViewController new];
         view.bookingId = model.bookingId;
         view.type = 1;
         [self.navigationController pushViewController:view animated:YES];
     }
    
    [OrderViewModel cancelRequestWithModel:model success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        [UIView show_success_progress:respone.msg];
        model.status = [NSString stringWithFormat:@"%ld",(long)OrderTypeClose];
        [self.dataSoureArray replaceObjectAtIndex:indexPath.row withObject:model];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
         [UIView show_fail_progress:respone.msg];
    }];
    
    
}

@end
