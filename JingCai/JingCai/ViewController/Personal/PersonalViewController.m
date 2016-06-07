
#import "PersonalViewController.h"
#import "PersonalView.h"
#import "OrderListView.h"
#import "UIButton+Block.h"
#import "UserSetViewController.h"
#import "MyRefereesViewController.h"
#import "MyCollectionViewController.h"
#import "JCShare.h"
#import "MyMoneyViewController.h"
#import "MyYejiViewController.h"
#import "MyOdersViewController.h"
#import "WebViewController.h"
#import "MyInfoViewController.h"
#import "MyRoleViewController.h"
#import "MyTribalViewController.h"
#import "UIAlertView+Block.h"
#import "MyInviteCodeViewController.h"
@interface PersonalViewController ()
@property (nonatomic, copy)NSArray *imgArray;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) PersonalView *persoanlView;
@property (nonatomic, strong) OrderListView *orderListView;

@end

@implementation PersonalViewController

- (UIView *)headView{
    if(!_headView){
        _headView = [[UIView alloc] init];
    }
    return _headView;
}

- (PersonalView *)persoanlView{
    if(!_persoanlView){
        _persoanlView = [[PersonalView alloc] init];
        WEAKSELF;
        
        //点击头像
        [_persoanlView setImageBlock:^{
            [weakSelf hiddenTabBar];
            [weakSelf.navigationController pushViewController:[MyInfoViewController new] animated:YES];
        }];
        
        //点击加入代言人
        [_persoanlView setButtonBlock:^(UIButton *button) {
              [weakSelf hiddenTabBar];
            if(button.selected ){ //查看二维码
                [weakSelf.navigationController pushViewController:[MyInviteCodeViewController new] animated:YES];
                
            }else{//加入代言人
                [weakSelf.navigationController pushViewController:[MyRoleViewController new] animated:YES];
            }
            
        }];
        
        [self.headView addSubview:_persoanlView];
    }
    return _persoanlView;
}

- (OrderListView *)orderListView{
    if(!_orderListView){
        _orderListView = [[OrderListView alloc] init];
        [self.headView addSubview:_orderListView];
    }
    return _orderListView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    self.leftBtn.hidden = YES;
    self.dataSoureArray = [[NSMutableArray alloc] initWithArray:@[@"我的全部订单",@"我的收藏",@"我的业绩",@"我的部落",@"我的余额",@"邀请好友",@"我的邀请码",@"我的推荐人信息",@"会员类型",@"设置"]];
    _imgArray = @[@"ic_all_order",@"ic_my_collect",@"ic_achievement",@"ic_delivery",@"ic_my_money",@"ic_recomend_to_friend",@"ic_my_invite_code",@"ic_recomend_info",@"ic_member_type",@"ic_setting"];
    [self setup];
  //  [self.rightBtn setImage:imageNamed(@"ic_setting") forState:UIControlStateNormal];
}
-(void)rightBtnAction:(id)sender{
    [self hiddenTabBar];
    [self.navigationController pushViewController:[UserSetViewController new] animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
 
    [super viewWillAppear:animated];
      self.persoanlView.dic = nil;
}
#pragma mark --- 界面布局 ---

- (void)setup{
    
    self.persoanlView.frame = CGRectMake(ZERO, ZERO, IPHONE_WIDTH, 150);
    self.orderListView.frame = CGRectMake(ZERO, self.persoanlView.bottom , IPHONE_WIDTH, IPHONE_WIDTH/5);
    
    self.headView.frame = CGRectMake(ZERO, ZERO, IPHONE_WIDTH, 170+IPHONE_WIDTH/5 );
    self.tableView.tableHeaderView = self.headView;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.frame = CGRectMake(0, IOS7_TOP_Y, IPHONE_WIDTH, IPHONE_HEIGHT-IOS7_TOP_Y-50);
    
    UIButton *outButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [outButton setBackgroundColor:ColorWithRGB(91.0, 202.0, 116.0, 1.0)];
    outButton.alpha = 0.7;
    outButton.layer.masksToBounds = YES;
    outButton.layer.cornerRadius = 5.0f;
    [outButton setTitle:@"联系客服 020-37033050" forState:UIControlStateNormal];
    outButton.titleLabel.font = fontSystemOfSize(15.0);
    [outButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    outButton.frame = CGRectMake(20, 20.0, IPHONE_WIDTH-40, 40.0);
    
    WEAKSELF;
    [outButton addActionHandler:^(NSInteger tag) {
        
        [Common getPhoneNuber:@"02037033050" view:weakSelf.view];
    }];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 80.0)];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    [footerView addSubview:outButton];
    
    
    
    
    self.orderListView.block = ^(NSInteger tag){
        [weakSelf hiddenTabBar];
        MyOdersViewController *orderVC = [[MyOdersViewController alloc] init];
        
        switch (tag){
            case 0:{
                //待付款
                orderVC.orderType = OrderTypeWaitPay;
            }
                break;
            case 1:{
                //待发货
                orderVC.orderType = OrderTypeWaitSend;

            }
                break;
            case 2:{
                //待收货
                orderVC.orderType = OrderTypeWaitRecive;

            }
                break;
            case 3:{
                //已收货
                orderVC.orderType = OrderTypeOrderSuccess;

            }
                break;
            case 4:{
                //退款
                orderVC.orderType = OrderTypeAllBack;
            }
                break;
            default:
                break;
        }
        [weakSelf.navigationController pushViewController:orderVC animated:YES];
    };
}

