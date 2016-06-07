//
//  拍照 ，系统相册！！直接初始化调用就ok


typedef void(^ChoosePhotoAlbumBlock)(UIImage *image);
typedef void(^ChooseVideoAlbumBlock)(UIImage *image,NSString *path);
typedef void(^ChoosePhotoAlbumWithJKimageBlock)(NSMutableArray *array);

#import <Foundation/Foundation.h>

@interface ChoosePhotoAlbum : NSObject

@property (nonatomic,copy)ChoosePhotoAlbumBlock block;
@property (nonatomic,copy)ChoosePhotoAlbumWithJKimageBlock jkBlock;  //多选择的时候
@property (nonatomic,copy)ChooseVideoAlbumBlock videoBlock;//视频
@property (nonatomic,assign)NSInteger maximumNumberOfSelection;//多选时的最大总数  
@property (nonatomic,weak)UIViewController *ViewController;   //来自哪个
@property (nonatomic,assign)BOOL isEditedImage;  //是否要剪切图片 默认是NO

+(ChoosePhotoAlbum *)shareSinge;

//从相册选择 系统选择
-(void)localPhoto:(ChoosePhotoAlbumBlock )block;

//拍照
-(void)takePhoto:(ChoosePhotoAlbumBlock )block;

//视频
-(void)takeVideo:(ChooseVideoAlbumBlock )block;

@end
