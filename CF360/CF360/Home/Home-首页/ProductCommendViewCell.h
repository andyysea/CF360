//
//  ProductCommendViewCell.h
//  CF360
//
//  Created by junde on 2017/2/7.
//  Copyright © 2017年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductCommendModel;


@interface ProductCommendViewCell : UITableViewCell


/** 模型属性 */
@property (nonatomic, strong) ProductCommendModel *model;


@end
