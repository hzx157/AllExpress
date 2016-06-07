//
//  选择拍照 相册之类的

#define CELLHIEGHT 55.0f
#import "UITableView+iOS7Style.h"
#import "UITableViewCell+NIB.h"
#import "ChooseActionSheet.h"
@interface ChooseActionSheet()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UIWindow *myWindow;
@property (strong,nonatomic) UIWindow *m_Window;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (strong,nonatomic) UIView *tapView;

@end


@implementation ChooseActionSheet
@synthesize tableView = _tableView;

-(id)init{

    return [self initWithNewWindow];
}

-(id)initWithNewWindow{
    self = [super init];
    if (self) {
        
       
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
    
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.bottom, self.width, 0.0f) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = COLOR_tableView_separator;
        _tableView.scrollEnabled = NO;
        [_tableView setEdgeInsetsZero];
        [self addSubview:_tableView];
        
        [[UIApplication sharedApplication].delegate.window addSubview:self];

    }
    return self;
}
-(void)dealloc
{
    NSLog(@"释放chooseActionSheet");


}

- (void)resignWindow
{
    
   // _m_Window.hidden=YES;
    
}

-(void)setTextColor:(UIColor *)textColor{

 
    if(_textColor != textColor){
        _textColor = textColor;
    }
    [_tableView reloadData];
}

-(void)showChooseActionSheetBlock:(chooseActionSheetCallBackBlock )bolck cancelButtonTitle:(NSString *)cancel array:(NSArray *)array{
    self.block = bolck;
  
     // [_m_Window makeKeyAndVisible];
    self.dataArray = [NSMutableArray arrayWithObjects:array,@[cancel], nil];
    NSArray *array1= [self.dataArray firstObject];
    
    
    [_tableView reloadData];
    [_tableView setHeight:(CELLHIEGHT *(array1.count + 1)+5)];
    
    
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT-_tableView.height)];
    tapView.backgroundColor=[UIColor clearColor];
    tapView.userInteractionEnabled = YES;
    self.tapView=tapView;
    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissHzxActionSheet)];
    [tapView addGestureRecognizer:tap];
    [self addSubview:tapView];
   
    
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
        [_tableView setTop:(IPHONE_HEIGHT-_tableView.height)];
    } completion:^(BOOL finished) {
        
        
    }];
    
}
-(void)dismissHzxActionSheet{
 

    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundColor=[UIColor clearColor];
        [_tableView setTop:IPHONE_HEIGHT];
    } completion:^(BOOL finished) {
      
        [self removeFromSuperview];
        [self resignWindow];
 
       
    }];
    
    if (self.disBlock) {
        self.disBlock();
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    NSArray *array = self.dataArray[section];
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

   
     static NSString *kCellintifer = @"kCellintifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellintifer];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellintifer];
        [cell setEdgeInsetsZero];
    }
    for(UIView *v in cell.contentView.subviews){
        [v removeFromSuperview];
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = fontSystemOfSize(16);
    
    for (NSString *row in self.rowArray) {
        if (indexPath.row  == [row intValue]) {
            cell.textLabel.textColor=RGB(255, 116, 134);
        }else {
            cell.textLabel.textColor=[UIColor colorWithHexString:@"#1f1f1f"];
        }
    }
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    if(indexPath.section == 1){
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#8c8c8c"];
        cell.textLabel.font = fontSystemOfSize(18);
    }else if ([cell.textLabel.text isEqual:@"删除"]){
       cell.textLabel.textColor = COLOR_reg_FF0055;
    }
    //更改某个NSIndexPath的颜色
    if(self.rowColorDict){
        NSIndexPath *indexPat = self.rowColorDict[@"NSIndexPath"];
        UIColor *color = self.rowColorDict[@"UIColor"];
        if(indexPat == indexPath){
            cell.textLabel.textColor = color;
        }
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return CELLHIEGHT;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 0.0;
        
    return 5.0;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 7.f)];
    view.backgroundColor=RGB(214, 215, 216);
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissHzxActionSheet];
    if (indexPath.section != (self.dataArray.count - 1)) {
        self.block(indexPath.row,indexPath.section == 1);
    }
}
@end
