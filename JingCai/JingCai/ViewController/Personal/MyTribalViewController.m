//
//  MyTribalViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/24.
//  Copyright © 2016年 apple. All rights reserved.
//



#import "MyTribalViewController.h"
#import "UIButton+Block.h"
@interface MyTribalViewController()
@property (nonatomic,strong)NSMutableArray *btnArray;
@property (nonatomic,strong)UIButton *selectButton;
@property (nonatomic,strong)NSLock *lock;
@end
@implementation MyTribalViewController

-(void)viewDidLoad{

 
    [super viewDidLoad];
    self.title = @"我的部落";
    
    self.tableViewStyle = UITableViewStyleGrouped;
    [self setupHeadView];
    self.tableView.rowHeight = 100.0f;
    self.tableView.top = IOS7_TOP_Y + 54.0f;
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 10.0)];
    WEAKSELF;
    [self.tableView hzxAddLegendHeaderWithRefreshingBlock:^{
        
        [weakSelf.dataSoureArray[weakSelf.selectButton.tag-100] setObject:@(1) forKey:@"pageNo"];
        [weakSelf getData:weakSelf.selectButton.tag-100  page:1];
        
    }];
    [self.tableView hzxAddLegendFooterWithRefreshingBlock:^{
        
        NSInteger page = [[weakSelf.dataSoureArray[weakSelf.selectButton.tag-100] objectForKey:@"pageNo"] integerValue] + 1;
        [weakSelf.dataSoureArray[weakSelf.selectButton.tag-100] setObject:@(page) forKey:@"pageNo"];
        [weakSelf getData:weakSelf.selectButton.tag-100  page:page];
    }];
    
}
-(void)setupHeadView{

    
    
    UIView *_view = [[UIView alloc]initWithFrame:CGRectMake(0, IOS7_TOP_Y + 10.0f, IPHONE_WIDTH, 44.0f)];
    _view.backgroundColor = ColorWithRGB(227.0, 228.0, 230.0, 1.0);
    [self.view addSubview:_view];
    NSArray *array = @[@"晶彩达人",@"大晶彩",@"小晶彩"];
    CGFloat width = _view.width/array.count;
    
  
    
    UIButton *testButton;
    for(NSInteger i = 0; i<array.count; i++){
     
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"data":@[],
                                                                                    @"pageNo":@(1),
                                                                                    @"pageSize":@"20"}];
        [self.dataSoureArray addObject:dict];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i == 0 ? 0 : testButton.right+0.5, 0.5, width, _view.height - 1);
        button.titleLabel.font = fontSystemOfSize(15.0);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        if(i == 0){
            [button setBackgroundColor:_view.backgroundColor];
            self.selectButton = button;
        }
        button.tag =  i + 100;
        WEAKSELF;
        typeof(_view) __weak _weakSelf = _view;
        [button addActionHandler:^(NSInteger tag) {
            [weakSelf.selectButton setBackgroundColor:[UIColor whiteColor]];
            UIButton *btn = [_weakSelf viewWithTag:tag];
            [btn setBackgroundColor:_weakSelf.backgroundColor];
             weakSelf.selectButton = btn;
            [weakSelf.tableView reloadData];
           
        }];
        [button setTitle:array[i] forState:UIControlStateNormal];
        testButton = button;
        [_view addSubview:button];
    }
    
    for(NSInteger i = 0; i < self.dataSoureArray.count; i++){
        [self getData:i page:1];
    }
    
    
}
-(void)getData:(NSInteger)type page:(NSInteger)page{
   
    
    [self.lock lock];
    NSMutableDictionary *dict = self.dataSoureArray[type];
    NSMutableArray *array = [NSMutableArray arrayWithArray:dict[@"data"]];
    [dict removeObjectForKey:@"data"];
    
      [[RequestClient sharedClient]user_myDaili:type dict:dict progress:^(NSProgress *uploadProgress) {
          ;
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
          if(page == 1){
              [array removeAllObjects];
              [self.tableView hzxHeaderEndRefreshing];
          }else{
              [self.tableView hzxFooterEndRefreshing];
          }
          
          [array addObjectsFromArray:respone.data[@"list"]];
          [dict setObject:array forKey:@"data"];
          [self.dataSoureArray replaceObjectAtIndex:type withObject:dict];
          
          if(self.selectButton.tag == type+100){
              [self.tableView reloadData];
          }
          
          [self.lock unlock];
          
      } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
          if(page == 1){
              
              [self.tableView hzxHeaderEndRefreshing];
          }else{
              [self.tableView hzxFooterEndRefreshing];
          }
          [dict setObject:array forKey:@"data"];
          [self.dataSoureArray replaceObjectAtIndex:type withObject:dict];
           [self.lock unlock];
          [UIView show_fail_progress:respone.msg];
      }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
     NSMutableDictionary *dict = self.dataSoureArray[self.selectButton.tag - 100];
    
    return [dict[@"data"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indetifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
    if(!cell){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indetifier];
        cell.textLabel.numberOfLines = 3;
        cell.backgroundColor = [UIColor whiteColor];
    
    }
    
    NSMutableDictionary *data = self.dataSoureArray[self.selectButton.tag - 100];
    NSDictionary *dict = data[@"data"][indexPath.row];
   
    cell.textLabel.text = [NSString stringWithFormat:@"昵称: %@\n", [Common getNULLString:dict[@"nick_name"]]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"会员类型: %@",[LoginModel getRoleName:[[Common getNULLString:dict[@"role_name"]] integerValue]]];
    [cell.imageView sd_setImageWithURL:UrlNamed_qiuniu_image1(dict[@"user_image"],60,60) placeholderImage:defaultLogo];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            
        }
            break;
        case 1:{
            
            
        }
            break;
            
        default:
            break;
    }
    
}

@end
