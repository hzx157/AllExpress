//
//  EdiorAddressViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "EdiorAddressViewController.h"
#import "CityPickerActionSheet.h"
@interface EdiorAddressViewController ()<UITextFieldDelegate>{

    BOOL isFirst;
    
}
@property (nonatomic,copy)NSArray *titleArray;
@property(nonatomic,strong)AddressModel *addModel;
@property(nonatomic,strong)CityPickerActionSheet *citySheet;
@end

@implementation EdiorAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加收货地址";
    
    if(_model){
     self.title = @"编辑收货地址";
        _addModel = _model;
          self.dataSoureArray = [NSMutableArray arrayWithObjects:[Common getNULLString:self.addModel.contact],[Common getNULLString:self.addModel.phone],[NSString stringWithFormat:@"%@%@%@",self.addModel.province,self.addModel.city,self.addModel.district],[Common getNULLString:self.addModel.detail_address], nil];
    }else{
        self.addModel = [AddressModel new];
          self.dataSoureArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    }
  
    _titleArray = @[@"收货人:",@"联系电话:",@"所在地区:",@"详细地址:"];
    
     [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight = 44.0f;
    
  
}



-(void)rightBtnAction:(id)sender{
    
    [self.view endEditing:YES];
    NSArray *cellArray = [self.tableView visibleCells];
    
    for(UITableViewCell *cell in cellArray){
        for(UIView *view in cell.contentView.subviews){
           
            if([view isKindOfClass:[UITextField class]]){
                UITextField *textField = (UITextField *)view;
                if(textField.text.length <=0){
                    [UIView show_fail_progress:[NSString stringWithFormat:@"%@还没填写",[cell.textLabel.text stringByReplacingOccurrencesOfString:@":" withString:@""]]];
                    return;
                }
                
                switch (textField.tag) {
                    case 100://收货人
                    {
                        self.addModel.contact = textField.text;
                    }
                        break;
                    case 101://phone
                    {
                        self.addModel.phone = textField.text;
                    }
                        break;
                    case 102://dis
                    {
                        
                    }
                        break;
                    case 103://detil
                    {
                        self.addModel.detail_address = textField.text;
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
        }
      
        
    
    }
    [self add];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
     static NSString *hzx_idneti = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hzx_idneti];
    
    
   
    if(!cell){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hzx_idneti];
    }
    
    DLog(@"%@,",cell.contentView.subviews);
    for(UIView *view in cell.contentView.subviews){
     
        if([view isKindOfClass:[UITextField class]]){
          
            if(view.tag != indexPath.row +100)
            [view removeFromSuperview];
        }
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
     UITextField *textField = (UITextField *)[cell.contentView viewWithTag:indexPath.row + 100];
    if(!textField){
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(100.0, 0, IPHONE_WIDTH - 100 , cell.height)];
        textField.delegate = self;
        textField.tag = indexPath.row + 100;
        textField.font = [UIFont systemFontOfSize:16];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.text = self.dataSoureArray[indexPath.row];
        textField.textColor = [UIColor grayColor];
        textField.userInteractionEnabled = YES;
        [cell.contentView addSubview:textField];
    
    }
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    textField.text = self.dataSoureArray[indexPath.row];
    
    textField.left = 100;
     textField.keyboardType = UIKeyboardTypeDefault;
    if(indexPath.row==1){
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }else if (indexPath.row == 3){
      textField.left = 130;
    }
    
    return cell;
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
 
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
 
    isFirst = NO;
    
    [self.dataSoureArray replaceObjectAtIndex:textField.tag - 100 withObject:textField.text];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
 
  
    if(isFirst){
     
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            isFirst = NO;
        });
        
        return NO;
     
    }
    
  
    isFirst = YES;
    
    if(textField.tag == 102){ //所在地区
        
        [self.view endEditing:YES];
        WEAKSELF;
        _citySheet = nil;
        _citySheet = [[CityPickerActionSheet alloc]initWithCity:@"" block:^(CityLocation *locate) {
            weakSelf.addModel.province = locate.state;
            weakSelf.addModel.city = locate.city;
            weakSelf.addModel.district = locate.district;
            textField.text = [NSString stringWithFormat:@"%@%@%@",locate.state,locate.city,locate.district];
            [weakSelf.dataSoureArray replaceObjectAtIndex:textField.tag - 100 withObject:textField.text];
        }];
        return NO;
    }
    return YES;
}

-(void)add{
    
    
    NSDictionary *dict = @{@"province":[Common getNULLString:self.addModel.province],
                           @"city":[Common getNULLString:self.addModel.city],
                           @"district":[Common getNULLString:self.addModel.district],
                           @"detailAddress":[Common getNULLString:self.addModel.detail_address],
                           @"contact":[Common getNULLString:self.addModel.contact],
                           @"phone":[Common getNULLString:self.addModel.phone],
                            @"zipcode":[Common getNULLString:self.addModel.zipcode]
                           };
    
    if(_model){ //更新
        NSMutableDictionary *upadteDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [upadteDict setObject:[Common getNULLString:@(self.model.address_id)] forKey:@"addressId"];
        dict = upadteDict;
    }
    
   
     [[RequestClient sharedClient]user_add_address_dic:dict update:_model progress:^(NSProgress *uploadProgress) {
         ;
     } success:^(NSURLSessionDataTask *task, id responseObject, JCRespone *respone) {
    
         self.block(self.addModel);
         [self.navigationController popViewControllerAnimated:YES];
         
     } failure:^(NSURLSessionDataTask *task, NSError *error, JCRespone *respone) {
         [UIView show_fail_progress:respone.msg];
     }];
    
}


@end
