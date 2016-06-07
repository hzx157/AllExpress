
//商品详情

#import "ShopDetailsViewController.h"
#import "SGFocusImageFrame.h"
#import "UIView+SGFocusAddImage.h"
#import "ShopDetailsView.h"
#import "WebViewController.h"
#import "ShopCartViewController.h"
#import "ViewController.h"
#import "ShopStyleView.h"
#import "SureOrderViewController.h"
#import "UITapImageView.h"
#import "ShopDetailModel.h"
#import "XHImageViewer.h"
#import "ApiServer.h"
@interface ImgTitleButton : UIButton

@end

@interface ShopDetailsViewController ()<SGFocusImageFrameDelegate>{
    
}


@property (nonatomic, strong) ShopDetailsView *shopDetailsView; //商品信息展示
@property (nonatomic, strong) UITapImageView *headImageView; //商品信息展示
@property (nonatomic, strong) UIButton *likeBtn; //收藏按钮
@property (nonatomic, strong) UIButton *addShopCartBtn; //加入购物车按钮
@property (nonatomic, strong) UIButton *buyBtn; //购买按钮
@property (nonatomic, strong) UIView *transView; //透明视图
@property (nonatomic, strong) ShopStyleView *shopStyleView; //选择产品的样式和数量

@property (nonatomic, strong) ShopDetailModel *detailModel;
@end

@implementation ShopDetailsViewController


-(UITapImageView *)headImageView{
 
    if(!_headImageView){
        WEAKSELF;
        _headImageView = [[UITapImageView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 300.0)];
        [_headImageView addTapBlock:^(id obj) {
            XHImageViewer *view  = [[XHImageViewer alloc]init];
            [view showWithImageViews:@[weakSelf.headImageView] selectedView:weakSelf.headImageView];
        }];
        self.tableView.tableHeaderView = _headImageView;
    }
    return _headImageView;
}
//商品信息展示
- (ShopDetailsView *)shopDetailsView{
    if(!_shopDetailsView){
        _shopDetailsView = [[ShopDetailsView alloc] init];
        _shopDetailsView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_shopDetailsView];
    }
    return _shopDetailsView;
}

//收藏按钮
- (UIButton *)likeBtn{
    if(!_likeBtn){
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeBtn.backgroundColor = [UIColor whiteColor];
        [_likeBtn setTitleColor:[UIColor blackColor] forState:0];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_likeBtn setTitle:@"收藏" forState:0];
        [_likeBtn setTitle:@"已收藏" forState:UIControlStateSelected];
        [_likeBtn addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_likeBtn];
    }
    return _likeBtn;
}

//加入购物车按钮
- (UIButton *)addShopCartBtn{
    if(!_addShopCartBtn){
        _addShopCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addShopCartBtn.backgroundColor = [UIColor blackColor];
        [_addShopCartBtn setTitle:@"加入购物车" forState:0];
        _addShopCartBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_addShopCartBtn addTarget:self action:@selector(addShopCart:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addShopCartBtn];
    }
    return _addShopCartBtn;
}

//立即购买按钮
- (UIButton *)buyBtn{
    if(!_buyBtn){
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.backgroundColor = [UIColor redColor];
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_buyBtn setTitle:@"立即预订" forState:0];
        [_buyBtn addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_buyBtn];
    }
    return _buyBtn;
}

//选择产品样式和数量
- (ShopStyleView *)shopStyleView{
    if(!_shopStyleView){
        
        //透明视图
        _transView = [[UIView alloc] init];
        _transView.alpha = 0.5;
        _transView.backgroundColor = [UIColor blackColor];
        _transView.frame = CGRectMake(ZERO, ZERO, IPHONE_WIDTH, IPHONE_HEIGHT);
        [self.navigationController.view addSubview:_transView];
        
        _shopStyleView = [[ShopStyleView alloc] initWithFrame:CGRectMake(0, IPHONE_HEIGHT, IPHONE_WIDTH, IPHONE_HEIGHT - HeightScaleSize(70))];
        _shopStyleView.dic = self.dataSoureDic;
        [self.navigationController.view addSubview:_shopStyleView];
        
        WEAKSELF;
        _shopStyleView.add = ^(id object){
            [weakSelf removeView];
        };
        
        _shopStyleView.buy = ^(id object){
            [weakSelf removeView];
            SureOrderViewController *sureOrderVC = [[SureOrderViewController alloc] init];
            [sureOrderVC.dataSoureArray addObject: object];
            [weakSelf.navigationController pushViewController:sureOrderVC animated:YES];
        };
        
        _shopStyleView.delet = ^(id object){
            [weakSelf removeView];
        };
        
    }
    return _shopStyleView;
}

- (void)removeView{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.shopStyleView.top = IPHONE_HEIGHT;
    } completion:^(BOOL finished) {
        [self.transView removeFromSuperview];
        [self.shopStyleView removeFromSuperview];
        self.transView = nil;
        self.shopStyleView = nil;
    }];
  
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"商品详情";
    self.rightBtn.frame=CGRectMake(0, 0, 25, 25);
    [self.rightBtn setImage:imageNamed(@"gw") forState:0];
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50.0, 0);
    [self setup];
    [self getData];
 
}

#pragma mark --- 获取数据 ---

- (void)getData{
    [UIView show_loading_progress:@"加载中..."];
    [[RequestClient sharedClient] shop_details_prodoctid:self.shopId progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject, JCRespone *respone) {
        
        self.dataSoureDic = respone.data;
        [ShopDetailModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"imagelist" : [ImagelistModel class],
                     // @"statuses" : [Status class],
                     @"skulist" : [SkulistModel class]
                     // @"ads" : [Ad class]
                     };
        }];
        self.detailModel = [ShopDetailModel mj_objectWithKeyValues:respone.data];
        self.likeBtn.selected = self.detailModel.isfav;
        [UIView show_success_progress:@"加载成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error, id respone) {
        [UIView show_fail_progress:@"加载失败"];
    }];
}

