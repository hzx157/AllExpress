//
//  NickNameViewController.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NickNameViewController.h"

@interface NickNameViewController ()<UITextFieldDelegate>
@property (nonatomic,copy)NSString *nickName;
@property (nonatomic,weak)UITextField *textFiled;
@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"修改昵称";
    self.tableViewStyle = UITableViewStyleGrouped;
    [self.tableView reloadData];
    self.nickName = [LoginModel shareLogin].nickName;
    [self.rightBtnItem setTitle:@"确定"];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_textFiled becomeFirstResponder];
 
}
-(void)rightBtnAction:(id)sender{
 
    if(self.nickName.length <=0){
    
        return;
    }else if(self.nickName.length >=10){
        [UIView show_fail_progress:@"昵称不能超过10个字符"];
        return;
    }
    [self getData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
     static NSString *indetiferi = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetiferi];
    UITextField *textFiled = [cell.contentView viewWithTag:9909];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indetiferi];
        if(!textFiled){
            textFiled = [[UITextField alloc]initWithFrame:CGRectMake(3.0, 0, IPHONE_WIDTH - 6, cell.height)];
            textFiled.placeholder = @"请输入昵称";
            textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
            textFiled.delegate = self;
            textFiled.text = self.nickName;
            textFiled.tag = 9909;
            [cell.contentView addSubview:textFiled];
            [textFiled addTarget:self action:@selector(textFieldChane:) forControlEvents:UIControlEventEditingChanged];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    _textFiled = textFiled;
    
    
    return cell;
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldChane:(UITextField *)textField{
    self.nickName = textField.text;
}
-(void)getData{

 
    [[RequestClient sharedClient]user_update_nickName:self.nickName progress:^(NSProgress *uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask *task, id responseObject, JCRespone *respone) {
        
        [self.navigationController popViewControllerAnimated:YES];
        self.block(self.nickName);
        [LoginModel shareLogin].nickName = self.nickName;
         [[LoginModel shareLogin]save];
        [[Common shareAppDelegate]login];
    } failure:^(NSURLSessionDataTask *task, NSError *error, JCRespone *respone) {
        [UIView show_fail_progress:respone.msg];
    }];
    
}

@end
