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

@interface SureOrderViewController ()

@property (nonatomic, strong) UIView *shopNumView;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, assign) NSInteger count;

@end

@implementation SureOrderViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"确认订单";
    self.view.backgroundColor = RGB(241, 241, 241);
    [self setSubviews];
}

- (void)setSubviews
{
    self.tableViewStyle = UITableViewStylePlain;
    self.tableView.frame = CGRectMake(0, IOS7_TOP_Y, IPHONE_WIDTH, IPHONE_HEIGHT-IOS7_TOP_Y - HeightScaleSize(50));
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH - 10, 40)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"共1件产品";
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 40)];
    [footerView addSubview:label];

    self.tableView.tableFooterView = footerView;
    
    [self.view addSubview:self.bottomBar];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }else if (section == 1) {
        
        return 2;
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
        return cell;
    }else if (indexPath.section == 1) {
        
        static NSString *ID = @"shopInfoCell";
        SureOderShopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[SureOderShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        return cell;
    }else if (indexPath.section == 2) {
        
        static NSString *ID = @"numCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        
        UIView *view = [cell viewWithTag:999];
        [view removeFromSuperview];
        
        if (indexPath.row == 0) {
            
            UILabel *styleLbl = [[UILabel alloc] init];
            styleLbl.frame = CGRectMake(10, 0, IPHONE_WIDTH - 20, 50);
            styleLbl.textColor = [UIColor blackColor];
            styleLbl.font = [UIFont systemFontOfSize:14];
            styleLbl.text = @"配送方式：";
            styleLbl.tag = 999;
            [cell addSubview:styleLbl];

        }else {
         
            UILabel *messageLbl = [[UILabel alloc] init];
            messageLbl.frame = CGRectMake(10, 0, IPHONE_WIDTH - 20, 50);
            messageLbl.textColor = [UIColor blackColor];
            messageLbl.font = [UIFont systemFontOfSize:14];
            messageLbl.text = @"买家留言：这件产品真心不错！";
            messageLbl.tag = 999;
            [cell addSubview:messageLbl];

        }
        
        return cell;
    }
    return nil;
}

- (UIView *)shopNumView
{
    if (!_shopNumView) {
        _shopNumView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 70)];

        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.frame = CGRectMake(10, 15, 100, 14);
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.font = [UIFont systemFontOfSize:14];
        titleLbl.text = @"购买数量";
        [_shopNumView addSubview:titleLbl];
        
        CGFloat w = 34;
        CGFloat h = 25;
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(IPHONE_WIDTH - w - 10, 30, w, h);
        [addBtn setBackgroundImage:[UIImage imageNamed:@"max"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_shopNumView addSubview:addBtn];
        
        UILabel *numLbl = [[UILabel alloc] init];
        numLbl.frame = CGRectMake(IPHONE_WIDTH - 2 * w - 10, addBtn.top, w, h);
        numLbl.textColor = [UIColor blackColor];
        numLbl.textAlignment = NSTextAlignmentCenter;
        numLbl.font = [UIFont systemFontOfSize:12];
        numLbl.text = @"1";
        numLbl.tag = 888;
        [_shopNumView addSubview:numLbl];
        
        UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        subBtn.frame = CGRectMake(IPHONE_WIDTH - 3 * w - 10, addBtn.top, w, h);
        [subBtn setBackgroundImage:[UIImage imageNamed:@"minmux"] forState:UIControlStateNormal];
        [subBtn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_shopNumView addSubview:subBtn];
        
        
    }
    return _shopNumView;
}

- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, IPHONE_HEIGHT - HeightScaleSize(40), IPHONE_WIDTH, HeightScaleSize(40))];
        
        UILabel *countLbl = [[UILabel alloc] init];
        countLbl.frame = CGRectMake(0, 0, IPHONE_WIDTH * 0.66, HeightScaleSize(40));
        countLbl.backgroundColor = [UIColor blackColor];
        countLbl.font = [UIFont systemFontOfSize:12];
        countLbl.textAlignment = NSTextAlignmentCenter;
        countLbl.textColor = [UIColor whiteColor];
        countLbl.text = @"合计：290.0";
        [_bottomBar addSubview:countLbl];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(countLbl.right, 0, IPHONE_WIDTH * 0.34, HeightScaleSize(40));
        sureBtn.backgroundColor = [UIColor redColor];
        [sureBtn setTitle:@"确认订单" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureBtnAcion:) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_bottomBar addSubview:sureBtn];
    }
    return _bottomBar;
}

- (void)addBtnAction:(UIButton *)sender
{
    UILabel *label = (UILabel *)[_shopNumView viewWithTag:888];
    _count = [label.text integerValue];
    _count ++;
    label.text = [NSString stringWithFormat:@"%ld",_count];
}

- (void)subBtnAction:(UIButton *)sender
{
    if (_count == 0) {
        return;
    }
    UILabel *label = (UILabel *)[_shopNumView viewWithTag:888];
    _count = [label.text integerValue];
    _count --;
    label.text = [NSString stringWithFormat:@"%ld",_count];
}

- (void)sureBtnAcion:(UIButton *)sender
{

}

@end
