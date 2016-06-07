//
//  MyYejiViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyYejiViewController.h"
#import "PerformanceCell.h"
#import "NSDate+TimeAgo.h"
@interface MyYejiViewController ()

@end

@implementation MyYejiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的业绩";
    [self setup];
}
-(void)setup{
    PerformanceCell * headView = [[PerformanceCell alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH,44)];
    headView.nameLabel.text = @"昵称";
//    headView.gradeLabel.text = @"级别";
    headView.closeNameLabel.text = @"时间";
    headView.countLabel.text = @"购买数量";
    headView.fanMoneyLabel.text = @"销售金额";
    headView.backgroundColor = [UIColor whiteColor];
    for (UILabel * label in headView.contentView.subviews){
        if ([label isKindOfClass:[UILabel class]]) {
            label.font = [UIFont systemFontOfSize:16];
        }
    }
    self.tableView.tableHeaderView = headView;
    self.tableView.rowHeight = 44.0f;
    
    [self getData];
    
    [self.tableView hzxAddLegendHeaderWithRefreshingBlock:^{
        self.pageNo = 1;
        [self getData];
    }];
    [self.tableView hzxAddLegendFooterWithRefreshingBlock:^{
        self.pageNo ++;
        [self getData];
    }];
}
-(void)getData{
 
     [[RequestClient sharedClient]user_yeji_list_pagesize:kPageSize pageno:self.pageNo progress:^(NSProgress *uploadProgress) {
         
         
         
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
         
         if(self.pageNo == 1){
             [self.dataSoureArray removeAllObjects];
             [self.tableView hzxHeaderEndRefreshing];
         }else{
             [self.tableView hzxFooterEndRefreshing];
         }
         
         NSArray *array = respone.data[@"list"];
         [self.dataSoureArray addObjectsFromArray:array];
         [self.tableView hzxHiddenFooter:!(array.count == kPageSize)];
         [self.tableView reloadData];
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
         [UIView show_fail_progress:respone.msg];
          [self requestFail];
         
     }];
}

#pragma mark UITableView 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoureArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cell";
    PerformanceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[PerformanceCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    NSDictionary *dict = self.dataSoureArray[indexPath.row];
    
    cell.nameLabel.text = [Common getNULLString:dict[@"user_name"]];
    cell.nameLabel.text = [cell.nameLabel.text stringByAppendingString:cell.nameLabel.text];
     cell.nameLabel.text = [cell.nameLabel.text stringByAppendingString:cell.nameLabel.text];
//    cell.gradeLabel.text = @"一级";
    cell.closeNameLabel.text = [Common getNULLString:[NSDate stringFromTimeInterval:dict[@"create_time"]]];
    cell.countLabel.text = [Common getNULLString:dict[@"buy_num"]];;
    cell.countLabel.textColor = [UIColor redColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString * money = [NSString stringWithFormat:@"%@元",[Common getNULLString:dict[@"buy_price"]]];
    cell.fanMoneyLabel.attributedText = [self setAttribu:money Range:NSMakeRange(0, money.length-1) Color:[UIColor redColor]];
    cell.fanMoneyLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0;
}

-(NSMutableAttributedString *)setAttribu:(NSString *)str Range:(NSRange)range Color:(UIColor *)color{
    NSMutableAttributedString *str1= [[NSMutableAttributedString alloc] initWithString:str];
    [str1 addAttribute:NSForegroundColorAttributeName value:color range:range];
    return str1;
}

@end
