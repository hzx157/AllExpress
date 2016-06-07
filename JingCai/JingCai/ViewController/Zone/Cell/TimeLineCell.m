//
//  TimeLineCell.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TimeLineCell.h"
#import "UIImage+Resize.h"
#import "UIImage+Orientation.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "NSDate+TimeAgo.h"
@interface TimeLineCell()
@property (nonatomic,weak)UIButton *avtorButton;
@property (nonatomic,weak)UILabel *nameLabel;
@property (nonatomic,weak)UILabel *messageLabel;
@property (nonatomic,weak)UIButton *playButton;
@property (nonatomic,weak)UILabel *timeLabel;
@end
@implementation TimeLineCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

 
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
    
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
        
    }
    return self;
    
}
-(void)setup{
 
    UIButton *avtorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    avtorButton.layer.masksToBounds = YES;
    avtorButton.layer.cornerRadius = 40.0/2;
    [self.contentView addSubview:avtorButton];
    _avtorButton = avtorButton;
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.font = fontSystemOfSize(15.0f);
    nameLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *messageLabel = [UILabel new];
    messageLabel.font = fontSystemOfSize(16.0f);
    messageLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:messageLabel];
    self.messageLabel = messageLabel;
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    playButton.contentMode = UIViewContentModeScaleAspectFit;
    [playButton setImage:imageNamed(@"Mark_Play") forState:UIControlStateNormal];
    playButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:playButton];
    _playButton = playButton;
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.font = fontSystemOfSize(13.0f);
    timeLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    [_avtorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.top.mas_equalTo(9.0f);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(avtorButton.mas_right).offset(8.0f);
        make.top.mas_equalTo(avtorButton.mas_top);
        make.right.mas_equalTo(0.0);
        make.height.mas_equalTo(HeightScaleSize(20.0));
    }];
    
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.top.mas_equalTo(nameLabel.mas_bottom);
        make.right.mas_equalTo(-10.0);
        make.height.mas_equalTo(HeightScaleSize(30.0));
    }];
    
    [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.top.mas_equalTo(messageLabel.mas_bottom).offset(5.0f);
        make.size.mas_equalTo(CGSizeMake(WidthScaleSize(260.0), WidthScaleSize(260.0)));
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.height.mas_equalTo(HeightScaleSize(30.0f));
        make.width.mas_equalTo(100.0);
        make.bottom.mas_equalTo(0.0);
    }];
    
    
}
+(CGFloat)getHeight{
    return HeightScaleSize(60.0f) +  WidthScaleSize(260.0) + 50.0f;
}
-(void)buttonAction:(UIButton *)button{
    
    
    self.playBlock(button,_model);
}
-(void)setModel:(id)model{
 
    _model = model;
    [_avtorButton sd_setImageWithURL:urlNamed(@"") forState:UIControlStateNormal placeholderImage:defaultLogo];
    _nameLabel.text = @"晶彩邱老师";
    _timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:[model[@"time"] longLongValue]/1000 ]jcTimeAgoSimple];
    _messageLabel.text = model[@"detail"];
    NSString *url = model[@"video"];
  
    
//    if([[SDImageCache sharedImageCache]imageFromDiskCacheForKey:url]){
//        [self.playButton sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal placeholderImage:[[SDImageCache sharedImageCache]imageFromDiskCacheForKey:url]];
//        return;
//    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
//        MPMoviePlayerController *iosMPMovie = [[MPMoviePlayerController alloc]initWithContentURL:urlNamed(url)]; iosMPMovie.shouldAutoplay = NO;
//        [iosMPMovie requestThumbnailImagesAtTimes:@[@(1)] timeOption:MPMovieTimeOptionNearestKeyFrame];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThumbnailImageRequestFinishNotification:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:iosMPMovie];
        
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:urlNamed(url) options:nil];
        AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        
        NSError *error = NULL;
        CMTime time = CMTimeMake(0.0, 1.0);
        CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
        // DLog(@"error==%@, Refimage==%@", error, error.localizedDescription);
        
        UIImage *FrameImage= [[UIImage alloc] initWithCGImage:refImg scale:1.0 orientation:UIImageOrientationUp];
      //  FrameImage = [UIImage image:FrameImage rotation:UIImageOrientationUp];
     //   FrameImage= [FrameImage resizedImage:CGSizeMake(systemOfSize(200), systemOfSize(200)) interpolationQuality:kCGInterpolationDefault];
      //  [[SDImageCache sharedImageCache]storeImage:FrameImage forKey:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.playButton sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal placeholderImage:FrameImage];
        });
        
    });
    


}
-(void)handleThumbnailImageRequestFinishNotification:(NSNotification *)notification{
    NSDictionary *userinfo = [notification userInfo];
    NSError* value = [userinfo objectForKey:MPMoviePlayerThumbnailErrorKey];
    if (value != nil)
    {
        NSLog(@"Error creating video thumbnail image. Details: %@", [value debugDescription]);
    }
    else
    {
        UIImage *FrameImage = [userinfo valueForKey:MPMoviePlayerThumbnailImageKey];
        [[SDImageCache sharedImageCache]storeImage:FrameImage forKey:@""];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.playButton sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal placeholderImage:FrameImage];
        });
    }
}
-(void)layoutSubviews{
 
    [super layoutSubviews];
}
@end
