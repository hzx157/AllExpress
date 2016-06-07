//
//  ChoosePhotoAlbum.m
//  Gone
//
//  Created by xiaowuxiaowu on 15/7/2.
//  Copyright (c) 2015年 xiaowuxiaowu. All rights reserved.
//

#import "ChoosePhotoAlbum.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>


@interface ChoosePhotoAlbum()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation ChoosePhotoAlbum

+(ChoosePhotoAlbum *)shareSinge {

     ChoosePhotoAlbum *album;

        album = [[ChoosePhotoAlbum alloc]init];
        album.maximumNumberOfSelection = 1;

    return album;

}


//从相册选择
-(void)localPhoto:(ChoosePhotoAlbumBlock)block{
    if(![self isOpen]){
        
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = self.isEditedImage;
    [self.ViewController presentViewController:picker animated:YES completion:nil];
    self.block = block;
}



//拍照
-(void)takePhoto:(ChoosePhotoAlbumBlock)block{
    
    if(![self isOpen]){
        
        return;
    }
    
     self.block = block;
    
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = self.isEditedImage;
        //资源类型为照相机
        picker.sourceType = sourceType;
      
      
        [self.ViewController presentViewController:picker animated:YES completion:nil];
        
    }else {
        //DLog(@"该设备无摄像头");
    }
}
//录制视频
-(void)takeVideo:(ChooseVideoAlbumBlock)block{
    
    
    if(![self isOpen]){
        
        return;
    }
    
    self.videoBlock = block;
    
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;//;self.isEditedImage;
        //资源类型为照相机
        picker.sourceType = sourceType;
     
        //picker.mediaTypes =
      //  [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        // 确定摄像，非照像。
          NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
          picker.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
           picker.videoMaximumDuration = 10.0;
           picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
           picker.modalPresentationStyle =UIModalPresentationPopover;
            
    
        [self.ViewController presentViewController:picker animated:YES completion:NULL];
        
    }else {
    }

}

#pragma 用户选择好图片后的回调函数



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        ;
    }];
    
    //[picker release];
    
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        //保存图片到相册
        UIImage *tempSaveImage= self.isEditedImage ? [info objectForKey:@"UIImagePickerControllerEditedImage"] : info[@"UIImagePickerControllerOriginalImage"];
        UIImageWriteToSavedPhotosAlbum(tempSaveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    UIImage *tempSaveImage= self.isEditedImage ? [info objectForKey:@"UIImagePickerControllerEditedImage"] : info[@"UIImagePickerControllerOriginalImage"];
   

  
    
    if (tempSaveImage != nil) {
        
     
        if (tempSaveImage.size.width > 1023) {
            NSData *imageData=UIImageJPEGRepresentation(tempSaveImage, 0.9);
            tempSaveImage=[UIImage imageWithData:imageData];
        }
         self.block(tempSaveImage);
       
      
    }else{
        
        if (!info)
            return ;
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        
        NSURL *videoUrl;
        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
             videoUrl = (NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
         
          
           
          
            // [weakSelf didSendMessageWithVideoConverPhoto:thumbnailImage videoPath:videoPath];
        } else {
            
        }
        
        
    }
 
    
  
    
  
    
    
}

//保存图片到相册的回调函数
-(void) image: (UIImage *)image didFinishSavingWithError: (NSError *)error
  contextInfo: (void *) contextInfo{
    
    NSString *msg=nil;
    if (error==NULL) {
        msg=@"保存图片成功";
    }else {
        msg=@"保存图片失败";
    }

    DLog(@"msg=%@",msg);
}

#pragma 编辑图片的取消回调函数
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL )isOpen{
   
    if([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"打开相机失败"
                                                       message:@"请打开 设置-隐私-相机 来进行设置"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }else if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"读取相册失败"
                                                       message:@"请打开 设置-隐私-照片 来进行设置"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    return YES;
    
}


@end
