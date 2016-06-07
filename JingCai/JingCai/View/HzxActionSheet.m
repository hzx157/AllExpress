

#import "HzxActionSheet.h"

@implementation HzxActionSheet
@synthesize mainWindow = _mainWindow;
@synthesize myWindow = _myWindow;
@synthesize myTitle = _myTitle;
@synthesize backView = _backView;
@synthesize myView = _myView;
@synthesize delegate = _delegate;

-(id)init{
    
    self = [super init];
    
    if (self)
    {
        _myWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _myWindow.windowLevel = UIWindowLevelStatusBar;
        _myWindow.userInteractionEnabled = YES;
        _myWindow.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.5f];
    }
    return self;
}

-(void)showHzxActionsheetWithView:(UIView *)view{
    
    _backView = [[UIView alloc] init];
    if (IOS6&&([view isKindOfClass:[UIDatePicker class]]|[view isKindOfClass:[UIPickerView class]])) {
        _backView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0f];
    }else{
        _backView.backgroundColor = [UIColor whiteColor];
    }
    
    CGRect f;
    f.size.width = IPHONE_WIDTH;
    f.size.height =view.frame.size.height+60;
    f.origin.x = 0;
    f.origin.y = IPHONE_HEIGHT-f.size.height;
    _backView.frame = f;
    
    f = view.bounds;
    f.origin.y = 40;
    f.origin.x = (IPHONE_WIDTH - f.size.width)*0.5;
    view.frame = f;
    _myView = view;
    
    [_backView addSubview:view];
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(IPHONE_WIDTH-80, 0, 80, 40);
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.titleLabel.font=fontSystemOfSize(16);
        [button setTitleColor:COLOR_black_1f1f1f forState:UIControlStateNormal];
        
        if (IOS6&&([view isKindOfClass:[UIDatePicker class]]|[view isKindOfClass:[UIPickerView class]])) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(callBack) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:button];
    }
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 80, 40);
        [button setTitle:@"取消" forState:UIControlStateNormal];
        button.titleLabel.font=fontSystemOfSize(16);
        [button setTitleColor:COLOR_black_1f1f1f forState:UIControlStateNormal];
        
        if (IOS6&&([view isKindOfClass:[UIDatePicker class]]|[view isKindOfClass:[UIPickerView class]]))
        {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(dismissHzxActionSheet) forControlEvents:UIControlEventTouchUpInside];
        
        [_backView addSubview:button];
        
    }
    
    [_myWindow addSubview:_backView];
    
    CGPoint center = _backView.center;
    center.y += _backView.frame.size.height;
    _backView.center = center;
    [_myWindow makeKeyAndVisible];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGPoint center = _backView.center;
        center.y -= _backView.frame.size.height;
        _backView.center = center;
    } completion:^(BOOL finished) {
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT-_backView.frame.size.height)];
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissHzxActionSheet)];
        [tapView addGestureRecognizer:tap];
        [_myWindow addSubview:tapView];
    
    }];
}
-(void)dismissHzxActionSheet{
    if ([_delegate respondsToSelector:@selector(willDismissHzxActionSheet:)]) {
        [_delegate willDismissHzxActionSheet:self];
    }
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _myWindow.alpha = 0;
        CGPoint center = _backView.center;
        center.y += _backView.frame.size.height;
        _backView.center = center;
    } completion:^(BOOL finished) {
        _myWindow.hidden = YES;
        [_mainWindow makeKeyAndVisible];
        if ([_delegate respondsToSelector:@selector(didDismissHzxActionSheet:)]) {
            [_delegate didDismissHzxActionSheet:self];
        }    }];
}
-(void)callBack{
    if ([_delegate respondsToSelector:@selector(commitAction:withMyView:)]) {
        [_delegate commitAction:self withMyView:_myView];
    }
    [self dismissHzxActionSheet];
}

@end
