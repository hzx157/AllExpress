//
//  ZoneViewController.m
//  JingCai
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZoneViewController.h"
#import "TimeLineCell.h"
#import "KRVideoPlayerController.h"

@interface ZoneViewController ()
@property (nonatomic,strong)KRVideoPlayerController *videoController;
@end

@implementation ZoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"晶彩圈";
    
    self.leftBtn.hidden = YES;
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50.0, 0);
    self.tableView.rowHeight = [TimeLineCell getHeight];
    [self.tableView registerClass:[TimeLineCell class] forCellReuseIdentifier:@"TimeLineCell"];
    [self.tableView hzxAddLegendHeaderWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView hzxBeginRefreshing];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showTabBar];
}
-(void)getData{
  
    [[RequestClient sharedClient]user_video_progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        
        [self.tableView hzxHeaderEndRefreshing];
        [self.dataSoureArray removeAllObjects];
        [self.dataSoureArray addObjectsFromArray:respone.data];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        [UIView show_fail_progress:respone.msg];
        
        [self.tableView hzxHeaderEndRefreshing];
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
    
    return self.dataSoureArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.0f;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    static  NSString *_indetifier = @"TimeLineCell";
    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:_indetifier];
    if(!cell){
        cell = [[TimeLineCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:_indetifier];
    }
    
    cell.indexPath = indexPath;
    cell.model = self.dataSoureArray[indexPath.section];

    WEAKSELF;
    [cell setPlayBlock:^(UIButton *playButton,id model) {
        [weakSelf playVideoWithURL:urlNamed(model[@"video"])];
    }];
    
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
// 
//         TimeLineCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TimeLineCell"];
// 
//    // Layout the cell
//    
//    [cell layoutIfNeeded];
//    
//    // Get the height for the cell
//    
//    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    
//    // Padding of 1 point (cell separator)
//    CGFloat separatorHeight = 1;
//    
//    return height + separatorHeight;
//}
- (void)playVideoWithURL:(NSURL *)url
{
    if (!self.videoController) {
        
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH,IPHONE_HEIGHT)];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
            
        }];
        [self.videoController showInWindow];
        
    }
    self.videoController.contentURL = url;
}
@end
