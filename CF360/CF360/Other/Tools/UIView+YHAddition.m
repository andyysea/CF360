//
//  UIView+YHAddition.m
//  Tools
//
//  Created by 杨应海 on 2015/10/31.
//  Copyright © 2015年 YYH. All rights reserved.
//

#import "UIView+YHAddition.h"

@implementation UIView (YHAddition)

- (UIImage *)yh_snapshotImage {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}


@end
