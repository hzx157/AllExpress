//
//  ShopCartViewController.m
//  JingCai
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShopCartViewController.h"
#import "ShopCartView.h"
#import "ShopCartCell.h"
#import "ShopCartBar.h"
#import "SureOrderViewController.h"
#import "ShopDetailsViewController.h"
#import "UIView+NotData.h"
@interface ShopCartViewController ()
@property(nonatomic,strong)ShopCartBar *bar;
@property (nonatomic,assign)BOOL isAll;
@property (nonatomic,strong)NSMutableArray *selectArray;
@end

@implementation ShopCartViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showTabBar];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"购物车";
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.frame = CGRectMake(0, IOS7_TOP_Y, IPHONE_WIDTH, IPHONE_HEIGHT-IOS7_TOP_Y - 50);
    self.leftBtn.hidden = YES;
    [self.rightBtn setTitle:@"编辑" forState:0];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    [self setup];
    self.selectArray = [NSMutableArray new];
    
}
-(void)setup{

    _bar = [[ShopCartBar alloc]init];
    [self.view addSubview:_bar];
     _bar.isDelete = NO;
    [_bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-50.0f);
        make.height.mas_equalTo(40.0f);
        make.left.right.mas_equalTo(0.0f);
    }];
    
    WEAKSELF;
    [_bar setActionBlock:^(UIButton *button) {
        if(button.selected){ //删除
            
            [weakSelf deleteAll];
            
        }else{ //结算
            [weakSelf hiddenTabBar];
            SureOrderViewController *sureView = [SureOrderViewController new];
            sureView.dataSoureArray = weakSelf.selectArray;
            [weakSelf.navigationController pushViewController:sureView animated:YES];
            [sureView setSuccessBlock:^(NSMutableArray *array) {
                [weakSelf deleteAll];
            }];
        }
        [weakSelf.tableView reloadData];
    }];
    
    [_bar setChooseBlock:^(UIButton *button) {
          [weakSelf.selectArray removeAllObjects];
        if(button.selected){ //全选
          
            [weakSelf.selectArray addObjectsFromArray:weakSelf.dataSoureArray];
            
        }else{ //取消
         
        }
        [weakSelf calculateToSelectArray];
        [weakSelf.tableView reloadData];
    }];
    
}

-(void)deleteAll{
    //删除本地数据库
    for(ShopCarModel *model in self.selectArray){
        [self.dataSoureArray removeObject:model];
        [ShopCarModel deleteToDB:model];
    }
    [self.selectArray removeAllObjects];
    [self calculateToSelectArray];
}

-(void)getData{

     dispatch_async(dispatch_get_global_queue(0, 0), ^{
         
         
            NSArray *array = [ShopCarModel searchWithWhere:nil orderBy:@"createTime desc" offset:0 count:0];
          dispatch_async( dispatch_get_main_queue(), ^{
              
              self.bar.hidden = !array.count;
              [self.tableView addNotMsg:@"暂时没有添加商品" type:NotDataTypeCard];
              if(array.count>0)
              [self.tableView hideNotMsg];
              
              [self.dataSoureArray removeAllObjects];
              [self.dataSoureArray addObjectsFromArray:array];
              [self.tableView reloadData];
          });
         
     });
}

#pragma makr --- 编辑按钮 ---

- (void)rightBtnAction:(UIButton *)sender{
    NSLog(@"编辑");
    if(!sender.selected){
        sender.selected = YES;
        self.bar.isDelete = YES;
    }else{
        sender.selected = NO;
        self.bar.isDelete = NO;
    }
    [self.selectArray removeAllObjects];
     [self calculateToSelectArray];
    [self.tableView reloadData];
}

#pragma mark --- 表视图 ---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoureArray.count;
}

- (ShopCartCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    ShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ShopCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.model = self.dataSoureArray[indexPath.row];
    cell.index = indexPath;
    [cell.chooseBtn addTarget:self action:@selector(handleChoose:) forControlEvents:UIControlEventTouchUpInside];
//    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"skuId CONTAINS[cd] %@", @(cell.model.skuId)];
//    NSArray* groupArray =  [self.selectArray filteredArrayUsingPredicate:predicate1];
    cell.chooseBtn.selected = NO;
    for(ShopCarModel *model in self.selectArray){ //只能用这样的方法...因为内存地址在变
        if(cell.model.skuId == model.skuId)
        cell.chooseBtn.selected = YES;
    }
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  CELL_SHOPCART_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hiddenTabBar];
    ShopCarModel * model = self.dataSoureArray[indexPath.row];
    ShopDetailsViewController *detail = [ShopDetailsViewController new];
    detail.shopId = [NSString stringWithFormat:@"%ld",model.productId];
    [self.navigationController pushViewController:detail animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
         [ShopCarModel deleteToDB:self.dataSoureArray[indexPath.row]];
        [self.dataSoureArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
       
        
    }
}

#pragma mark --- 选择产品 ---

- (void)handleChoose:(UIButton *)sender{
    
    if(!sender.selected){
        sender.selected = YES;
        [self.selectArray addObject:self.dataSoureArray[sender.tag]];
        
    }else{
        sender.selected = NO;
        ShopCarModel *model = self.dataSoureArray[sender.tag];
        NSArray *array = [NSArray arrayWithArray:_selectArray];
        NSInteger i = 0;
        for(ShopCarModel *aModel in array){
            
            if(aModel.skuId == model.skuId){
               
                [self.selectArray removeObjectAtIndex:i];
             
            }
            i++;
        }
   
    }
    [self.tableView reloadData];
    
    [self calculateToSelectArray];
}

//数据变更重新计算
-(void)calculateToSelectArray{
    
    CGFloat pri = 0.00f;
    NSInteger num = 0;
    for(ShopCarModel *model in _selectArray){
        num += model.snum;
        pri += ([model.sprice floatValue] * model.snum);
    }
    [self.bar setPri:pri num:num];
}
@end
