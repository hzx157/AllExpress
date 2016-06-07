//
//  WriteExpressViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WriteExpressViewController.h"

@interface WriteExpressViewController()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,weak)UIPickerView *pickerView;
@end
@implementation WriteExpressViewController

-(void)viewDidLoad{
 
    [super viewDidLoad];
    self.title = @"填写物流";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
}
-(void)setup{

    NSArray *array = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Express" ofType:@"plist"]];//x
    [self.dataSoureArray addObjectsFromArray:array];
    
    UITextField *textFieldName = [self in_textField:@"  物流公司：" placeholder:@"请选择物流公司" tag:111];
    [textFieldName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(IOS7_TOP_Y + 25.0);
        make.left.mas_equalTo(15.0);
        make.right.mas_equalTo(-15.0);
        make.height.mas_equalTo(44.0);
    }];
    
    UITextField *textFieldNo = [self in_textField:@"  快递单号：" placeholder:@"请填写物流快递单号" tag:222];
    [textFieldNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textFieldName.mas_bottom).offset(10.0);
        make.left.height.right.mas_equalTo(textFieldName);
        
    }];
    
    UIButton *outButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [outButton setBackgroundColor:ColorWithRGB(60.0, 168.0, 250.0, 1.0)];
    outButton.layer.masksToBounds = YES;
    outButton.layer.cornerRadius = 5.0f;
    [outButton setTitle:@"完成" forState:UIControlStateNormal];
    outButton.titleLabel.font = fontSystemOfSize(16.0);
    [outButton addTarget:self action:@selector(actionButton) forControlEvents:UIControlEventTouchUpInside];
    [outButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:outButton];
    
    [outButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textFieldNo.mas_left).offset(10.0);
        make.right.mas_equalTo(textFieldNo.mas_right).offset(-10.0f);
        make.top.mas_equalTo(textFieldNo.mas_bottom).offset(30.0f);
        make.height.mas_equalTo(40.0);
    }];
    
    
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, IPHONE_HEIGHT, IPHONE_WIDTH, 218)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
    
 }
-(void)actionButton{
    [self.view endEditing:YES];
  
      UITextField *textField = [self.view viewWithTag:222];
    if(!self.dataSoureDic){
        [UIView show_fail_progress:@"请选择物流公司"];
        return;
    }else if (textField.text.length<=0){
        [UIView show_fail_progress:@"请填写快递单号"];
        return;
    }
    
    NSString *string = [NSString stringWithFormat:@"%@-%@-%@",self.dataSoureDic[@"name"],self.dataSoureDic[@"code"],textField.text];
    
    [UIView show_loading_progress:@"请求中.."];
    [[RequestClient sharedClient]order_tuiExpress_tuiExpress:string bookingId:[NSString stringWithFormat:@"%ld",self.model.bookingId] progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject, JCRespone * _Nonnull respone) {
        [UIView show_success_progress:respone.msg];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self leftBtnAction:nil];
        });
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, JCRespone * _Nonnull respone) {
        [UIView show_fail_progress:respone.msg];
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.pickerView.top != IPHONE_HEIGHT)
        [UIView animateWithDuration:0.25 animations:^{
            self.pickerView.top = IPHONE_HEIGHT;
        } completion:^(BOOL finished) {
            ;
        }];
}
-(UITextField *)in_textField:(NSString *)name placeholder:(NSString *)placeholder tag:(NSInteger)tag{

    UITextField *textField = [[UITextField alloc]init];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.delegate = self;
    textField.tag = tag;
    textField.font = fontSystemOfSize(16.0);
    textField.placeholder = placeholder;
    textField.leftViewMode = UITextFieldViewModeAlways;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90.0, 44.0)];
    label.text = name;
    label.font = textField.font;
    textField.leftView = label;
    [self.view addSubview:textField];
    
    return textField;

}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
 
    if(textField.tag == 111){
        [UIView animateWithDuration:0.25 animations:^{
            self.pickerView.bottom = IPHONE_HEIGHT;
        } completion:^(BOOL finished) {
            ;
        }];
        
        return NO;
     }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  
    [textField resignFirstResponder];
    return YES;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataSoureArray.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *dict = self.dataSoureArray[row];
    return dict[@"name"];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
      NSDictionary *dict = self.dataSoureArray[row];
    UITextField *textField = [self.view viewWithTag:111];
    textField.text = dict[@"name"];
    self.dataSoureDic = dict;
    
}
@end
