//
//  NSDate+YHString.h
//  Tools
//
//  Created by 杨应海 on 2015/9/21.
//  Copyright © 2015年 YYH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YHString)

/**
 获取给定日期对应的 年-月-日加 周几
 
 @return 2015-09-21 周三
 */
- (NSString *)yh_YMDWString;


/**
 获取对应日期的 年-月-日
 
 @return 2015-09-21
 */
- (NSString *)yh_YMDString;


/**
 获取对应日期的 月-日 周几
 
 @return 09-21 周三
 */
- (NSString *)yh_MDAndWeekString;


/**
 获取对应日期的 月-日
 
 @return 09-21
 */
- (NSString *)yh_MDString;


/**
 获取对应日期的 时-分
 
 @return 13:50
 */
- (NSString *)yh_HMString;



/**
 获取给定日期对应的 年
 
 @return 2015
 */
- (NSString *)yh_YearString;


/**
 获取给定日期对应的 月
 
 @return 09
 */
- (NSString *)yh_MonthString;


/**
 获取给定日期对应的 天
 
 @return 21
 */
- (NSString *)yh_DayString;


/**
 获取给定日期对应的 周几
 
 @return 周三
 */
- (NSString *)yh_WeekString;


@end
