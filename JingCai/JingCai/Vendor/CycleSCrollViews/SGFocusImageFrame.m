

#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import <objc/runtime.h>
#import "UIImageView+WebCache.h"
#import "XHImageViewer.h"
//#import "NSObject+Image.h"
//#import "UIView+RequestSingal.h"

#define ITEM_WIDTH [UIScreen mainScreen].bounds.size.width

@interface SGFocusImageFrame () {
    UIScrollView *_scrollView;
    //    GPSimplePageView *_pageControl;
    UIPageControl *_pageControl;
}

- (void)setupViews;
- (void)switchFocusImageItems;

@end

static NSString *SG_FOCUS_ITEM_ASS_KEY = @"loopScrollview";

static CGFloat SWITCH_FOCUS_PICTURE_INTERVAL = 5.0; //switch interval time

@implementation SGFocusImageFrame
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItems:(SGFocusImageItem *)firstItem, ...
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *imageItems = [NSMutableArray array];
        SGFocusImageItem *eachItem;
        va_list argumentList;
        if (firstItem)
        {
            [imageItems addObject: firstItem];
            va_start(argumentList, firstItem);
            while((eachItem = va_arg(argumentList, SGFocusImageItem *)))
            {
                [imageItems addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _isAutoPlay = YES;
        [self setupViews];
        
        [self setDelegate:delegate];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate imageItems:(NSArray *)items isAuto:(BOOL)isAuto
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSMutableArray *imageItems = [NSMutableArray arrayWithArray:items];
        objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _isAutoPlay = isAuto;
        [self setupViews];
        
        [self setDelegate:delegate];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate imageItems:(NSArray *)items
{
    return [self initWithFrame:frame delegate:delegate imageItems:items isAuto:YES];
}

- (void)dealloc
{
    objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    _scrollView.delegate = nil;
}


#pragma mark - private methods

- (void)setupViews
{
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.scrollsToTop = NO;

    //    _pageControl = [[GPSimplePageView alloc] initWithFrame:CGRectMake(self.bounds.size.width *.5 - size.width *.5, self.bounds.size.height - size.height, size.width, size.height)];
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height- 18, IPHONE_WIDTH, 18)];
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    
    /*
     _scrollView.layer.cornerRadius = 10;
     _scrollView.layer.borderWidth = 1 ;
     _scrollView.layer.borderColor = [[UIColor lightGrayColor ] CGColor];
     */
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];

    //objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addImageViews:imageItems];
}

#pragma mark --- 主要步骤 添加图片 ---

-(void)addImageViews:(NSArray *)aImageItems{
    //移除子视图
    for (UIView *lView in _scrollView.subviews) {
        [lView removeFromSuperview];
    }
    
    float space = 0;
    CGSize size = CGSizeMake(320, 0);
    
    UIImageView *iv = nil;
    
    
    //用啦判断图片是否全部加载成功,如果成功就初始化视图
    for( int  i = 0; i < aImageItems.count; i++)
    {
        iv = [[UIImageView alloc] init];
        iv.frame = CGRectMake(i * _scrollView.frame.size.width+space, space, _scrollView.frame.size.width-space*2, _scrollView.frame.size.height-2*space-size.height);
        //为每张图片添加菊花器
//        [iv showActivityIndicatorView:NO];
        
        SGFocusImageItem *item = [aImageItems objectAtIndex:i];
        
//        __weak typeof(iv) IV = iv;
//        
//        __weak typeof(self) __waekSelf = self;
        
        //图片加载成功时，才初始化界面的各个控件
//        [iv setImageWithURL:[NSURL URLWithString:item.imageURLStr]
//         
//                    success:^(UIImage *image) {
//                        
////                        //对图片进行缩放
////                        UIImage *tempImage = [__waekSelf imageWithImageSimple:image scaledToSize:CGSizeMake(320, 145)];
////                        
////                        IV.image = tempImage;
//                        
////                        [IV finishedActivityIndicatorView];
//
//                    }
//                    failure:^(NSError *error) {
////                        [IV finishedActivityIndicatorView];
//                    }];
        
        [iv sd_setImageWithURL:[NSURL URLWithString:item.imageURLStr] placeholderImage:[UIImage imageNamed:@"loading-04"]];
//        iv.contentMode = UIViewContentModeScaleAspectFill;
   //     iv.contentMode = UIViewContentModeScaleAspectFit;
        
        //加载图片
        
        iv.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];
        
        [_scrollView addSubview:iv];
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * aImageItems.count, _scrollView.frame.size.height);
    if(aImageItems.count == 1)
    {
        _pageControl.numberOfPages = 0;
        _pageControl.hidden = YES;
    }
    else
    {
        _pageControl.numberOfPages = aImageItems.count>1?aImageItems.count -2:aImageItems.count;
        _pageControl.currentPage = 0;
    }
    
    if ([aImageItems count]>1)
    {
        [_scrollView setContentOffset:CGPointMake(ITEM_WIDTH, 0) animated:NO] ;
        if (_isAutoPlay)
        {
            [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
        }
        
    }
}

