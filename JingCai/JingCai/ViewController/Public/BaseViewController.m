

NSInteger const kPageSize = 20;
#import "BaseViewController.h"
@interface BaseViewController()<UIGestureRecognizerDelegate>
@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.leftBtn.userInteractionEnabled = NO;
    DLog(@"current UIViewController is:%@",NSStringFromClass(self.class));
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
   // [UIView dismiss_progress];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.leftBtn.userInteractionEnabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_background_f1f1f1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    if ([self.navigationController.viewControllers count] > 1 || self.presentingViewController != nil){
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
        self.leftBtn.hidden = NO;
    }
    
    self.pageNo = 1;
}

-(NSMutableArray *)dataSoureArray{
    if(!_dataSoureArray){
        _dataSoureArray = [NSMutableArray new];
    }
    return _dataSoureArray;
}

- (UIButton *)leftBtn{
    if(!_leftBtn){
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, 0,25, 25);
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(5, -5, 0, 0);
        [_leftBtn setImage:[UIImage imageNamed:@"goback"] forState:0];
        [_leftBtn addTarget:self
                    action:@selector(leftBtnAction:)
          forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn setTitleColor:[UIColor blackColor] forState:0];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
    }
    
    return _leftBtn;
}

-(UIBarButtonItem *)rightBtnItem{
    if(!_rightBtnItem){
        _rightBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnAction:)];
        [_rightBtnItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIFont systemFontOfSize:16], NSFontAttributeName,
                                             [UIColor blackColor], NSForegroundColorAttributeName,
                                               nil] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem =_rightBtnItem;
    }
    return _rightBtnItem;
}

-(UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame=CGRectMake(0, 0, 40, 25);
        _rightBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        _rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_rightBtn setTitleColor:Color_black forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
        self.navigationItem.rightBarButtonItem=item;
    }
    return _rightBtn;
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, IOS7_TOP_Y, IPHONE_WIDTH, IPHONE_HEIGHT-IOS7_TOP_Y) style:self.tableViewStyle?self.tableViewStyle:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate  = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorColor = COLOR_tableView_separator;
        [self.view addSubview:_tableView];
        _tableView.separatorColor = [UIColor colorWithWhite:0.2 alpha:0.1];
        
    }
    return _tableView;
}
-(void)requestFail{
    if(self.pageNo != 1){
     
        [self.tableView hzxFooterEndRefreshing];
    }else{
        [self.tableView hzxHeaderEndRefreshing];
    }
}
- (void)hideShadow{
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}


-(void)iNeedALine
{
    [self.navigationController.navigationBar setBackgroundImage:imageNamed(@"nav_backcolor") forBarMetrics:UIBarMetricsDefault];
    CGRect rect = CGRectMake(0, 0, self.view.width, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,RGB(201, 201, 202).CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.navigationController.navigationBar.shadowImage= img;
}

#pragma mark --- 导航栏左侧按钮点击方法 ---

- (void)leftBtnAction:(UIButton *)sender
{
    //子类可以重写该方法
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 导航栏右侧按钮点击方法 ---

- (void)rightBtnAction:(id )sender
{
    //由子类实现具体的方法
}

#pragma mark --- 隐藏和显示标签栏 ---

- (void)hiddenTabBar
{
    [self.view addSubview:self.barTabImageView];
}

- (void)showTabBar
{
    [self.tabBarController.view addSubview:self.barTabImageView];
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 0;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{   
//    return nil;
//}
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    
//}
#pragma mark 基本设置
- (void)baseSettting
{
#ifdef __IPHONE_7_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
}

@end
