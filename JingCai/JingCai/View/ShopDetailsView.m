

//商品详情视图

#import "ShopDetailsView.h"
#import "JCShare.h"
#import "ApiServer.h"
@interface ShopDetailsView(){
    
}

@property (nonatomic, strong) UILabel *shopTitle; //商品标题
@property (nonatomic, strong) UIButton *shareBtn; //分享按钮
@property (nonatomic, strong) UILabel *shopLeftMonney; //商品价格符号
@property (nonatomic, strong) UILabel *shopMoney; //商品价格
@property (nonatomic, strong) UILabel *shopSales; //商品销量
@property (nonatomic, strong) UILabel *shopStore; //商品库存

@end

@implementation ShopDetailsView

//商品标题
- (UILabel *)shopTitle{
    if(!_shopTitle){
        _shopTitle = [[UILabel alloc] init];
        _shopTitle.font = [UIFont systemFontOfSize:15];
        [self addSubview:_shopTitle];
    }
    return _shopTitle;
}

//商品分享按钮
- (UIButton *)shareBtn{
    if(!_shareBtn){
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setTitleColor:[UIColor blackColor] forState:0];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [_shareBtn setImage:imageNamed(@"share-1") forState:0];
        [self addSubview:_shareBtn];
    }
    return _shareBtn;
}

//商品价格符号
- (UILabel *)shopLeftMonney{
    if(!_shopLeftMonney){
        _shopLeftMonney = [[UILabel alloc] init];
        _shopLeftMonney.textColor = [UIColor redColor];
        _shopLeftMonney.font = [UIFont systemFontOfSize:12];
        [self addSubview:_shopLeftMonney];
    }
    return _shopLeftMonney;
}

//商品价格
- (UILabel *)shopMoney{
    if(!_shopMoney){
        _shopMoney = [[UILabel alloc] init];
        _shopMoney.textColor = [UIColor redColor];
        [self addSubview:_shopMoney];
    }
    return _shopMoney;
}

//商品销量
- (UILabel *)shopSales{
    if(!_shopSales){
        _shopSales = [[UILabel alloc] init];
        _shopSales.font = [UIFont systemFontOfSize:13];
        [self addSubview:_shopSales];
    }
    return _shopSales;
}

//商品库存
- (UILabel *)shopStore{
    if(!_shopStore){
        _shopStore = [[UILabel alloc] init];
        _shopStore.font = [UIFont systemFontOfSize:13];
        [self addSubview:_shopStore];
    }
    return _shopStore;
}

- (id)init{
    if(self = [super init]){
        
    }
    return self;
}

- (void)layoutSubviews{
    self.shopTitle.frame = CGRectMake(10, 10, IPHONE_WIDTH - 60, 20);
    self.shareBtn.frame = CGRectMake(self.shopTitle.right + 10, 10, 20, 25);
    self.shopLeftMonney.frame = CGRectMake(self.shopTitle.left, self.shopTitle.bottom + 35, 12, 12);
    self.shopMoney.frame = CGRectMake(self.shopLeftMonney.right, self.shopTitle.bottom + 30, (IPHONE_WIDTH - 30)/3, 20);
    self.shopSales.frame = CGRectMake(self.shopMoney.right, self.shopTitle.bottom + 30, (IPHONE_WIDTH - 30)/3, 20);
    self.shopStore.frame = CGRectMake(self.shopSales.right, self.shopTitle.bottom + 30, (IPHONE_WIDTH - 30)/3, 20);
}

-(void)setDetailModel:(ShopDetailModel *)detailModel{
    _detailModel = detailModel;
    self.shopTitle.text = detailModel.productName;
    self.shopLeftMonney.text = @"￥";
    self.shopMoney.text = [NSString stringWithFormat:@"%ld",(long)detailModel.basePrice];
    self.shopSales.text = [NSString stringWithFormat:@"销量:%ld件",detailModel.saleNum>0 ? detailModel.saleNum : 0];
    self.shopStore.text = [NSString stringWithFormat:@"库存:%@件",[detailModel.allnum integerValue]>0 ? detailModel.allnum : @"0"];
}



- (void)share:(UIButton *)sender{
    //邀请好友
    [JCShare showTitle:self.detailModel.productName desc:@"来自晶彩形象" image:self.detailModel.mainImage link:[NSString stringWithFormat:@"%@product/detail.htm?productId=%ld&hideDownload=0",apiUrl,(long)_detailModel.productId] Success:^(OSMessage *message) {
        ;
    } Fail:^(OSMessage *message, NSError *error) {
        ;
    }];
}

@end
