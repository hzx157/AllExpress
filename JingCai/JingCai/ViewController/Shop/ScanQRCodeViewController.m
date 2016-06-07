//
//  ScanQRCodeViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ScanQRCodeViewController.h"

#import "WebViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate DeviceMaxWidth/320
@interface ScanQRCodeViewController ()<QRCodeReaderViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
{
    QRCodeReaderView * readview;//二维码扫描对象
    
    BOOL isFirst;//第一次进入该页面
    BOOL isPush;//跳转到下一级页面
}

@property (strong, nonatomic) CIDetector *detector;

@end

@implementation ScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    UIBarButtonItem * rbbItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(alumbBtnEvent)];
    self.navigationItem.rightBarButtonItem = rbbItem;
    
    UIBarButtonItem * lbbItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonEvent)];
    self.navigationItem.leftBarButtonItem = lbbItem;
    
    isFirst = YES;
    isPush = NO;
    
    [self InitScan];
}

#pragma mark - 返回
- (void)backButtonEvent
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark 初始化扫描
- (void)InitScan
{
    if (readview) {
        [readview removeFromSuperview];
        readview = nil;
    }
    
    readview = [[QRCodeReaderView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
    readview.is_AnmotionFinished = YES;
    readview.backgroundColor = [UIColor clearColor];
    readview.delegate = self;
    readview.alpha = 0;
    
    [self.view addSubview:readview];
    
    [UIView animateWithDuration:0.5 animations:^{
        readview.alpha = 1;
    }completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - 相册
- (void)alumbBtnEvent
{
    
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
        
        if (IOS8) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启访问相册权限，现在去开启！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 4;
            [alert show];
        }
        else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        return;
    }
    
    isPush = YES;
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [UIImagePickerController         availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }];
}
#pragma mark--imagePicker delgate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    readview.is_Anmotion = YES;
    
    NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >=1) {
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            //播放扫描二维码的声音
         
            AudioServicesPlaySystemSound(111);
            
            [self accordingQcode:scannedResult];
        }];
        
    }
    else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含一个二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            
            readview.is_Anmotion = NO;
            [readview start];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }];
    
}
+(NSString *)QRStringByimage:(UIImage *)QRimage{
    NSString *qrstring;
    //    readview.is_Anmotion = YES;
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:QRimage.CGImage]];
    if (features.count >=1) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scannedResult = feature.messageString;
        //播放扫描二维码的声音
        
     
        AudioServicesPlaySystemSound(111);
        qrstring=scannedResult;
        //        [self accordingQcode:scannedResult];
    }else{
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含一个二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        //        readview.is_Anmotion = NO;
        //        [readview start];
    }
    return qrstring;
}
#pragma mark -QRCodeReaderViewDelegate
- (void)readerScanResult:(NSString *)result
{
    readview.is_Anmotion = YES;
    [readview stop];
    
  
    AudioServicesPlaySystemSound(111);
    //     [self dismissViewControllerAnimated:YES completion:nil];
    [self accordingQcode:result];
    
    [self performSelector:@selector(reStartScan) withObject:nil afterDelay:1.5];
}

#pragma mark - 扫描结果处理
- (void)accordingQcode:(NSString *)str
{
    
    if([str rangeOfString:@"?code"].location != NSNotFound){
     
        NSArray *code = [str componentsSeparatedByString:@"="];
        
     
            if(self.block)
                self.block([code lastObject]);
            [self backButtonEvent];
            return;
       
//        
//        NSDictionary *dict = [str mj_JSONObject];
//        DLog(@"%@",dict);
//        if(self.block)
//        self.block(dict);
//        [self backButtonEvent];
//        return;
    }
    
    WebViewController *web = [WebViewController new];
    web.urlstr = str;
    [self.navigationController pushViewController:web animated:YES];
    
}

- (void)reStartScan
{
    readview.is_Anmotion = NO;
    
    if (readview.is_AnmotionFinished) {
        [readview loopDrawLine];
    }
    
    [readview start];
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isFirst || isPush) {
        if (readview) {
            [self reStartScan];
        }
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (readview) {
        [readview stop];
        readview.is_Anmotion = YES;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isFirst) {
        isFirst = NO;
    }
    if (isPush) {
        isPush = NO;
    }
}



@end


#define contentTitleColorStr @"666666" //正文颜色较深

@interface QRCodeReaderView ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * session;
    
    NSTimer * countTime;
}
@property (nonatomic, strong) CAShapeLayer *overlay;
@end

@implementation QRCodeReaderView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        [self instanceDevice];
    }
    
    return self;
}

