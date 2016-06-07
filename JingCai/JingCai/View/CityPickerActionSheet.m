//
//  CityPickerActionSheet.m
//  Gone
//
//  Created by xiaowuxiaowu on 15/7/2.
//  Copyright (c) 2015年 xiaowuxiaowu. All rights reserved.
//

#import "CityPickerActionSheet.h"
#import "HzxActionSheet.h"

@interface CityPickerActionSheet()<actionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)NSArray *plistArray;
@property(nonatomic,copy)NSMutableArray *state;
@property(nonatomic,copy)NSMutableArray *city;
@property (strong, nonatomic) CityLocation *locate;

@property (nonatomic,strong)HzxActionSheet *actionSheet;
@property (nonatomic,copy)cityPickerActionSheetBlock block;
@end

@implementation CityPickerActionSheet

-(instancetype)initWithCity:(NSString *)city block:(cityPickerActionSheetBlock)block{
    if(self = [super init]){
    
        self.block = block;
        self.plistArray=[self getPlistArrayByplistName:@"p_city_area"];
        _city =[NSMutableArray arrayWithArray: [[_plistArray objectAtIndex:0] objectForKey:@"cities"]];
        self.locate = [[CityLocation alloc]init];
        self.locate.state = [[_plistArray objectAtIndex:0] objectForKey:@"state"];
        self.locate.city = [[_city objectAtIndex:0] objectForKey:@"city"];
        
        _state = [NSMutableArray arrayWithArray:[[_city objectAtIndex:0] objectForKey:@"areas"]];
        if (_state.count > 0) {
            self.locate.district = [_state objectAtIndex:0];
        } else{
            self.locate.district = @"";
        }
        
        
        [self setUpPickView];
    }
    return self;
}
-(void)setUpPickView{
    
    UIPickerView *pickView=[[UIPickerView alloc] init];
    pickView.backgroundColor=[UIColor clearColor];
    _pickerView=pickView;
    pickView.delegate=self;
    pickView.dataSource=self;
    pickView.frame=CGRectMake(0, 0, IPHONE_WIDTH, 180);
    
    _actionSheet = nil;
    _actionSheet = [[HzxActionSheet alloc] init];
    _actionSheet.delegate = self;
    [_actionSheet showHzxActionsheetWithView:pickView];
}

-(NSArray *)getPlistArrayByplistName:(NSString *)plistName{
    
    NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray * array=[[NSArray alloc] initWithContentsOfFile:path];

    return array;
}



#pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
   
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [_plistArray count];
            break;
        case 1:
            return [_city count];
            break;
        case 2:
          
                return [_state count];
         
        default:
            return 0;
            break;
       }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  
        switch (component) {
            case 0:
                return [[_plistArray objectAtIndex:row] objectForKey:@"state"];
                break;
            case 1:
                return [[_city objectAtIndex:row] objectForKey:@"city"];
                break;
            case 2:
                if ([_state count] > 0) {
                    return [_state objectAtIndex:row];
                    break;
                }
            default:
                return  @"";
                break;
       
        }
            return  @"";
                
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
 
        switch (component) {
            case 0:
                _city = [[_plistArray objectAtIndex:row] objectForKey:@"cities"];
                [self.pickerView selectRow:0 inComponent:1 animated:YES];
                [self.pickerView reloadComponent:1];
                
                _state = [[_city objectAtIndex:0] objectForKey:@"areas"];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                [self.pickerView reloadComponent:2];
                
                self.locate.state = [[_plistArray objectAtIndex:row] objectForKey:@"state"];
                self.locate.city = [[_city objectAtIndex:0] objectForKey:@"city"];
                if ([_state count] > 0) {
                    self.locate.district = [_state objectAtIndex:0];
                } else{
                    self.locate.district = @"";
                }
                break;
            case 1:
                _state = [[_city objectAtIndex:row] objectForKey:@"areas"];
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                [self.pickerView reloadComponent:2];
                
                self.locate.city = [[_city objectAtIndex:row] objectForKey:@"city"];
                if ([_state count] > 0) {
                    self.locate.district = [_state objectAtIndex:0];
                } else{
                    self.locate.district = @"";
                }
                break;
            case 2:
                if ([_state count] > 0) {
                    self.locate.district = [_state objectAtIndex:row];
                } else{
                    self.locate.district = @"";
                }
                break;
            default:
                break;
        }
   
    
}
#pragma mark myactionsheet delegate  //获取时间

-(void)commitAction:(HzxActionSheet *)sheet withMyView:(UIView *)myView{
    
    self.block(self.locate);
}

@end


@implementation CityLocation
@synthesize country = _country;
@synthesize state = _state;
@synthesize city = _city;
@synthesize district = _district;
@synthesize street = _street;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@end
