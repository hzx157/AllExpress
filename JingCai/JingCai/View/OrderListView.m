

#import "OrderListView.h"

@interface OrderBtn : UIButton

@end

@interface OrderListView(){
    
}

@end

@implementation OrderListView

- (id)init{
    if(self = [super init]){
        
    }
    return self;
}

- (void)setup{
    NSArray *arr = @[@"one",@"two",@"three",@"four",@"five"];
    for(int i = 0; i < 5; i++){
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        orderBtn.frame = CGRectMake(ZERO + i * (IPHONE_WIDTH/5), ZERO, IPHONE_WIDTH/5, IPHONE_WIDTH/5);
        orderBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        orderBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        orderBtn.layer.borderWidth = 0.4;
        [orderBtn addTarget:self action:@selector(order:) forControlEvents:UIControlEventTouchUpInside];
        orderBtn.tag = i;
        [orderBtn setImage:imageNamed(arr[i]) forState:0];
        [orderBtn setTitle:arr[i] forState:0];
        orderBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:orderBtn];
    }
}

- (void)layoutSubviews{
    [self setup];
}

- (void)order:(UIButton *)sender{
    self.block(sender.tag);
}

@end


@implementation OrderBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(ZERO, ZERO, IPHONE_WIDTH/5, IPHONE_WIDTH/5 - 20);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(10, IPHONE_WIDTH/5 - 20, IPHONE_WIDTH/5, 15);
}

@end