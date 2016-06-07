

/*
 @brief: 轮播滚动视图
 */

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

@interface UIView (SGFocusAddImage)

- (void)cycleScrollView:(UIView *)targetView
            imageURLStr:(NSArray *)imageURLStrArr
                imageID:(NSArray *)imageID;

@end
