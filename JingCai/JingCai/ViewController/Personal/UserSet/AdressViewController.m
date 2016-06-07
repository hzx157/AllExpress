//
//  AdressViewController.m
//  BusinessWorld
//
//  Created by XiaoWu on 14/12/23.
//  Copyright (c) 2014年 HuangZhenXiang. All rights reserved.
//

#import "AdressViewController.h"
#import "AdressViewCell.h"
#import "UIButton+Block.h"
#import "EdiorAddressViewController.h"
#import "UIAlertView+Block.h"
@interface AdressViewController ()


@end

@implementation AdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"管理收货地址";
    
  
    
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewStyle = UITableViewStylePlain;
    self.tableView.rowHeight = 106.0f;
    [self.tableView registerNib:[UINib nibWithNibName:@"AdressViewCell" bundle:nil] forCellReuseIdentifier:@"AdressViewCell"];
    [self.rightBtn setTitle:@"新增" forState:UIControlStateNormal];
    [self setup];
    [self getData];
    WEAKSELF;
    [self.tableView hzxAddLegendHeaderWithRefreshingBlock:^{
        
        [weakSelf getData];
    }];
    
}
-(void)setup{

    UIButton *outButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [outButton setBackgroundColor:ColorWithRGB(32.0, 33.0, 34.0, 1.0)];
    [outButton setTitle:@"添加新地址" forState:UIControlStateNormal];
    outButton.titleLabel.font = fontSystemOfSize(17.0);
    [outButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    outButton.frame = CGRectMake(0, IPHONE_HEIGHT - 50.0, IPHONE_WIDTH, 50.0);
    [outButton addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outButton];
    
    self.tableView.height =  IPHONE_HEIGHT - IOS7_TOP_Y - 50.0f;
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
    EdiorAddressViewController *view = [EdiorAddressViewController new];
    [view setBlock:^(id model) {
        [self getData];
    }];
    [self.navigationController pushViewController:view animated:YES];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataSoureArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     static NSString *identifier = @"AdressViewCell";
    AdressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
   
    cell.indexPath = indexPath;
    [cell setModel:self.dataSoureArray[indexPath.section]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WEAKSELF;
    [cell setBlock:^(NSInteger tag, NSIndexPath * indexPath,AddressModel *model) {
        switch (tag) {
            case 111: //默认
            {
                [weakSelf setDefualtOfIndexPath:indexPath];
            }
                break;
            case 222: //编辑
            {
                WEAKSELF;
                EdiorAddressViewController *addView = [EdiorAddressViewController new];
                addView.model = [weakSelf.dataSoureArray objectAtIndex:indexPath.section];
                [addView setBlock:^(id model) {
                    [weakSelf getData];
                }];
                [weakSelf.navigationController pushViewController:addView animated:YES];
            }
                break;
            case 333: //删除
            {
                
                [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                    if(buttonIndex == 1){
                     [weakSelf deleteOfIndexPath:indexPath];
                    }
                } title:@"确定删除该地址吗" message:@"" cancelButtonName:@"取消" otherButtonTitles:@"确定", nil];
               
            }
                break;
                
            default:
                break;
        }
    }];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10.0;
}


-(void)deleteOfIndexPath:(NSIndexPath *)indexPath{
 
    [UIView show_loading_progress:@"删除中.."];
    AddressModel *model = self.dataSoureArray[indexPath.section];
    if(model.isdefalt){
        [UIView show_fail_progress:@"不能删除默认地址"];
        return;
    }
    
    
    [[RequestClient sharedClient]user_del_address_id:[Common getNULLString:@(model.address_id)] progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        [UIView show_success_progress:@"删除成功"];
        [self.dataSoureArray removeObjectAtIndex:indexPath.section];
        
        NSMutableIndexSet *indexSets = [[NSMutableIndexSet alloc] init];
        [indexSets addIndex:indexPath.section];
         [self.tableView beginUpdates];
        [self.tableView deleteSections:indexSets withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
         [self.tableView endUpdates];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        [UIView show_fail_progress:respone.msg];
    }];
    
}
-(void)setDefualtOfIndexPath:(NSIndexPath *)indexPath{
    
    AddressModel *UpdateModel = self.dataSoureArray[indexPath.section];
    
    NSInteger row = 0;
    for (NSInteger i =0; i < self.dataSoureArray.count; i++) {
        AddressModel *model = self.dataSoureArray[i];
        if(model.isdefalt){
            row = i;
            break;
        }
    }
    
    AddressModel *model = self.dataSoureArray[row];
    model.isdefalt = NO;
    [self.dataSoureArray replaceObjectAtIndex:row withObject:model];
    
    
    UpdateModel.isdefalt = YES;
    [self.dataSoureArray replaceObjectAtIndex:indexPath.section withObject:UpdateModel];
    [self.tableView reloadData];
    
    
    
    [[RequestClient sharedClient]user_default_address_id:[Common getNULLString:@(UpdateModel.address_id)] progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        
      
     
        
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        [UIView show_fail_progress:respone.msg];
    }];
    
}

@end
