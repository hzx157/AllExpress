//
//  ScanQRCodeViewController.h
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface ScanQRCodeViewController : BaseViewController
@property (nonatomic,copy)void (^block)(id string);
+(NSString *)QRStringByimage:(UIImage *)QRimage;
@end




@protocol QRCodeReaderViewDelegate <NSObject>
- (void)readerScanResult:(NSString *)result;
@end

@interface QRCodeReaderView : UIView

@property (nonatomic, weak) id<QRCodeReaderViewDelegate> delegate;
@property (nonatomic,copy)UIImageView * readLineView;
@property (nonatomic,assign)BOOL is_Anmotion;
@property (nonatomic,assign)BOOL is_AnmotionFinished;

//开启关闭扫描
- (void)start;
- (void)stop;

- (void)loopDrawLine;//初始化扫描线

@end