- (void)instanceDevice
{
    //扫描区域
    UIImage *hbImage=[UIImage imageNamed:@"scanscanBg"];
    UIImageView * scanZomeBack=[[UIImageView alloc] init];
    scanZomeBack.backgroundColor = [UIColor clearColor];
    scanZomeBack.layer.borderColor = [UIColor whiteColor].CGColor;
    scanZomeBack.layer.borderWidth = 2.5;
    scanZomeBack.image = hbImage;
    //添加一个背景图片
    CGRect mImagerect = CGRectMake(60*widthRate, (DeviceMaxHeight-200*widthRate)/2, 200*widthRate, 200*widthRate);
    [scanZomeBack setFrame:mImagerect];
    CGRect scanCrop=[self getScanCrop:mImagerect readerViewBounds:self.frame];
    [self addSubview:scanZomeBack];
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    output.rectOfInterest = scanCrop;
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [session addInput:input];
    }
    if (output) {
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=a;
    }
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.layer.bounds;
    [self.layer insertSublayer:layer atIndex:0];
    
    [self setOverlayPickerView:self];
    
    //开始捕获
    [session startRunning];
    
    
}

-(void)loopDrawLine
{
    _is_AnmotionFinished = NO;
    CGRect rect = CGRectMake(60*widthRate, (DeviceMaxHeight-200*widthRate)/2, 200*widthRate, 2);
    if (_readLineView) {
        _readLineView.alpha = 1;
        _readLineView.frame = rect;
    }
    else{
        _readLineView = [[UIImageView alloc] initWithFrame:rect];
        [_readLineView setImage:[UIImage imageNamed:@"scanLine"]];
        [self addSubview:_readLineView];
    }
    
    [UIView animateWithDuration:1.5 animations:^{
        //修改fream的代码写在这里
        _readLineView.frame =CGRectMake(60*widthRate, (DeviceMaxHeight-200*widthRate)/2+200*widthRate-5, 200*widthRate, 2);
    } completion:^(BOOL finished) {
        if (!_is_Anmotion) {
            [self loopDrawLine];
        }
        _is_AnmotionFinished = YES;
    }];
}

- (void)setOverlayPickerView:(QRCodeReaderView *)reader
{
    
    CGFloat wid = 60*widthRate;
    CGFloat heih = (DeviceMaxHeight-200*widthRate)/2;
    
    //最上部view
    CGFloat alpha = 0.6;
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, heih)];
    upView.alpha = alpha;
    upView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
    [reader addSubview:upView];
    
    //用于说明的label
    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(0, 64+(heih-64-50*widthRate)/2, DeviceMaxWidth, 50*widthRate);
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码放入框内，即可自动扫描";
    [upView addSubview:labIntroudction];
    
    //左侧的view
    UIView * cLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, heih, wid, 200*widthRate)];
    cLeftView.alpha = alpha;
    cLeftView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
    [reader addSubview:cLeftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-wid, heih, wid, 200*widthRate)];
    rightView.alpha = alpha;
    rightView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
    [reader addSubview:rightView];
    
    //底部view
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, heih+200*widthRate, DeviceMaxWidth, DeviceMaxHeight - heih-200*widthRate)];
    downView.alpha = alpha;
    downView.backgroundColor = [self colorFromHexRGB:contentTitleColorStr];
    [reader addSubview:downView];
    
    //开关灯button
    UIButton * turnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    turnBtn.backgroundColor = [UIColor clearColor];
    [turnBtn setBackgroundImage:[UIImage imageNamed:@"lightSelect"] forState:UIControlStateNormal];
    [turnBtn setBackgroundImage:[UIImage imageNamed:@"lightNormal"] forState:UIControlStateSelected];
    turnBtn.frame=CGRectMake((DeviceMaxWidth-50*widthRate)/2, (CGRectGetHeight(downView.frame)-50*widthRate)/2, 50*widthRate, 50*widthRate);
    [turnBtn addTarget:self action:@selector(turnBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:turnBtn];
    
}

- (void)turnBtnEvent:(UIButton *)button_
{
    button_.selected = !button_.selected;
    if (button_.selected) {
        [self turnTorchOn:YES];
    }
    else{
        [self turnTorchOn:NO];
    }
    
}

- (void)turnTorchOn:(bool)on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    CGFloat x,y,width,height;
    
    //    width = (CGFloat)(rect.size.height+10)/readerViewBounds.size.height;
    //
    //    height = (CGFloat)(rect.size.width-50)/readerViewBounds.size.width;
    //
    //    x = (1-width)/2;
    //    y = (1-height)/2;
    
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
    
}

- (void)start
{
    [session startRunning];
}

- (void)stop
{
    [session stopRunning];
}

#pragma mark - 扫描结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects && metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        if (_delegate && [_delegate respondsToSelector:@selector(readerScanResult:)]) {
            [_delegate readerScanResult:metadataObject.stringValue];
        }
    }
}

#pragma mark - 颜色
//获取颜色
- (UIColor *)colorFromHexRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}
@end
