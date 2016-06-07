//
//  选择拍照 相册之类的

#import <UIKit/UIKit.h>
typedef void(^chooseActionSheetCallBackBlock)(NSInteger buttonIndex,BOOL isCannel);
typedef void(^dismissBlock)(void);
@interface ChooseActionSheet : UIView



@property (strong,nonatomic) UITableView *tableView;

@property (nonatomic,copy)chooseActionSheetCallBackBlock block;
@property (nonatomic,copy)dismissBlock disBlock;
@property (nonatomic,strong)UIColor *textColor;
@property (nonatomic,strong)NSArray *rowArray;
-(id)initWithNewWindow;
- (void)resignWindow;
@property (nonatomic,strong)NSDictionary *rowColorDict;//NSIndexPath UIColor
-(void)showChooseActionSheetBlock:(chooseActionSheetCallBackBlock )bolck cancelButtonTitle:(NSString *)cancel array:(NSArray *)array;
@end
