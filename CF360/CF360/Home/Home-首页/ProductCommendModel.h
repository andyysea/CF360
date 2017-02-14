//
//  ProductCommendModel.h
//  CF360
//
//  Created by junde on 2017/2/7.
//  Copyright © 2017年 junde. All rights reserved.
//



/**
    产品推荐模型 
    --> 此模型涉及到的有好几种分类,所以转模型的时候要逐一赋值
 */
#import <Foundation/Foundation.h>

@interface ProductCommendModel : NSObject

//信托
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *SALETYPE;
@property (nonatomic, copy) NSString *SELLINGSTATUS;
@property (nonatomic, copy) NSString *SELLINGSTATUS2;//推荐
@property (nonatomic, copy) NSString *level;//有、无
@property (nonatomic, copy) NSString *leftName;
@property (nonatomic, copy) NSString *leftValue;
@property (nonatomic, copy) NSString *middleName;
@property (nonatomic, copy) NSString *middleValue;
@property (nonatomic, copy) NSString *rightName;
@property (nonatomic, copy) NSString *rightValue;
@property (nonatomic, copy) NSString *isShow;//有、无
@property (nonatomic, copy) NSString *percent;//有、无

@property (nonatomic, copy) NSString *pID;//产品id
@property (nonatomic, copy) NSString *CATEGORY;//产品类型

@property (nonatomic, copy) NSString *auditStatus; // 认证状态(是否登陆)


- (NSArray *)productCommendModelArrayWithData:(NSDictionary *)dict;

@end


