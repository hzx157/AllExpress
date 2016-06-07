//
//  UserSetViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserSetViewController.h"
#import "UIButton+Block.h"
#import "UIAlertView+Block.h"
#import "LoginViewController.h"
#import "WebViewController.h"
#import "MyInviteCodeViewController.h"
#import "MyInfoViewController.h"
#import "JCShare.h"
#import "ApiServer.h"
#import "RegisterViewController.h"
@interface UserSetViewController ()
@property (nonatomic,weak)UIView *footerView;
@end

@implementation UserSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    NSArray *dataArray = @[@[@"个人资料",@"修改密码",@"清除缓存"],@[@"关于晶彩形象"]];
    [self.dataSoureArray addObjectsFromArray:dataArray];
    
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.rowHeight = 44.0f;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    
    UIButton *outButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [outButton setBackgroundColor:ColorWithRGB(32.0, 33.0, 34.0, 1.0)];
    [outButton setTitle:@"退出当前登录" forState:UIControlStateNormal];
    outButton.titleLabel.font = fontSystemOfSize(15.0);
    [outButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    outButton.frame = CGRectMake(0, IPHONE_HEIGHT - 50.0, IPHONE_WIDTH, 50.0);
    
    WEAKSELF;
    [outButton addActionHandler:^(NSInteger tag) {
        
          [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
              
              
              if(buttonIndex == 1){
                  
                  [weakSelf outLoginButton];
              }
              
              
          } title:@"你确定要退出登录吗?" message:@"" cancelButtonName:@"取消" otherButtonTitles:@"确定", nil];
        
    }];
    [self.view addSubview:outButton];
    
    
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
    return self.dataSoureArray.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return [self.dataSoureArray[section] count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
     static NSString *iindetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iindetifier];
    if(!cell){
      
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iindetifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    cell.textLabel.text = [self.dataSoureArray objectAtIndex:indexPath.section][indexPath.row];
//    cell.textLabel.font = fontSystemOfSize(15.0);
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    //关于晶彩形象
    if(indexPath.section == 1){
    
        WebViewController *webView = [WebViewController new];
        webView.title = @"关于晶彩形象";
        webView.urlstr = [NSString stringWithFormat:@"%@jingcai/info.htm",apiUrl];
        [self.navigationController pushViewController:webView animated:YES];
        
        return;
        
    }
    
    switch (indexPath.row) {
        case 0: //个人资料
        {
        
            [self.navigationController pushViewController:[MyInfoViewController new] animated:YES];
        }
            break;
        case 1: //修改密码
        {
            RegisterViewController*view =  [RegisterViewController new];
            view.type = RegisterViewTypeUpdate;
            [self.navigationController pushViewController:view animated:YES];
            
        }
            break;
        case 2: //清除
        {
            [self clear];
            
        }
            break;
    
       
            
        default:
            break;
    }
    
    
    
}

//退出登录
-(void)outLoginButton{
 
    [[LoginModel shareLogin]clear];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:nil];
    
}

-(void)clear{
 
 [[SDImageCache sharedImageCache] clearDisk];
    [UIView show_success_progress:@"清除成功!"];
}

@end
