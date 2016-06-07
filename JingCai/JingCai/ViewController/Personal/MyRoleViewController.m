//
//  MyRoleViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyRoleViewController.h"
#import "PayActionSheet.h"
#import "UIAlertView+Block.h"
#import "OrderModel.h"
#import "PayModel.h"
#import "ApiServer.h"
#import "WebViewController.h"
#import "NSDate+Extension.h"
#import "JCPayViewController.h"
@interface MyRoleViewController()
@property (nonatomic,copy)NSArray *titleArray;
@end
@implementation MyRoleViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员类型";
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.rowHeight = 44.0f;
    _titleArray = @[@"成为代言人",@"成为合作商"];
    self.dataSoureArray = [NSMutableArray arrayWithArray:@[@"ic_spokesman",@"ic_dealer"]];
    [self setupHeadView];
    
 
    
}


-(void)setupHeadView{
    
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 200.0f)];
    view.image = imageNamed(@"ic_person_bg");
    self.tableView.tableHeaderView = view;
    
    UILabel *tisLabel = [UILabel new];
    tisLabel.text = @"您当前的会员";
    tisLabel.textColor = [UIColor whiteColor];
    tisLabel.font = fontSystemOfSize(15.0);
    tisLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:tisLabel];
    [tisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.centerY.mas_equalTo(view.mas_centerY).offset(-20.0f);
        make.size.mas_equalTo(CGSizeMake(200.0, 40.0));
    }];
    
    //显示当前的等级
    UILabel *typeLabel = [UILabel new];
    typeLabel.text = [LoginModel getRoleName];
    typeLabel.textColor = [UIColor redColor];
    typeLabel.font = fontSystemOfSize(20.0);
    typeLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.centerY.mas_equalTo(view.mas_centerY).offset(20);
        make.size.mas_equalTo(CGSizeMake(200.0, 40.0));
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indetifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
    if(!cell){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indetifier];
        cell.backgroundColor = [UIColor whiteColor];
        UIImage *image= imageNamed(@"ic_question");
        UIButton *button = [ UIButton buttonWithType:UIButtonTypeCustom ];
        CGRect frame = CGRectMake( 0.0 , 0.0 , image.size.width , image.size.height);
        button. frame = frame;
        button.    imageView.contentMode = UIViewContentModeScaleAspectFit;
        [button setImage:image forState:UIControlStateNormal ];
        button. backgroundColor = [UIColor clearColor ];
        button.tag = indexPath.row;
        [button addTarget:self action:@selector(buttonPressedActionP:) forControlEvents:UIControlEventTouchUpInside];
        cell. accessoryView = button;
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.imageView.image = imageNamed(self.dataSoureArray[indexPath.row]);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
  //  PayActionSheet *sheet = [[PayActionSheet alloc]init];
    
    
    switch (indexPath.row) {
        case 0:
        {
            if([LoginModel shareLogin].roleId > roleTypeNormal){
               [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                   ;
               } title:@"您已经拥有这个权限,无需开次开通" message:nil cancelButtonName:@"确定" otherButtonTitles:nil, nil];
                return;
            }
            CGFloat money = 16.8;
            
            [self setOpen:roleTypeSpokesman money:money];
//            [sheet show:@"成为代言人" type:roleTypeSpokesman toBlock:^(BOOL isSccuess) {
//                if(isSccuess){
//                    
//                    CGFloat money = 16.8;
//                    
//                    [self open:roleTypeSpokesman money:money];
//                }
//            }];
         
        }
            break;
        case 1:{
            if([LoginModel shareLogin].roleId > roleTypeSpokesman){
                [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                    ;
                } title:@"您已经拥有这个权限,无需开次开通" message:nil cancelButtonName:@"确定" otherButtonTitles:nil, nil];
                return;
            }
            CGFloat money = 10016.8;
            
            [self setOpen:roleTypeAgent money:[LoginModel shareLogin].roleId == roleTypeSpokesman ? 10000.0 : money];
//            [sheet show:@"成为合作商" type:roleTypeAgent toBlock:^(BOOL isSccuess) {
//                if(isSccuess){
//                    CGFloat money = 100016.8;
//                    
//                    [self setOpen:roleTypeAgent money:[LoginModel shareLogin].roleId == roleTypeSpokesman ? 10000.0 : money];
////                    [self open:roleTypeAgent money:[LoginModel shareLogin].roleId == roleTypeSpokesman ? 10000.0 : money];
//                }
//            }];
        }
            break;
            
        default:
            break;
    }
    
}

-(void)setOpen:(roleType)type money:(CGFloat)money{
   
    JCPayViewController *pay = [JCPayViewController new];
    pay.money = money;
    pay.type = type;
    [self.navigationController pushViewController:pay animated:YES];

}

-(void)open:(NSInteger)type money:(CGFloat)money{
 
    
    //有钱够，那就直接支付
    if(SINGLE.moneyModel.useMoney >= money){
         [self pay:type toAlipay:NO];
        return;
        
    }
    
    CGFloat balance = money - SINGLE.moneyModel.useMoney; //余额
   
    [PayModel openWeChat_alipayBlock:^(NSInteger buttonIndex, BOOL isCannel) {
         if(isCannel)
             return ;
        //支付宝充值到余额在支付
        [PayModel sharePayModelWithMoney:[NSString stringWithFormat:@"%.2f",balance] toPayModelType:buttonIndex block:^(BOOL isSccuess, NSString *money, NSString *message) {
            if(isSccuess){
                
                SINGLE.moneyModel.useMoney += balance;
                [self pay:type toAlipay:YES];
                
            }else{
                
                [UIView show_fail_progress:message];
            }
        }];
             
    }];
 
}



-(void)pay:(NSInteger)type toAlipay:(BOOL)isAlipay {
    
   [[RequestClient sharedClient]user_spokesman:type progress:^(NSProgress *uploadProgress) {
       ;
   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
       if(isAlipay)
           SINGLE.moneyModel.useMoney = 0.0f;
       
       if(type == roleTypeAgent){
           [LoginModel shareLogin].roleId = roleTypeAgent;
       }else{
          [LoginModel shareLogin].roleId = roleTypeSpokesman;
       }
       [[Common shareAppDelegate]login];
       [self leftBtnAction:nil];
       
       [UIView show_success_progress:respone.msg];
   } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
       
       [UIView show_fail_progress:respone.msg];
   }];
}


-(void)buttonPressedActionP:(UIButton *)button{
    DLog(@"---%ld",(long)button.tag);
    WebViewController *webView = [WebViewController new];
    webView.title = @"说明";
    webView.urlstr = [apiUrl stringByAppendingString:@"jingcai/agentInfo.htm"];
    [self.navigationController pushViewController:webView animated:YES];
    //jingcai/agentInfo
}

@end
