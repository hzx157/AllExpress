//
//  CourierViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CourierViewController.h"
@interface CourierViewController()
@property (nonatomic,weak)UITableViewCell *celll;
@end
@implementation CourierViewController


-(void)viewDidLoad{
 
    [super viewDidLoad];
    
    self.tableViewStyle = UITableViewStylePlain;
    self.title = @"物流详情";
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.view.backgroundColor = self.tableView.backgroundColor = [UIColor whiteColor];
   
    [self getData];
    
}
-(void)getData{
    
  [[RequestClient sharedClient]order_kuaiid_type:_type bookingId:[NSString stringWithFormat:@"%ld",_bookingId] progress:^(NSProgress *uploadProgress) {
      ;
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
      
      NSArray *array = respone.data[@"list"];
      array = [[array reverseObjectEnumerator] allObjects];
      [self.dataSoureArray addObjectsFromArray:array];
    
      UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 30.0)];
      label.adjustsFontSizeToFitWidth = YES;
      label.backgroundColor = ColorWithRGB(238.0, 239.0, 240.0, 1.0);
      label.font = fontSystemOfSize(15.0);
      label.text = [NSString stringWithFormat:@"  快递公司:%@                 快递单号:%@",[Common getNULLString:respone.data[@"kuaidi"]],[Common getNULLString:respone.data[@"postid"]]];
      self.tableView.tableHeaderView = label;
      [self.tableView reloadData];
      
  } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
      ;
  }];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoureArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
     static NSString *_indeyi = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_indeyi];
    if(!cell){
     
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_indeyi];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = fontSystemOfSize(15.0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 10, 7, 7)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = imageNamed(@"isseleted");
        if(indexPath.row == 0){
            imageView.image = imageNamed(@"adresssChoose_select_icon");
        }
        [cell.contentView addSubview:imageView];
        
    }
    
    cell.indentationLevel = 1;
    NSDictionary *dict = self.dataSoureArray[indexPath.row];
    cell.textLabel.text = [Common getNULLString:dict[@"detail"]];
    cell.detailTextLabel.text = [Common getNULLString:dict[@"time"]];
    _celll = cell;
    return cell;
    
}

@end
