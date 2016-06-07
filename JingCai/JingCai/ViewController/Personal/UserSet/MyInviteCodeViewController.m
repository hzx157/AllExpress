//
//  MyInviteCodeViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyInviteCodeViewController.h"
#import "UIImage+Capture.h"
#import "ScanQRCodeViewController.h"
@interface MyInviteCodeViewController ()

@end

@implementation MyInviteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"我的邀请码";
    
    
    UIView *bigView = [[UIView alloc]init];
    bigView.backgroundColor = [UIColor whiteColor];
    bigView.layer.cornerRadius = 5.0f;
    bigView.layer.masksToBounds = YES;
    [self.view addSubview:bigView];
    
    [bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.0f);
        make.right.mas_equalTo(-30.f);
        make.top.mas_equalTo(IOS7_TOP_Y + 20.0f);
        make.height.mas_equalTo(self.view.mas_width);
        
    }];
    
    
    
    UILabel *label = [[UILabel alloc]init];
    [bigView addSubview:label];
    label.text = [LoginModel shareLogin].refereeCode;
    label.layer.cornerRadius = 3.0f;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.masksToBounds = YES;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = fontSystemOfSize(17.0);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bigView.mas_centerX);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100.0, 35.0));
    }];
    
    UIImageView *lineView = [[UIImageView alloc]init];
    lineView.backgroundColor = ColorWithRGB(240.0, 241.0, 242.0, 1.0);
    [bigView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.0f);
        make.top.mas_equalTo(label.mas_bottom);
        make.height.mas_equalTo(0.8f);
    }];
 
    //构造二维码
    NSString *code = [NSString stringWithFormat:@"%@?code=%@",apiDownloadUrl,label.text];
    UIImageView *coreImageView = [[UIImageView alloc]initWithImage:[UIImage createRRcode:code]];
    coreImageView.clipsToBounds = YES;
    coreImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bigView addSubview:coreImageView];
    [coreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.right.mas_equalTo(-10.0f);
        make.top.mas_equalTo(lineView.mas_bottom).offset(10.0f);
        make.bottom.mas_equalTo(-10.0f);
    }];
    
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    copyButton.tag = 111;
    [copyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [copyButton setTitle:@"复制" forState:UIControlStateNormal];
    copyButton.titleLabel.font = fontSystemOfSize(15.0f);
    [copyButton setBackgroundColor:[UIColor whiteColor]];
    copyButton.layer.masksToBounds = YES;
    copyButton.layer.cornerRadius = 3.0f;
    [copyButton addTarget:self action:@selector(didButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyButton];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.tag = 222;
    saveButton.titleLabel.font = fontSystemOfSize(15.0f);
    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveButton setTitle:@"保存到相册" forState:UIControlStateNormal];
    [saveButton setBackgroundColor:[UIColor whiteColor]];
    saveButton.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 3.0f;
    [saveButton addTarget:self action:@selector(didButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bigView.mas_left);
        make.height.mas_equalTo(35.0f);
        make.top.mas_equalTo(bigView.mas_bottom).offset(10.0f);
        make.width.mas_equalTo(bigView.mas_width).multipliedBy(0.4);
    }];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bigView.mas_right);
        make.height.mas_equalTo(copyButton.mas_height);
        make.top.mas_equalTo(copyButton.mas_top);
        make.width.mas_equalTo(copyButton.mas_width);
    }];
    
   // copyButton.hidden = saveButton.hidden = YES;
      [self.rightBtnItem setTitle:@"扫一扫"];
 
}
-(void)rightBtnAction:(id)sender{
    
   ScanQRCodeViewController* view  = [ScanQRCodeViewController new];
    view.block = ^(id obj){
        NSLog(@"----%@",obj);
    };
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:view] animated:YES completion:nil];
    
}

-(void)didButton:(UIButton *)button{
    switch (button.tag) {
        case 111: //复制
        {
             [UIView show_success_progress:@"复制成功"];
            [UIPasteboard generalPasteboard].string = [LoginModel shareLogin].refereeCode;;
        }
            break;
        case 222: //保存
        {
            
            NSString *code = [NSString stringWithFormat:@"%@?code=%@",apiDownloadUrl,[LoginModel shareLogin].refereeCode];
            [UIView show_success_progress:@"保存成功"];
            UIImageWriteToSavedPhotosAlbum([UIImage createRRcode:code], nil, nil, nil);
        }
            break;
        default:
            break;
    }

}

@end
