//
//  CFMyAccountButton.m
//  CF360
//
//  Created by junde on 2017/1/12.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "CFMyAccountButton.h"

@implementation CFMyAccountButton


- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat imageX = 0;
    CGFloat imageY = 10;
    CGFloat imageW = 24;
    CGFloat imageH = 24;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat titleX = 32;
    CGFloat titleY = 10;
    CGFloat titleW = 80;
    CGFloat titleH = 24;
    return CGRectMake(titleX, titleY, titleW, titleH);
}


@end
