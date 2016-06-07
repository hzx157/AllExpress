//
//  UISwitch+Hzx.m
//  Gone
//
//  Created by xiaowuxiaowu on 15/9/8.
//  Copyright (c) 2015年 xiaowuxiaowu. All rights reserved.
//

#import "UISwitch+Hzx.h"
static NSString *UISwitchKey = @"UISwitchKey";

@implementation UISwitch (Hzx)

- (void)setIndexPath:(NSIndexPath *)indexPath {
    [self willChangeValueForKey:@"callbackBlock"];
    objc_setAssociatedObject(self, &UISwitchKey, indexPath, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"callbackBlock"];
    
}

- (NSIndexPath *)indexPath {
    
    return objc_getAssociatedObject(self, &UISwitchKey);
}
@end
