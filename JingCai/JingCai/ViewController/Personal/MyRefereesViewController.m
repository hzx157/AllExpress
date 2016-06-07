//
//  MyRefereesViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyRefereesViewController.h"

@interface MyRefereesViewController ()
@property (nonatomic,weak)UIButton *avtorButton;
@property (nonatomic,copy)NSArray *titleArray;
@property (nonatomic,strong)LoginModel *userModel;
@end

@implementation MyRefereesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"我的推荐人信息";
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.rowHeight = 44.0f;
    _titleArray = @[@"昵称",@"会员类型",@"性别",@"地区"];
    [self setupData];
    [self setupHeadView];
    [self getData];
}
-(void)getData{
 
    [[RequestClient sharedClient]user_myRefereesInfo_id:@"" progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        
    
        self.userModel = [LoginModel mj_objectWithKeyValues:respone.data];
        if(!self.userModel){
            [UIView show_fail_progress:@"获取失败，可能你还没有推荐人哦"];
        }
        [self setupData];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        [UIView show_fail_progress:respone.msg];
        
        
    }];
}
-(void)setupData{

    NSString *(^block)(NSString *string) = ^NSString*(NSString *string){
     
        if(string.length <=0){
            return @"暂无";
        }
        
        
        return [Common getNULLString:string];
    };
    
    
    [self.dataSoureArray removeAllObjects];
    NSArray *array = @[block(self.userModel.nickName),[LoginModel getRoleName:self.userModel.roleId],self.userModel.sex == 1 ? @"男" : @"女",block([NSString stringWithFormat:@"%@%@",[Common getNULLString:self.userModel.provice],[Common getNULLString:self.userModel.city]])];
    [self.dataSoureArray addObjectsFromArray:array];
    [self.avtorButton sd_setImageWithURL:urlNamed(self.userModel.userImage) forState:UIControlStateNormal placeholderImage:defaultLogo];
}
-(void)setupHeadView{
 
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 140.0f)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:imageNamed(@"ic_person_bg")];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [view insertSubview:imageView atIndex:0];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
   //  view.backgroundColor = [UIColor colorWithPatternImage:imageNamed(@"ic_person_bg")];
    self.tableView.tableHeaderView = view;
   
    UIButton *avtorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:avtorButton];
    [avtorButton sd_setImageWithURL:urlNamed([Common getNULLString:[LoginModel shareLogin].userImage]) forState:0 placeholderImage:defaultLogo];
    avtorButton.layer.cornerRadius = 35.0f;
    avtorButton.layer.masksToBounds = YES;
    [avtorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.centerY.mas_equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(70.0, 70.0));
    }];
    _avtorButton = avtorButton;
    
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
    }
    cell.textLabel.text = _titleArray[indexPath.row];
     cell.detailTextLabel.text = self.dataSoureArray[indexPath.row];
//    cell.textLabel.font = fontSystemOfSize(15.0);
    return cell;
}



@end
