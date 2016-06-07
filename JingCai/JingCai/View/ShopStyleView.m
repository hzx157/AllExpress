

#import "ShopStyleView.h"


@interface ShopStyleView (){
    
}

@property (nonatomic, strong) UIImageView *shopImg;//商品图片
@property (nonatomic, strong) UILabel *shopLeftMoney; //商品价格符号
@property (nonatomic, strong) UILabel *shopMoney; //商品价格
@property (nonatomic, strong) UILabel *shopStore; //商品库存量
@property (nonatomic, strong) UILabel *shopDes;
@property (nonatomic, strong) UILabel *shopSize; //商品尺码
@property (nonatomic, strong) UILabel *shopClass; //商品分类
@property (nonatomic, strong) UILabel *shopCount; //购买数量
@property (nonatomic, strong) UIButton *bottomBtn; //底部按钮
@property (nonatomic, strong) UIButton *deleteBtn; //返回按钮
@property (nonatomic, strong) UIView *line; //线
@property (nonatomic, strong) UIButton *minusBtn;
@property (nonatomic, strong) UILabel *countLabel; //商品数量
@property (nonatomic, strong) UIButton *maxBtn;
@property (nonatomic, strong) UIButton *addShopCartBtn; //加入购物车按钮
@property (nonatomic, strong) UIButton *buyBtn; //立即购买按钮
@property (nonatomic ,strong) UIButton *tempSizeBtn; //临时尺码按钮
@property (nonatomic, strong) UIButton *tempColorBtn; //临时颜色按钮

@property(nonatomic,weak)SkulistModel *skuModel; //选中颜色尺寸等

@end

@implementation ShopStyleView

//商品图片
- (UIImageView *)shopImg{
    if(!_shopImg){
        _shopImg = [[UIImageView alloc] init];
        _shopImg.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_shopImg];
    }
    return _shopImg;
}

//商品价格符号
- (UILabel *)shopLeftMoney{
    if(!_shopLeftMoney){
        _shopLeftMoney = [[UILabel alloc] init];
        _shopLeftMoney.textColor = [UIColor redColor];
        _shopLeftMoney.font = [UIFont systemFontOfSize:13];
        [self addSubview:_shopLeftMoney];
    }
    return _shopLeftMoney;
}

//商品价格
- (UILabel *)shopMoney{
    if(!_shopMoney){
        _shopMoney = [[UILabel alloc] init];
        _shopMoney.textColor = [UIColor redColor];
        _shopMoney.font = [UIFont systemFontOfSize:18];
        [self addSubview:_shopMoney];
    }
    return _shopMoney;
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

- (UILabel *)shopDes{
    if(!_shopDes){
        _shopDes = [[UILabel alloc] init];
        _shopDes.font = [UIFont systemFontOfSize:13];
        _shopDes.text = @"请选择 尺码 颜色分类";
        [self addSubview:_shopDes];
    }
    return _shopDes;
}

//删除按钮
- (UIButton *)deleteBtn{
    if(!_deleteBtn){
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:imageNamed(@"delete_clear") forState:0];
        [_deleteBtn addTarget:self action:@selector(handleDelete:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
    }
    return _deleteBtn;
}

//线
- (UIView *)line{
    _line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor darkGrayColor];
    _line.alpha = 0.5;
    [self addSubview:_line];
    return _line;
}

//尺码
- (UILabel *)shopSize{
    if(!_shopSize){
        _shopSize = [[UILabel alloc] init];
        _shopSize.font = [UIFont systemFontOfSize:15];
        _shopSize.text = @"尺码";
        _shopSize.textColor = [UIColor darkGrayColor];
        _shopSize.font = [UIFont systemFontOfSize:15];
        [self addSubview:_shopSize];
    }
    return _shopSize;
}


//商品颜色
- (UILabel *)shopClass{
    if(!_shopClass){
        _shopClass = [[UILabel alloc] init];
        _shopClass.text = @"颜色分类";
        _shopClass.textColor = [UIColor darkGrayColor];
        _shopClass.font = [UIFont systemFontOfSize:15];
        [self addSubview:_shopClass];
    }
    return _shopClass;
}

//设置颜色
- (void)setShopColor:(id)object{
    for(int i = 0; i < 6; i++){
        UIButton *colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        colorBtn.frame = CGRectMake(ZERO, ZERO, 50, 40);
        [self addSubview:colorBtn];
    }
}

//购买数量
- (UILabel *)shopCount{
    if(!_shopCount){
        _shopCount = [[UILabel alloc] init];
        _shopCount.text = @"购买数量";
        _shopCount.textColor = [UIColor darkGrayColor];
        _shopCount.font = [UIFont systemFontOfSize:15];
        [self addSubview:_shopCount];
    }
    return _shopCount;
}

//减商品按钮
- (UIButton *)minusBtn{
    if(!_minusBtn){
        _minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusBtn setImage:imageNamed(@"minmux") forState:0];
        [_minusBtn addTarget:self action:@selector(minus:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_minusBtn];
    }
    return _minusBtn;
}

//商品数量
- (UILabel *)countLabel{
    if(!_countLabel){
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor darkGrayColor];
        _countLabel.font = [UIFont systemFontOfSize:15];
        _countLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:_countLabel];
    }
    return _countLabel;
}

