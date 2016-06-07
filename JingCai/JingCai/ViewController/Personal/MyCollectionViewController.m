

#import "MyCollectionViewController.h"
#import "MyColletionCell.h"
#import "ShopDetailsViewController.h"
#import "UIView+NotData.h"
@interface MyCollectionViewController ()
@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"我的收藏";
    self.tableViewStyle =UITableViewStylePlain;
    self.tableView.rowHeight = 106.0f;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyColletionCell" bundle:nil] forCellReuseIdentifier:@"MyColletionCell"];
    [self getData];
    
    WEAKSELF;
    [self.tableView hzxAddLegendHeaderWithRefreshingBlock:^{
        self.pageNo = 1;
        [weakSelf getData];
    }];
    [self.tableView hzxAddLegendFooterWithRefreshingBlock:^{
        self.pageNo ++;
        [weakSelf getData];
        
    }];
}


-(void)getData{
   [[RequestClient sharedClient]user_get_favorite_list_pagesize:kPageSize pageno:self.pageNo progress:^(NSProgress *uploadProgress) {
       ;
   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
       
       NSArray *array = respone.data[@"list"];
      
       
       if(self.pageNo == 1){
          
           [self.dataSoureArray removeAllObjects];
            [self.dataSoureArray addObjectsFromArray:array];
           [self.tableView hzxHeaderEndRefreshing];
           
           [self.tableView addNotMsg:@"暂时没有收藏" type:NotDataTypeFaovi];
           if(array.count>0)
               [self.tableView hideNotMsg];
           
       }else{
            [self.dataSoureArray addObjectsFromArray:array];
           [self.tableView hzxFooterEndRefreshing];
           
       }
        [self.tableView hzxHiddenFooter:!(array.count == kPageSize)];
       [self.tableView reloadData];
       
       
      
   } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
       [UIView show_fail_progress:respone.msg];
       [self requestFail];
       
   }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSoureArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 10.0)];
    headerView.backgroundColor = ColorWithRGB(236.0, 237.0, 238.0, 1.0);
    return headerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyColletionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyColletionCell"];
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"MyColletionCell" bundle:nil] forCellReuseIdentifier:@"MyColletionCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyColletionCell"];
    }
    [cell setModel:self.dataSoureArray[indexPath.section]];
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopDetailsViewController *details = [ShopDetailsViewController new];
    details.shopId = self.dataSoureArray[indexPath.section][@"fav_id"];
    [self.navigationController pushViewController:details animated:YES];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
       
        [self del:indexPath];
    }

}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)del:(NSIndexPath *)indexPath{
    
    [UIView show_loading_progress:@"删除中..."];
    NSDictionary *dict = self.dataSoureArray[indexPath.section];
    [[RequestClient sharedClient]user_delete_favorite_favId:dict[@"fav_id"] type:1 progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        [UIView show_success_progress:@"删除收藏成功"];
        [self.dataSoureArray removeObjectAtIndex:indexPath.section];
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:indexPath.section];
        [self.tableView beginUpdates];
        [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        [UIView show_fail_progress:respone.msg];
    }];
}

@end
