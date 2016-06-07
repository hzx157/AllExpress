//
//  ShopViewController.m
//  JingCai
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

static CGFloat adHeight = 150.0f;

#import "ShopViewController.h"
#import "LoginViewController.h"
#import "ShopCell.h"
#import "ShopDetailsViewController.h"
#import "ScanQRCodeViewController.h"
#import "ShopCCell.h"
#import "SYStickHeaderWaterFallLayout.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
@interface ShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SYStickHeaderWaterFallDelegate,SGFocusImageFrameDelegate>
@property (nonatomic,weak)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *items;
@end

@implementation ShopViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showTabBar];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"首页";

    self.leftBtn.hidden = YES;
//    [self pushHome];
    [self setup];
    [self.collectionView hzxAddLegendHeaderWithRefreshingBlock:^{
        self.pageNo = 1;
        [self getData];
    }];
    
    [self.collectionView hzxAddLegendFooterWithRefreshingBlock:^{
        self.pageNo ++;
        [self getData];
    }];
    
    [self.collectionView hzxBeginRefreshing];
 
    
}
#define  edgeInsets UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
-(void)setup{
  
    
//    CGFloat width = (IPHONE_WIDTH - edgeInsets.left*3)/2;
    
    SYStickHeaderWaterFallLayout *layout = [[SYStickHeaderWaterFallLayout alloc]init];
    layout.isStickyHeader = NO;
    layout.isTopForHeader = YES;
//    layout.itemSize = CGSizeMake(width, SIZE_SHOP_ALLHEIGHT);
//    layout.minimumLineSpacing = edgeInsets.bottom;
//    layout.minimumInteritemSpacing = edgeInsets.left;
    layout.delegate = self;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, IOS7_TOP_Y, IPHONE_WIDTH, IPHONE_HEIGHT - IOS7_TOP_Y - 50.0) collectionViewLayout:layout];
    collectionView.backgroundColor = ColorWithRGB(240.0, 241.0, 242.0, 1.0);
    [collectionView registerClass:[ShopCCell class] forCellWithReuseIdentifier:@"ShopCCell"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
   // collectionView.contentInset = edgeInsets;
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
}


- (void)getData{
    
    
    [[RequestClient sharedClient]index_page_typeprogress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        
        self.items = [NSMutableArray new];
      //  `banner_process` '处理(1=代言人，2=合作商,3=链接)',
        NSInteger i = 0;
        for(NSDictionary *dic in respone.data){
            SGFocusImageItem *item = [[SGFocusImageItem alloc]initWithTitle:@"" image:@"" tag:i imageURLStr:dic[@"bannerImage"] imageID:dic[@"banner_process"]];
            [self.items addObject:item];
            [self.collectionView reloadData];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        ;
    }];
    
    
    [[RequestClient sharedClient] shop_list_pagesize:kPageSize pageno:self.pageNo progress:^(NSProgress *uploadProgress) {
        
//      NSLog(@"-----\n --------n %f",1.0* uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask *task, id responseObject, JCRespone *respone) {
        
        NSArray *array = respone.data[@"list"];
        
        if(self.pageNo == 1){
            [self.dataSoureArray removeAllObjects];
            [self.dataSoureArray addObjectsFromArray:array];
             [self.collectionView hzxHeaderEndRefreshing];
        }else{
        
            [self.dataSoureArray addObjectsFromArray:array];
             [self.collectionView hzxFooterEndRefreshing];
        
        }
        
        [self.collectionView hzxHiddenFooter:!(array.count == kPageSize)];
        
        
        [self.collectionView reloadData];
       
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error, JCRespone *respone) {
        if(self.pageNo != 1){
            
            [self.collectionView hzxFooterEndRefreshing];
        }else{
            [self.collectionView hzxHeaderEndRefreshing];
        }
        
        [UIView show_fail_progress:respone.msg];
    }];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSoureArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    ShopCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShopCCell" forIndexPath:indexPath];
    if(!cell){
        cell = [[ShopCCell alloc]init];
    }
//    cell.backgroundColor = [UIColor whiteColor];
    
    cell.indexPath = indexPath;
    cell.dict = self.dataSoureArray[indexPath.row];
    return cell;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(SYStickHeaderWaterFallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    

    return SIZE_SHOP_ALLHEIGHT ;
}


- (CGFloat)collectionView:(nonnull UICollectionView *)collectionView
                   layout:(nonnull SYStickHeaderWaterFallLayout *)collectionViewLayout
    widthForItemInSection:( NSInteger )section
{
    
    return (IPHONE_WIDTH - edgeInsets.left*3)/2;;
    
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(SYStickHeaderWaterFallLayout *)collectionViewLayout heightForHeaderAtIndexPath:(NSIndexPath *)indexPath{
    if(self.items.count == 0)
        return 0.0f;
    return adHeight;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
   
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
    
    
        if(self.items.count == 0)
            return nil;
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        SGFocusImageFrame *imageViews = [[SGFocusImageFrame alloc]initWithFrame:CGRectMake(0, 0, collectionView.width, adHeight) delegate:self imageItems:self.items];
        [view addSubview:imageViews];
        
        return view;
    }
    return nil;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [self hiddenTabBar];
    ShopDetailsViewController *shopDetailsVC = [[ShopDetailsViewController alloc] init];
    shopDetailsVC.shopId = [Common getNULLString:self.dataSoureArray[indexPath.row][@"productId"]];
    [self.navigationController pushViewController:shopDetailsVC animated:YES];
    
}

- (void)pushHome{
    if(SINGLE.isLogin){
    }else{
        [Common shareAppDelegate].window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    }
}

@end