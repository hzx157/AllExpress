//
//  MyInfoViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyInfoViewController.h"
#import "ChooseActionSheet.h"
#import "ChoosePhotoAlbum.h"
#import "CityPickerActionSheet.h"
#import "NickNameViewController.h"
#import "AdressViewController.h"
#import "XHImageViewer.h"
@interface MyInfoViewController ()
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)UIImage *avtiorImage;
@property (nonatomic,strong) CityPickerActionSheet *sheet;
@property (nonatomic,strong) ChoosePhotoAlbum *photoAlbum;
@end

@implementation MyInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    _titleArray = @[@"头像",@"昵称",@"性别",@"地区",@"我的收货地址"];
    NSArray*dataArray = @[[Common getNULLString:[LoginModel shareLogin].userImage],[Common getNULLString:[LoginModel shareLogin].nickName],[self getSex:[NSString stringWithFormat:@"%ld",[LoginModel shareLogin].sex]],[NSString stringWithFormat:@"%@%@",[Common getNULLString:[LoginModel shareLogin].provice],[Common getNULLString:[LoginModel shareLogin].city]],@" "];
    [self.dataSoureArray addObjectsFromArray:dataArray];
    
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.rowHeight = 65.0f;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.avtiorImage = defaultLogo;

    
}
-(NSString *)getSex:(NSString *)sex{
 
    if([sex isEqualToString:@"男"]){
        return @"0";
    }else if ([sex isEqualToString:@"女"]){
       return @"1";
    }else if ([sex isEqualToString:@"0"]){
        return @"男";
    }else if ([sex isEqualToString:@"1"]){
        return @"女";
    }
    return @"1";
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.titleArray count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *iindetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iindetifier];
    UIImageView *imageView = [cell.contentView viewWithTag:888];
    if(!cell){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iindetifier];
        if(!imageView){
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(IPHONE_WIDTH - 80.0, 0, 40.0, 40.0)];
            imageView.centerY = tableView.rowHeight/2;
            imageView.layer.cornerRadius = 40.0/2;
            imageView.layer.masksToBounds = YES;
            imageView.clipsToBounds = YES;
            imageView.tag = 888;
            imageView.image = self.avtiorImage;
            WEAKSELF;
            [imageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                [weakSelf imageShow:gestureRecoginzer];
            }];
            [cell.contentView addSubview:imageView];
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.titleArray[indexPath.row];
//    cell.textLabel.font = fontSystemOfSize(15.0);
    
    
    cell.detailTextLabel.text = self.dataSoureArray[indexPath.row];
    cell.detailTextLabel.hidden = NO;
    imageView.hidden = YES;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.detailTextLabel.hidden = YES;
            imageView.hidden = NO;
            imageView.image = self.avtiorImage;
            [imageView sd_setImageWithURL:urlNamed(self.dataSoureArray[indexPath.row]) placeholderImage:self.avtiorImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                ;
            }];
        }
            break;
        case 1:
        {
            
        }
            break;
            
            
        default:
            break;
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    
    
    switch (indexPath.row) {
        case 0: //头像
        {
            [[[ChooseActionSheet alloc]init]showChooseActionSheetBlock:^(NSInteger buttonIndex, BOOL isCannel) {
                if(isCannel)
                    return ;
                
                _photoAlbum = [ChoosePhotoAlbum shareSinge];
                _photoAlbum.isEditedImage = YES;
                _photoAlbum.ViewController = self;
                if(buttonIndex == 0){
                   [_photoAlbum takePhoto:^(UIImage *image) {
                       self.avtiorImage = image;
                       [self updateAvtor:image tag:indexPath.row];
                        [tableView reloadData];
                   }];
                }else{
                  [_photoAlbum localPhoto:^(UIImage *image) {
                   
                      self.avtiorImage = image;
                      [self updateAvtor:image tag:indexPath.row];
                      [tableView reloadData];
                  }];
                }
                
                
            } cancelButtonTitle:@"取消" array:@[@"拍照",@"从相册选择"]];
            
        }
            break;
        case 1: //修改昵称
        {
             NickNameViewController* view  = [NickNameViewController new];
            [self.navigationController pushViewController:view animated:YES];
            view.block = ^(NSString *name){
                [self.dataSoureArray replaceObjectAtIndex:indexPath.row withObject:name];
                [tableView reloadData];
            };
            
        }
            break;
        case 2: //性别
        {
            NSArray *array = @[@"男",@"女"];
            [[[ChooseActionSheet alloc]init]showChooseActionSheetBlock:^(NSInteger buttonIndex, BOOL isCannel) {
                if(isCannel)
                    return ;
                
                [self.dataSoureArray replaceObjectAtIndex:indexPath.row withObject:array[buttonIndex]];
                [tableView reloadData];
                [self updateSex:array[buttonIndex]];
                
            } cancelButtonTitle:@"取消" array:array];
            
        }
            break;
        case 3: //地区
        {
            WEAKSELF;
           _sheet =  [[CityPickerActionSheet alloc]initWithCity:@"" block:^(CityLocation *locate) {

               [weakSelf updateCity:locate];
                [weakSelf.dataSoureArray replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%@%@%@",locate.state,locate.city,locate.district]];
               [tableView reloadData];
            }];
            
        }
            break;
        case 4: //我的收货地址
        {
            [self.navigationController pushViewController:[AdressViewController new] animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    
    
}

-(void)updateAvtor:(UIImage *)image tag:(NSInteger)row{
    
   [[JCUploadFile shareUploadFile]putData:UIImageJPEGRepresentation(image, 0.5) key:[NSString stringWithFormat:@"%f.jpeg",[NSDate timeIntervalSinceReferenceDate]] fileSucceeded:^(NSURLResponse *operation, NSInteger index, NSString *key) {
       DLog(@"成功 = %@",[JCUploadFile getUrl:key]);
       
          [[RequestClient sharedClient]user_update_image:[JCUploadFile getUrl:key] progress:^(NSProgress *uploadProgress) {
              ;
          } success:^(NSURLSessionDataTask *task, id responseObject, JCRespone *respone) {
              
              [self.dataSoureArray replaceObjectAtIndex:row withObject:[JCUploadFile getUrl:key]];
              [self.tableView reloadData];
              [LoginModel shareLogin].userImage = [JCUploadFile getUrl:key];
              [[LoginModel shareLogin]save];
              [[Common shareAppDelegate]login];
              
          } failure:^(NSURLSessionDataTask *task, NSError *error, JCRespone *respone) {
              [UIView show_fail_progress:respone.msg];
          }];
          
       
       
       
   } fileSucceeded:^(NSURLResponse *operation, NSInteger index, NSDictionary *error) {
       DLog(@"错误 = %@",error);
        [UIView show_fail_progress:@"上传头像失败"];
   } uploadOneFileProgressBlock:^(NSURLResponse *operation, NSInteger index, double percent) {
      DLog(@"进度 = %f",percent);
   }];

}
-(void)updateSex:(NSString *)sex{
  
    
    [[RequestClient sharedClient]user_update_sex:[self getSex:sex] progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask *task, id responseObject, JCRespone *respone) {
        
        [LoginModel shareLogin].sex = [[self getSex:sex] integerValue];
        [[LoginModel shareLogin]save];
        [[Common shareAppDelegate]login];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error, JCRespone *respone) {
        [UIView show_fail_progress:respone.msg];
    }];

}

-(void)updateCity:(CityLocation *)lcationModel{

  [[RequestClient sharedClient]user_update_province:lcationModel.state toCity:lcationModel.city toDistrict:lcationModel.district progress:^(NSProgress *uploadProgress) {
      ;
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
      
      [LoginModel shareLogin].provice = lcationModel.state;
      [LoginModel shareLogin].city = lcationModel.city;
      [LoginModel shareLogin].district = lcationModel.district;
      [[LoginModel shareLogin]save];
      [[Common shareAppDelegate]login];
      
  } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
      [UIView show_fail_progress:respone.msg];
  }];
}



//图片浏览
-(void)imageShow:(UIGestureRecognizer *)tap{
    XHImageViewer * viewer = [[XHImageViewer alloc]initWithImageViewerWillDismissWithSelectedViewBlock:^(XHImageViewer *imageViewer, UIImageView *selectedView, NSInteger index) {
        ;
    } didDismissWithSelectedViewBlock:^(XHImageViewer *imageViewer, UIImageView *selectedView, NSInteger index) {
        ;
    } didChangeToImageViewBlock:^(XHImageViewer *imageViewer, UIImageView *selectedView, NSInteger index) {
        ;
    }];
    [viewer showWithImageViews:@[tap.view] selectedView:(UIImageView *)tap.view];
    
}

@end
