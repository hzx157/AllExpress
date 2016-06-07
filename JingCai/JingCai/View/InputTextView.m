

#import "InputTextView.h"

@implementation InputTextView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        //背景图片
        
        self.imgBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        self.imgBg.backgroundColor = [UIColor whiteColor];
        self.imgBg.layer.cornerRadius = 7;
        self.imgBg.backgroundColor = [UIColor whiteColor];
        self.imgBg.frame = CGRectMake(ZERO, ZERO, frame.size.width, frame.size.height);
        [self addSubview:self.imgBg];
        
        
        self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        self.icon.frame = CGRectMake(ZERO, ZERO, 16,16);
        self.icon.centerY = self.centerY;
        self.icon.hidden = YES;
        [self addSubview:self.icon];
        
        self.leftName = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.right, ZERO, 14*5, frame.size.height)];
        self.leftName.font = [UIFont systemFontOfSize:15];
        self.leftName.textColor = [UIColor blackColor];
        self.leftName.alpha = 0.6;
        [self addSubview:self.leftName];
        
        self.rightName = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 215, ZERO, 200, frame.size.height)];
        self.rightName.font = [UIFont systemFontOfSize:14];
        self.rightName.textAlignment = NSTextAlignmentRight;
        self.rightName.textColor = [UIColor blackColor];
        self.rightName.alpha = 0.5;
        [self addSubview:self.rightName];
        
        self.myTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.leftName.right + 10, ZERO, frame.size.width - self.leftName.width - 20 - 16 + 2, frame.size.height)];
        self.myTextField.font = [UIFont systemFontOfSize:15];
        self.myTextField.alpha = 0.6;
        self.myTextField.textColor = [UIColor blackColor];
        self.myTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:self.myTextField];
        
   
        
    }
    
    return self;
}


#pragma mark --- 设置坐标 ---

- (void)setViewFrame
{
    self.rightName.frame =CGRectMake(self.frame.size.width - 215, ZERO, 200, self.frame.size.height);
    self.imgBg.frame = CGRectMake(ZERO, ZERO, self.frame.size.width, self.frame.size.height);
    self.leftName.frame = CGRectMake(16, ZERO, self.leftName.text.length * 15, self.height);
    self.leftName.alpha = 1.0;
    self.myTextField.alpha = 1.0;
    self.myTextField.frame = CGRectMake(self.leftName.right + 20, ZERO, self.frame.size.width - self.leftName.width - 20 - 16, self.frame.size.height);
}

@end