#pragma mark --- 设置数据 ---

- (void)setDetailModel:(ShopDetailModel *)detailModel{
  
    _detailModel = detailModel;
    self.shopDetailsView.detailModel = detailModel;
    
    
    NSMutableArray *imgArr = [NSMutableArray array];
    for(int i = 0; i < [detailModel.imagelist count]; i++){
        ImagelistModel *model = detailModel.imagelist[i];
        [imgArr addObject:model.imageUrl];
    }
    if(imgArr.count == 0){
        [imgArr addObject:[Common getNULLString:detailModel.mainImage]];
    }
    
    WEAKSELF;
    [self.headImageView sd_setImageWithURL:UrlNamed_qiuniu_image2([imgArr firstObject],@"w",(int)self.view.width) placeholderImage:defaultLogo completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if(image){
            CGFloat scae = IPHONE_WIDTH/image.size.width;
            weakSelf.headImageView.height = image.size.height*scae;
        }else{
       
        }
        weakSelf.tableView.tableHeaderView = weakSelf.headImageView;
          [weakSelf setup];
        
    }];
    
//    [self.view cycleScrollView:self.advertise
//                   imageURLStr:imgArr
//                       imageID:nil];
}


#pragma mark --- 界面布局 ---

- (void)setup{
    

    
    self.shopDetailsView.frame = CGRectMake(ZERO, 0, IPHONE_WIDTH, 90);
    self.likeBtn.frame = CGRectMake(ZERO, IPHONE_HEIGHT - 40, IPHONE_WIDTH /4, 40);
    self.addShopCartBtn.frame = CGRectMake(self.likeBtn.right, self.likeBtn.top, (IPHONE_WIDTH - IPHONE_WIDTH/4)/2, 40);
    self.buyBtn.frame = CGRectMake(self.addShopCartBtn.right, self.likeBtn.top, self.addShopCartBtn.width, 40);
    [self.tableView reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 90;
    }
    return 44.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 0.0f;
    return 8.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
     static NSString *_identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifer];
    if(!cell){
     
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifer];
        if(indexPath.section == 0){
            [cell.contentView addSubview:self.shopDetailsView];
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    if(indexPath.section == 0){
        cell.textLabel.hidden = YES;
        
    }else{
      cell.textLabel.text  = @"图文详情";
     }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
        }
            break;
        case 1:
        {
            
            WebViewController *webVC = [[WebViewController alloc] init];
            webVC.urlstr = [NSString stringWithFormat:@"%@product/detail.htm?productId=%@&hideDownload=1",apiUrl,self.shopId];
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark --- 跳转到购物车 ---

- (void)rightBtnAction:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    ((ViewController *)([Common shareAppDelegate].window.rootViewController)).selectedIndex = 2;
    [((ViewController *)([Common shareAppDelegate].window.rootViewController)) handleSeletedTabBar:((ViewController *)([Common shareAppDelegate].window.rootViewController)).shopCartBtn];
}

#pragma mark --- 收藏 ---

- (void)like:(UIButton *)sender{
    
    sender.userInteractionEnabled = NO;
    if(sender.selected){ //取消收藏
        
        [[RequestClient sharedClient]user_delete_favorite_favId:[NSString stringWithFormat:@"%ld", (long)self.detailModel.productId] type:1 progress:^(NSProgress *uploadProgress) {
            ;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
            self.detailModel.isfav = NO;
            [UIView show_success_progress:@"取消收藏成功"];
            sender.userInteractionEnabled = YES;
            sender.selected = !sender.selected;
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
              sender.userInteractionEnabled = YES;
            [UIView show_fail_progress:respone.msg];
        }];
       
        
    }else{
        [[RequestClient sharedClient]user_add_favorite_favId:[NSString stringWithFormat:@"%ld", (long)self.detailModel.productId] type:1 progress:^(NSProgress *uploadProgress) {
             ;
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
             
             [UIView show_success_progress:@"收藏成功"];
             sender.userInteractionEnabled = YES;
             sender.selected = !sender.selected;
             self.detailModel.isfav = YES;
             
         } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
             [UIView show_success_progress:respone.msg];
             sender.userInteractionEnabled = YES;
         }];
       ;
    }
   
}

#pragma makr --- 加入购物车 ---

- (void)addShopCart:(UIButton *)sender{
    
    if(self.detailModel==nil){
        [UIView show_fail_progress:@"数据错误"];
        return;
    }
    
    self.shopStyleView.shopStyle = ShopStyle_addShopCart;
    self.shopStyleView.detailModel = self.detailModel;
    [UIView animateWithDuration:0.25 animations:^{
          self.shopStyleView.bottom = IPHONE_HEIGHT;
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark --- 立即购买 ---

- (void)buy:(UIButton *)sender{
    
    if(self.detailModel==nil){
        [UIView show_fail_progress:@"数据错误"];
        return;
    }
    
    self.shopStyleView.shopStyle = ShopStyle_buySHop;
      self.shopStyleView.detailModel = self.detailModel;
    [UIView animateWithDuration:0.25 animations:^{
        self.shopStyleView.bottom = IPHONE_HEIGHT;
       
    } completion:^(BOOL finished) {
        
    }];

}



@end

@implementation ImgTitleButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(10, ZERO, 100, contentRect.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(IPHONE_WIDTH - 30, (contentRect.size.height - 20)/2, 20, 20);
}

@end
