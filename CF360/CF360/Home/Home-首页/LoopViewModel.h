//
//  LoopViewModel.h
//  CF360
//
//  Created by junde on 2017/1/16.
//  Copyright © 2017年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoopViewModel : NSObject

/**
 url 不是真正的 url
 */
@property (nonatomic, copy) NSString *url;

/**
 真正的URLString
 */
@property (nonatomic, copy) NSString *picture;

/**
 描述内容,但是是关键字 'description', 注意转换 
 */
@property (nonatomic, copy) NSString *descrip;


/**
 字典转模型方法
 */
+ (instancetype)loopViewModelWithDict:(NSDictionary *)dict;

@end
