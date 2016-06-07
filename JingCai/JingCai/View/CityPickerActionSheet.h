//
//  城市选择器
//

#import <UIKit/UIKit.h>

@class CityLocation;


typedef void(^cityPickerActionSheetBlock)(CityLocation *locate);

@interface CityPickerActionSheet : UIView

-(instancetype)initWithCity:(NSString *)city block:(cityPickerActionSheetBlock)block;
@end


@interface CityLocation : NSObject
@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *state; //省
@property (copy, nonatomic) NSString *city;   //城市
@property (copy, nonatomic) NSString *district;  //区
@property (copy, nonatomic) NSString *street;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@end
