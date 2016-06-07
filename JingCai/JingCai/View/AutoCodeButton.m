

#import "AutoCodeButton.h"
//#import "Single.h"

@implementation AutoCodeButton

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setButton];
        
        [self setTitle:@"获取验证码" forState:0];
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    
    return self;
}

- (void)setButton{
    [self addTarget:self action:@selector(handle:) forControlEvents:UIControlEventTouchUpInside];
    count = 60;
}

#pragma mark --- 按钮点击方法 ---

- (void)handle:(UIButton *)sender{

    if([self.textField.text isEqualToString:@""] || !self.textField)
    {
        [UIView show_fail_progress:@"请输入手机号码"];
        
        return;
    }

    if(tempTimer){
        [tempTimer invalidate];
        tempTimer = nil;
    }
    [self requestTime];
    sender.userInteractionEnabled = NO;
    
   [[RequestClient sharedClient]login_sendCode_loginName:_textField.text progress:^(NSProgress *uploadProgress) {
       ;
   }   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
     //  _code = [respone.data objectForKey:@"code"];
   } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
       [UIView  show_fail_progress:respone.msg];
  }];
    
}

#pragma makr --- 开启多线程 ---

- (void)requestTime
{
    //开一个多线程，让定时器每隔一段时间，就请求一次数据
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self
                                                                     selector:@selector(threadMethod)
                                                                       object:nil];
    
    [queue addOperation:op];
    
}

#pragma mark --- 多线程方法 ---

- (void)threadMethod
{
    @autoreleasepool
    {
        tempTimer = [NSTimer scheduledTimerWithTimeInterval:1.00f
                                                     target:self
                                                   selector:@selector(requestInformationCount:)
                                                   userInfo:nil
                                                    repeats:YES];
    }
    
    [[NSRunLoop currentRunLoop] run];
}

#pragma makr --- 定时器方法 ---

- (void)requestInformationCount:(NSTimer *)timer
{
    //回到主线程实现方法
    [self performSelectorOnMainThread:@selector(handleMainThread:) withObject:timer waitUntilDone:YES];
}

#pragma makr --- 回到主线程实现方法 ----

- (void)handleMainThread:(NSTimer *)sender
{
    
    if(count > 0)
    {
        [self setTitle:[NSString stringWithFormat:@"重发:%d",count] forState:0];
    }
    
    if(count == 0)
    {
        [tempTimer invalidate];
        
        tempTimer = nil;
        
        [self setTitle:@"获取验证码" forState:0];
        
        self.userInteractionEnabled = YES;
        
        count = 60;
    }
    
    count--;

}

@end