#pragma mark 改变添加视图内容

-(void)changeImageViewsContent:(NSArray *)aArray
{
    
    //移除子视图
    for (UIView *lView in _scrollView.subviews) {
        [lView removeFromSuperview];
    }
    
    NSMutableArray *imageItems = [NSMutableArray arrayWithArray:aArray];
    objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //请求数据
    [self addImageViews:imageItems];
}

- (void)switchFocusImageItems
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
    [self moveToTargetPosition:targetX];
    
    if ([imageItems count]>1 && _isAutoPlay)
    {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
    }
    
}

#pragma mark ----- 为图片添加手势 --------

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    int page = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
    if (page > -1 && page < imageItems.count) {
        SGFocusImageItem *item = [imageItems objectAtIndex:page];
        if ([self.delegate respondsToSelector:@selector(foucusImageFrame:didSelectItem:)]) {
            [self.delegate foucusImageFrame:self didSelectItem:item];
        }
    }
   // [self showImage:(UIImageView *)gestureRecognizer.view];
}

- (void)moveToTargetPosition:(CGFloat)targetX
{
    BOOL animated = YES;
    //    NSLog(@"moveToTargetPosition : %f" , targetX);
    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:animated];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float targetX = scrollView.contentOffset.x;
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    if ([imageItems count]>=3)
    {
        if (targetX >= ITEM_WIDTH * ([imageItems count] -1)) {
            targetX = ITEM_WIDTH;
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
        else if(targetX <= 0)
        {
            targetX = ITEM_WIDTH *([imageItems count]-2);
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
    }
    int page = (_scrollView.contentOffset.x+ITEM_WIDTH/2.0) / ITEM_WIDTH;
    
    if ([imageItems count] > 1)
    {
        page --;
        if (page >= _pageControl.numberOfPages)
        {
            page = 0;
        }else if(page <0)
        {
            page = (int)_pageControl.numberOfPages -1;
        }

    }
    if (page!= _pageControl.currentPage)
    {
        if(self.delegate)
        {
            if ([self.delegate respondsToSelector:@selector(foucusImageFrame:currentItem:)])
            {
                [self.delegate foucusImageFrame:self currentItem:page];
            }
        }
      
    }
    _pageControl.currentPage = page;
}

//开始拖拽的时候移除（switchFocusImageItems）让图片自动滚动的方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
}

//停止拖拽的时候重新实现（switchFocusImageItems）让图片自动滚动的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
    
    if (!decelerate)
    {
        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
        [self moveToTargetPosition:targetX];
    }
}

- (void)scrollToIndex:(int)aIndex
{
    NSArray *imageItems = objc_getAssociatedObject(self, (__bridge const void *)SG_FOCUS_ITEM_ASS_KEY);
    if ([imageItems count]>1)
    {
        if (aIndex >= ([imageItems count]-2))
        {
            aIndex = (int)[imageItems count]-3;
        }
        [self moveToTargetPosition:ITEM_WIDTH*(aIndex+1)];
    }else
    {
        [self moveToTargetPosition:0];
    }
    [self scrollViewDidScroll:_scrollView];
    
}

-(void)showImage:(UIImageView *)imageView{
 
      XHImageViewer *viewer = [[XHImageViewer alloc]initWithImageViewerWillDismissWithSelectedViewBlock:^(XHImageViewer *imageViewer, UIImageView *selectedView, NSInteger index) {
          ;
      } didDismissWithSelectedViewBlock:^(XHImageViewer *imageViewer, UIImageView *selectedView, NSInteger index) {
          ;
      } didChangeToImageViewBlock:^(XHImageViewer *imageViewer, UIImageView *selectedView, NSInteger index) {
          ;
      }];
    NSMutableArray *array = [NSMutableArray new];
    for(UIView *view in _scrollView.subviews){
        if([view isKindOfClass:[UIImageView class]]){
            [array addObject:view];
        }
    }
    
    [viewer showWithImageViews:array selectedView:imageView];
    
}
@end