#pragma mark --- 表视图 ---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoureArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.imageView.image = imageNamed(_imgArray[indexPath.row]);
    cell.textLabel.text = self.dataSoureArray[indexPath.row];
    cell.textLabel.font = fontSystemOfSize(16.0);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hiddenTabBar];
    switch (indexPath.row){
        case 0:{
            //我的全部订单
            [self.navigationController pushViewController:[MyOdersViewController new] animated:YES];
        }
            break;
        case 1:{
            //我的收藏
            [self.navigationController pushViewController:[MyCollectionViewController new] animated:YES];
        }
            break;
        case 2:{
            
            if([LoginModel shareLogin].roleId != roleTypeAgent){
                [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                    ;
                } title:@"提示" message:@"快去升级成为合作商吧~~" cancelButtonName:@"确定" otherButtonTitles:nil, nil];
                return;
            }
            //我的业绩
              [self.navigationController pushViewController:[MyYejiViewController new] animated:YES];
        }
            break;
        case 3:{
            //我的部落
            [self.navigationController pushViewController:[MyTribalViewController new] animated:YES];
        }
            break;
        case 4:{
            
            //我的余额
            [self.navigationController pushViewController:[MyMoneyViewController new] animated:YES];
        }
            break;
        case 5:{
            //邀请好友
            NSString *string =@"【晶彩形象】向您推荐一个非常好用的app" ;
            NSString *link = apiDownloadUrl;
            if([LoginModel shareLogin].roleId > roleTypeNormal){
                string = [NSString stringWithFormat:@"【邀请码:%@】向您推荐一个非常好用的app",[LoginModel shareLogin].refereeCode];
                link = [link stringByAppendingString:[NSString stringWithFormat:@"?code=%@",[LoginModel shareLogin].refereeCode]];
            }
            [JCShare showTitle:string desc:@"点击查看更多" image:nil link:link Success:^(OSMessage *message) {
                ;
            } Fail:^(OSMessage *message, NSError *error) {
                ;
            }];
        }
            break;
        case 6: //我的邀请码
        {
            
            //普通用户没有邀请码
            if([LoginModel shareLogin].roleId == roleTypeNormal){
                
                [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                    ;
                } title:@"" message:@"你现在是普通用户,需要成为代言人或合作商才有邀请码" cancelButtonName:@"确定" otherButtonTitles:nil, nil];
                return;
            }
            
            [self.navigationController pushViewController:[MyInviteCodeViewController new] animated:YES];
            
        }
            break;
        case 7:{
            //我的推荐人信息
            [self.navigationController pushViewController:[MyRefereesViewController new] animated:YES];
        }
            break;
        case 8:{
            //会员类型
            [self.navigationController pushViewController:[MyRoleViewController new] animated:YES];
        }
            break;
        case 9:{
            //设置
            [self.navigationController pushViewController:[UserSetViewController new] animated:YES];
        }
            break;
        default:
            break;
    }
}

@end

