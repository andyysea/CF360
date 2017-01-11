//
//  UIViewController+YHAddition.m
//  Tools
//
//  Created by 杨应海 on 2016/5/1.
//  Copyright © 2016年 YYH. All rights reserved.
//

#import "UIViewController+YHAddition.h"

@implementation UIViewController (YHAddition)

- (void)yh_addChildController:(UIViewController *)childController intoView:(UIView *)view  {
    
    [self addChildViewController:childController];
    
    [view addSubview:childController.view];
    
    [childController didMoveToParentViewController:self];
}


@end
