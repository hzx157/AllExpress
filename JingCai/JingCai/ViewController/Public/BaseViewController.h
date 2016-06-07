
/*
 * brief: 父类控制器
 */

#import <UIKit/UIKit.h>

extern NSInteger const kPageSize;

@interface BaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)UIBarButtonItem *rightBtnItem;
@property (nonatomic,strong)UIImageView *barTabImageView;   //底部的标签栏
@property (nonatomic,assign)UITableViewStyle tableViewStyle; //选择tableViewStyle 和下面对应
@property (nonatomic,strong)UITableView *tableView; //常用tableView

@property (nonatomic,strong)NSMutableArray *dataSoureArray;
@property (nonatomic,strong)NSDictionary *dataSoureDic;

@property (nonatomic,assign)BOOL isHiddenTabBar;

@property (nonatomic,assign)NSInteger pageNo;


- (void)hiddenTabBar;                       //隐藏标签栏

- (void)showTabBar;                         //显示标签栏

- (void)leftBtnAction:(UIButton *)sender;   //导航栏左侧按钮方法

- (void)rightBtnAction:(id )sender;  //导航栏右侧按钮方法

- (void)hideShadow;

-(void)iNeedALine;

#pragma mark 基本设置
- (void)baseSettting;

-(void)requestFail;

@end
