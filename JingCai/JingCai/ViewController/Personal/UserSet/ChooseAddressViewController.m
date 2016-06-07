//
//  ChooseAddressViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChooseAddressViewController.h"
#import "ChooseAddressCellTableViewCell.h"
#import "AdressViewController.h"
@interface ChooseAddressViewController ()

@end

@implementation ChooseAddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择收货地址";
    
    
    
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewStyle = UITableViewStylePlain;
    self.tableView.rowHeight = 106.0f;
    [self.tableView registerNib:[UINib nibWithNibName:@"ChooseAddressCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChooseAddressCellTableViewCell"];
    [self.rightBtn setTitle:@"管理" forState:UIControlStateNormal];
    
   
    WEAKSELF;
    [self.tableView hzxAddLegendHeaderWithRefreshingBlock:^{
        
        [weakSelf getData];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
 
    [super viewWillAppear:animated];
     [self getData];
}

-(void)getData{
    
    [[RequestClient sharedClient]user_get_address_info_progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask *task, id responseObject, JCRespone *respone) {
        
        [self.tableView hzxHeaderEndRefreshing];
        [self.dataSoureArray removeAllObjects];
        [self.dataSoureArray addObjectsFromArray:[AddressModel mj_objectArrayWithKeyValuesArray:respone.data[@"list"]]];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error, JCRespone *respone) {
        [UIView show_fail_progress:respone.msg];
    }];
    
}

-(void)rightBtnAction:(UIButton *)sender
{
    [self.navigationController pushViewController:[AdressViewController new] animated:YES];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSoureArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ChooseAddressCellTableViewCell";
    ChooseAddressCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    cell.indexPath = indexPath;
    [cell setModel:self.dataSoureArray[indexPath.section]];
  
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if(self.block)
    self.block(self.dataSoureArray[indexPath.section]);
    [self leftBtnAction:nil];
    
}

/*
+(void)getDefaultAddress:(void(^)(AddressModel *model))block{
      [[RequestClient sharedClient]user_get_address_default_progress:^(NSProgress *uploadProgress) {
    ;
     } success:^(NSURLSessionDataTask *task, id responseObject, JCRespone *respone) {
    
         if([respone.data length] == 0){
             block(nil);
         }else{
             AddressModel *aModel = [AddressModel mj_objectWithKeyValues:respone.data];
             block(aModel);
         }
     
    
   } failure:^(NSURLSessionDataTask *task, NSError *error, JCRespone *respone) {
    [UIView show_fail_progress:respone.msg];
}];

}
*/
+(void)getDefaultAddress:(void(^)(AddressModel *model))block{

    [[RequestClient sharedClient]user_get_address_info_progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask *task, id responseObject, JCRespone *respone) {
        
        NSArray *array = [AddressModel mj_objectArrayWithKeyValuesArray:respone.data[@"list"]];
      
        BOOL isHav = NO;
            
        for(AddressModel *aModel in array){
           
            if(aModel.isdefalt){
                block(aModel);
                isHav = YES;
                break;
            }
        }
        
        //没有就返回空
        if(!isHav)
            block(nil);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error, JCRespone *respone) {
        [UIView show_fail_progress:respone.msg];
    }];
    
}

@end
