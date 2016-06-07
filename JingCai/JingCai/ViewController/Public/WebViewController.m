//
//  WebViewController.m
//  Gone
//
//  Created by Happy on 15/9/16.
//  Copyright (c) 2015年 xiaowuxiaowu. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController()<UIWebViewDelegate>

@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation WebViewController

- (void)leftBtnAction:(UIButton *)sender
{
    [super leftBtnAction:sender];
    
    web.delegate =nil;

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [_progressProxy reset];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar addSubview:_progressView];
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    

    [_progressView removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.rightBtn.userInteractionEnabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DLog(@"url = %@",self.urlstr);
      if (self.urlstr) {
          NSArray *httpArray = [self.urlstr componentsSeparatedByString:@"http://"];
        if (httpArray.count>2) {
            return;
        }
//        NSString * urlHead = @"http://";
//        self.urlstr = [urlHead stringByAppendingString:self.urlstr];
    }
  
    web = [[UIWebView alloc] initWithFrame:CGRectMake(ZERO, IOS7_TOP_Y, IPHONE_WIDTH, IPHONE_HEIGHT - 64)];
    web.scalesPageToFit = YES;
    web.delegate = self;
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlstr]]];
    [self.view addSubview:web];
    _progressProxy = [[NJKWebViewProgress alloc] init];
    web.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}



-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
 
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
   // self.title = [web stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