//增加商品按钮
- (UIButton *)maxBtn{
    if(!_maxBtn){
        _maxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_maxBtn setImage:imageNamed(@"max") forState:0];
        [_maxBtn addTarget:self action:@selector(max:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_maxBtn];
    }
    return _maxBtn;
}

//加入购物车按钮

- (UIButton *)addShopCartBtn{
    if(!_addShopCartBtn){
        _addShopCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addShopCartBtn.backgroundColor = [UIColor redColor];
        [_addShopCartBtn setTitle:@"确认加入购物车" forState:0];
        _addShopCartBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_addShopCartBtn addTarget:self action:@selector(addShopCart:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addShopCartBtn];
    }
    return _addShopCartBtn;
}

//立即购买按钮
- (UIButton *)buyBtn{
    if(!_buyBtn){
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.backgroundColor = [UIColor redColor];
        [_buyBtn setTitle:@"立即预订" forState:0];
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_buyBtn addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_buyBtn];
    }
    return _buyBtn;
}

- (id)init{
    if(self = [super init]){
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
 
    if(self = [super initWithFrame:frame]){
     self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    
    self.shopImg.frame = CGRectMake(10, 10, 90, 90);
    self.shopLeftMoney.frame = CGRectMake(self.shopImg.right + 10, 15, 13, 13);
    self.shopMoney.frame = CGRectMake(self.shopLeftMoney.right, 10, 200, 20);
    self.shopStore.frame = CGRectMake(self.shopImg.right + 10, self.shopMoney.bottom + 10, 200, 20);
    self.shopDes.frame = CGRectMake(self.shopImg.right + 10, self.shopStore.bottom  +10, 200, 20);
    self.deleteBtn.frame = CGRectMake(self.width - 40, 10, 28, 28);
    self.line.frame = CGRectMake(ZERO, self.shopImg.bottom + 10, IPHONE_WIDTH, 0.5);
    self.shopSize.frame = CGRectMake(10, self.shopImg.bottom + 20, 100, 20);
    for(int i = 0 ; i <  [self.detailModel.sizeList count]; i++){
        UIButton *sizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sizeBtn.frame = CGRectMake(20 + i * ((IPHONE_WIDTH - 80)/5 + 10 ), self.shopSize.bottom + 10, (IPHONE_WIDTH - 80)/5, 30);
        sizeBtn.layer.cornerRadius = 7;
        sizeBtn.backgroundColor = ColorWithRGB(236, 237, 239, 1.0);
        [sizeBtn setTitleColor:[UIColor blackColor] forState:0];
        sizeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [sizeBtn setTitle:[self.detailModel.sizeList objectAtIndex:i] forState:0];
        [self addSubview:sizeBtn];
        [sizeBtn addTarget:self action:@selector(handleSize:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i == 0){
            self.tempSizeBtn = sizeBtn;
            self.tempSizeBtn.backgroundColor = [UIColor redColor];
        }
    }
    if([self.detailModel.colorList count] == 0){
        self.tempSizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.tempSizeBtn.frame = CGRectMake(20, self.shopSize.bottom + 10, (IPHONE_WIDTH - 80)/5, 30);
    }
    self.line.frame = CGRectMake(ZERO, self.tempSizeBtn.bottom + 10, IPHONE_WIDTH, 0.5);
    self.shopClass.frame = CGRectMake(10, self.tempSizeBtn.bottom + 20, 200, 20);
    for(int i = 0 ; i < [self.detailModel.colorList count]; i++){
        UIButton *colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        colorBtn.frame = CGRectMake(20 + i * ((IPHONE_WIDTH - 80)/5 + 10 ), self.shopClass.bottom + 10, (IPHONE_WIDTH - 80)/5, 30);
        colorBtn.backgroundColor = ColorWithRGB(236, 237, 239, 1.0);
        colorBtn.layer.cornerRadius = 7;
        [colorBtn setTitleColor:[UIColor blackColor] forState:0];
        colorBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:colorBtn];
        [colorBtn setTitle:[self.detailModel.colorList objectAtIndex:i] forState:0];
        [colorBtn addTarget:self action:@selector(handleColor:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i == 0){
            self.tempColorBtn = colorBtn;
            self.tempColorBtn.backgroundColor = [UIColor redColor];
        }
    }
    if([self.detailModel.sizeList count] == 0){
        self.tempColorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.tempColorBtn.frame = CGRectMake(20, self.shopClass.bottom + 10, (IPHONE_WIDTH - 80)/5, 30);
    }
    self.line.frame = CGRectMake(ZERO, self.tempColorBtn.bottom + 10, IPHONE_WIDTH, 0.5);
    self.shopCount.frame = CGRectMake(10, self.tempColorBtn.bottom + 20, 200, 20);
    self.minusBtn.frame = CGRectMake(IPHONE_WIDTH - 40 * 3 - 20, self.shopCount.bottom + 10, 40, 40);
    self.countLabel.frame = CGRectMake(self.minusBtn.right, self.minusBtn.top, 40, 40);
    self.maxBtn.frame = CGRectMake(self.countLabel.right, self.minusBtn.top, 40, 40);
    if(self.shopStyle == ShopStyle_addShopCart){
        //加入购物车
        self.addShopCartBtn.frame = CGRectMake(ZERO, self.height - 40, IPHONE_WIDTH, 40);
    }else{
        //立即购买
        self.buyBtn.frame = CGRectMake(ZERO, self.height - 40, IPHONE_WIDTH, 40);
    }
    
    [self.shopImg sd_setImageWithURL:urlNamed(self.detailModel.mainImage) placeholderImage:defaultLogo];
    self.shopLeftMoney.text = @"￥";
    self.shopMoney.text = [NSString stringWithFormat:@"%ld",(long)self.detailModel.basePrice];
    self.shopStore.text =  [NSString stringWithFormat:@"库存:%@件",[Common getNULLString:self.detailModel.allnum]];
    self.countLabel.text = @"1";
    [self updateData];
}



#pragma mark --- 选择尺码 ---

- (void)handleSize:(UIButton *)sender{
    if(sender == self.tempSizeBtn){
    }else{
        sender.backgroundColor = [UIColor redColor];
        self.tempSizeBtn.backgroundColor = ColorWithRGB(236, 237, 239, 1.0);
        self.tempSizeBtn = sender;
    }
    [self updateData];
}

#pragma mark --- 选择颜色 ---

- (void)handleColor:(UIButton *)sender{
    if(sender == self.tempColorBtn){
    }else{
        sender.backgroundColor = [UIColor redColor];
        self.tempColorBtn.backgroundColor = ColorWithRGB(236, 237, 239, 1.0);
        self.tempColorBtn = sender;
    }
    [self updateData];
}

#pragma mark -- 减少产品数量 ---

- (void)minus:(UIButton *)sender{
    if([self.countLabel.text intValue] != 1){
        int count = [self.countLabel.text intValue];
        self.countLabel.text = [NSString stringWithFormat:@"%d",--count];
    }
}

#pragma mark -- 增加产品 ---
- (void)max:(UIButton *)sender{
    
    int count = [self.countLabel.text intValue];
    self.countLabel.text = [NSString stringWithFormat:@"%d",++count];
     // [self maxButtonEnabled:self.skuModel.skuNum >= count]; //不能在加了
}
-(void)maxButtonEnabled:(BOOL)enabled{
    self.maxBtn.enabled = enabled;
}

#pragma mark --- 加入购物车按钮 ---

- (void)addShopCart:(UIButton *)sender{
    /*
    if(self.skuModel.skuNum < [self.countLabel.text integerValue]){
      
        [UIView show_fail_progress:@"暂时没有那么多库存的啦"];
        return;
    }
    */
    if(self.skuModel.skuTitle.length <=0 && self.skuModel.sizeValue.length<=0){
        [UIView show_fail_progress:@"该商品没有库存"];
        return;
    }
   ShopCarModel *model = [ShopCarModel initWithDict:self.dic price:[NSString stringWithFormat:@"%ld",self.skuModel.skuPrice] image:self.skuModel.imageUrl.length>0 ? self.skuModel.imageUrl : self.detailModel.mainImage color:self.tempColorBtn.titleLabel.text size:self.tempSizeBtn.titleLabel.text num:[self.countLabel.text integerValue] skuID:self.skuModel.skuId];
    [UIView show_success_progress:@"加入购物车成功"];
    
    ShopCarModel *sqlModel = [ShopCarModel searchSingleWithWhere:[NSString stringWithFormat:@"skuId = '%ld'",(long)model.skuId] orderBy:nil];
    model.snum += sqlModel.snum ;
    [ShopCarModel saveToDB:model where:nil];
    self.add(nil);
}

#pragma mark --- 立即购买按钮 ---

- (void)buy:(UIButton *)sender{
    
    
//    if(self.skuModel.skuNum < [self.countLabel.text integerValue]){
//        
//        [UIView show_fail_progress:@"暂时没有那么多库存的啦"];
//        return;
//    }
    if(self.skuModel.skuTitle.length <=0 && self.skuModel.sizeValue.length<=0){
        [UIView show_fail_progress:@"该商品没有库存"];
        return;
    }
    ShopCarModel *model = [ShopCarModel initWithDict:self.dic price:[NSString stringWithFormat:@"%ld",self.skuModel.skuPrice] image:self.skuModel.imageUrl.length>0 ? self.skuModel.imageUrl : self.detailModel.mainImage color:self.tempColorBtn.titleLabel.text size:self.tempSizeBtn.titleLabel.text num:[self.countLabel.text integerValue] skuID:self.skuModel.skuId];
    self.buy(model);
}

- (SkulistModel *)getSkuId
{
    NSArray *skulist = self.detailModel.skulist;
    for (SkulistModel *sku in skulist) {
        if ([sku.colorValue isEqualToString:self.tempColorBtn.titleLabel.text] && [sku.sizeValue isEqualToString:self.tempSizeBtn.titleLabel.text]) {
            return sku;
        }
    }
    return nil;
}

#pragma mark --- 移除 ---

- (void)handleDelete:(UIButton *)sender{
    self.delet(nil);
}

#pragma mark-----更新选都更新数据
//更新选择数据
-(void)updateData{
    
   self.shopDes.text = [NSString stringWithFormat:@"已选:\"%@\" \"%@\" ",self.tempColorBtn.titleLabel.text,self.tempSizeBtn.titleLabel.text];
    self.skuModel = [self getSkuId];
    [self.shopImg sd_setImageWithURL:urlNamed(self.skuModel.imageUrl.length>0 ? self.skuModel.imageUrl : self.detailModel.mainImage) placeholderImage:defaultLogo];
    self.shopLeftMoney.text = @"￥";
    self.shopMoney.text = [NSString stringWithFormat:@"%ld",(long)self.skuModel.skuPrice];
    self.shopStore.text =  [NSString stringWithFormat:@"库存:%ld件",(long)self.skuModel.skuNum];
   // [self maxButtonEnabled:self.skuModel.skuNum > [self.countLabel.text integerValue]]; //不能在加了
}


@end