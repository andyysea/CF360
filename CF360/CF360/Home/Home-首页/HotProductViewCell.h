//
//  HotProductViewCell.h
//  CF360
//
//  Created by junde on 2017/2/7.
//  Copyright © 2017年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HotProductModel;

@interface HotProductViewCell : UITableViewCell

/** 点击预约按钮回调方法 */
@property (nonatomic, copy) void(^clickBookButtonCallBack)(HotProductViewCell *cell);

/** 模型属性 */
@property (nonatomic, strong) HotProductModel *model;


@end
