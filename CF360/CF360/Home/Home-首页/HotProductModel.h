//
//  HotProductModel.h
//  CF360
//
//  Created by junde on 2017/2/7.
//  Copyright © 2017年 junde. All rights reserved.
//


/**
    热销产品模型
 
 ID	String	Y	产品编号（备用）
 NAME	String	Y	产品名称
 SALETYPE	String	Y	销售类型
 SELLINGSTATUS	String	Y	热销
 PHOTOSATTACHMENTS	String	Y	图片地址
 CATEGORY	String	Y	产品类型:信托、资管、ygsm、smgq、1、2、3、4、5、6、7、8
 creditLevel	String	Y	信用等级
 name3	String	Y	认购金额、保险公司
 name3Key	String	Y	认购金额（保险公司）对应的值
 name4	String	Y	产品期限、累计净值、投资期限、保险期间
 name4Key	String	Y	产品期限、累计净值、投资期限、保险期间对应的值
 name5	String	Y	前端返佣、后端返佣、返佣比例
 name5Key	String	Y	前端返佣、后端返佣、返佣比例对应的值
 recruitmentProcess	String	Y	进度条数据
 ISSHOW	String	Y	进度条说明:true/false
 */



#import <Foundation/Foundation.h>

@interface HotProductModel : NSObject

@property (nonatomic, copy) NSString *NAME; // 产品名称
@property (nonatomic, copy) NSString *ID;  // 产品编号
@property (nonatomic, copy) NSString *SALETYPE; // 销售类型(包销/分销)
@property (nonatomic, copy) NSString *SELLINGSTATUS; // 热销
@property (nonatomic, copy) NSString *RECOMMENDSTATUS; //
@property (nonatomic, copy) NSString *PHOTOSATTACHMENTS; // 图片地址
@property (nonatomic, copy) NSString *CATEGORY; // 产品类型
@property (nonatomic, copy) NSString *CREDITLEVEL; // 信用等级
@property (nonatomic, copy) NSString *NAME3; //认购金额,保险公司
@property (nonatomic, copy) NSString *NAME3KEY; // 认购金额(保险公司)对应的值
@property (nonatomic, copy) NSString *NAME4; //产品期限,累计净值,投资期限,保险期间
@property (nonatomic, copy) NSString *NAME4KEY; //产品期限,累计净值,投资期限,保险期间对应的值
@property (nonatomic, copy) NSString *NAME5; // 前端返佣,后端返佣,返佣比例
@property (nonatomic, copy) NSString *NAME5KEY; //前端返佣,后端返佣,返佣比例对应的值
@property (nonatomic, copy) NSString *RECRUITMENTPROCESS;// 进度条数据
@property (nonatomic, copy) NSString *ISSHOW; //进度条说明


@property(nonatomic,copy)NSString *auditStatus; // 认证状态(是否登陆)


@end





