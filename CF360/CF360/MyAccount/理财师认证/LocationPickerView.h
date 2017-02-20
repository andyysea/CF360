//
//  LocationPickerView.h
//  CF360
//
//  Created by junde on 2017/2/20.
//  Copyright © 2017年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 自定义的pickerView, 一般作为文本框的输入工具, 高度为 255
 */
@interface LocationPickerView : UIView

@property (nonatomic, copy) void(^backSelectAddressBlock)(NSString *province, NSString *city);


// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame;

// 取消按钮点击方法
- (void)cancelButtonClick;

@end
