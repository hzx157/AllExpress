//
//  WebViewController.h
//  Gone
//
//  Created by Happy on 15/9/16.
//  Copyright (c) 2015年 xiaowuxiaowu. All rights reserved.
//


#import "BaseViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
@interface WebViewController : BaseViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>

{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    UIWebView *web;
}

@property (nonatomic, copy) NSString *urlstr;

@end
