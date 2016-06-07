

#define IMG @"img"
#define SELETEDIMG @"seletedImg"
#define TITLE @"title"

#import "ViewController.h"
#import "VipViewController.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

#pragma mark --- 界面布局 ---

- (void)setup{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.hidden = YES;
    _tabBarImg = [[UIImageView alloc] initWithFrame:CGRectMake(ZERO, IPHONE_HEIGHT - 50, IPHONE_WIDTH, 50)];
    _tabBarImg.backgroundColor = [UIColor whiteColor];
    _tabBarImg.userInteractionEnabled = YES;
    [self.view addSubview:_tabBarImg];
    
    UIImageView *line = [UIImageView new];
    line.backgroundColor = COLOR_tableView_separator;
    [_tabBarImg addSubview:line];
    [line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.0);
        make.height.mas_equalTo(0.5);
    }];

    _shopVC = [[ShopViewController alloc] init];
    _zoneVC = [[ZoneViewController alloc] init];
    VipViewController *vipVC = [VipViewController new];
    _shopCartVC = [[ShopCartViewController alloc] init];
    _persoanlVC = [[PersonalViewController alloc] init];
    
    NSArray *VCArr = @[_shopVC,vipVC,_shopCartVC,_zoneVC,_persoanlVC];
    NSMutableArray *NAVArr = [NSMutableArray array];
    for(int i = 0; i < VCArr.count; i++){
        BaseViewController *vc = [VCArr objectAtIndex:i];
        vc.barTabImageView = self.tabBarImg;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [NAVArr addObject:nav];
    }
    
    self.viewControllers = NAVArr;
    self.selectedIndex = 0;
    NSArray *arr = @[@{TITLE:@"首页",IMG:@"ic_index_default",SELETEDIMG:@"ic_index_default_enable"},
                     @{TITLE:@"代言人",IMG:@"tabbar_vip_normal",SELETEDIMG:@"tabbar_vip_select"},
                      @{TITLE:@"购物车",IMG:@"ic_index_shopping",SELETEDIMG:@"ic_index_shopping_enable"},
                     @{TITLE:@"晶彩圈",IMG:@"ic_index_cirle",SELETEDIMG:@"ic_index_cirle_enable"},//
                     @{TITLE:@"我",IMG:@"ic_index_person",SELETEDIMG:@"ic_index_person_enable"},];
    int height = 50;
    int width = IPHONE_WIDTH/arr.count;
    for(int i = 0; i < NAVArr.count; i++){
        tabBarButton *btn = [tabBarButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.frame = CGRectMake(i*width, 0, width, height);
        [btn setImage:imageNamed(arr[i][IMG])forState:0];
        [btn setImage:imageNamed(arr[i][SELETEDIMG]) forState:UIControlStateSelected];
        btn.tag = 1010+i;
        [btn setTitle:arr[i][TITLE] forState:UIControlStateNormal];
        [btn setTitleColor:ColorWithRGB(38.0, 39.0, 40.0, 1.0) forState:0];
        [btn setTitleColor:ColorWithRGB(250.0, 39.0, 66, 1.0) forState:UIControlStateSelected];
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(-20, 15, 0, 0)];
//        [btn setTitleEdgeInsets:UIEdgeInsetsMake(23, 0, 0, 30)];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(handleSeletedTabBar:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBarImg addSubview:btn];
        
        if(i == 2){
            self.shopCartBtn = btn;
        }
    }
    
    //当前选中的按钮
    UIButton *btn = (UIButton *)[self.view viewWithTag:1010];
    btn.selected = YES;
    _selectBtn = btn;
}

#pragma mark --- 选择标签栏按钮 ---

- (void)handleSeletedTabBar:(tabBarButton *)sender{
   
//    if(sender.tag == 1015){
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"晶彩圈暂时没有开通" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertView show];
//        return;
//    }
    if(self.selectBtn == sender){
    }else{
        self.selectedIndex = sender.tag - 1010;
        sender.selected = YES;
        self.selectBtn.selected = NO;
        self.selectBtn = sender;
    }
}


@end

@implementation tabBarButton

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.titleLabel.contentMode = UIViewContentModeCenter;
    
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(contentRect.size.width/2 - 10, 6, 20, 20);
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 15, contentRect.size.width, contentRect.size.height);
}



@end
