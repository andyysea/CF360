//
//  NSDate+YHString.m
//  Tools
//
//  Created by 杨应海 on 2015/9/21.
//  Copyright © 2015年 YYH. All rights reserved.
//

#import "NSDate+YHString.h"

@implementation NSDate (YHString)

/**
 获取给定日期对应的 年-月-日加 周几
 
 @return 2015-09-21 周三
 */
- (NSString *)yh_YMDWString {
    if (!self) {
        return @"";
    }
    NSDateFormatter *fm = [NSDateFormatter new];
    [fm setDateFormat:@"yyyy-MM-dd EE"];
    return [fm stringFromDate:self];
}

/**
 获取对应日期的 年-月-日
 
 @return 2015-09-21
 */
- (NSString *)yh_YMDString {
    if (!self) {
        return @"";
    }
    NSDateFormatter *fm = [NSDateFormatter new];
    [fm setDateFormat:@"yyyy-MM-dd"];
    return [fm stringFromDate:self];
}

/**
 获取对应日期的 月-日 周几
 
 @return 09-21 周三
 */
- (NSString *)yh_MDAndWeekString {
    if (!self) {
        return @"";
    }
    NSDateFormatter *fm = [NSDateFormatter new];
    [fm setDateFormat:@"MM-dd EE"];
    return [fm stringFromDate:self];
}

/**
 获取对应日期的 月-日
 
 @return 09-21
 */
- (NSString *)yh_MDString {
    if (!self) {
        return @"";
    }
    NSDateFormatter *fm = [NSDateFormatter new];
    [fm setDateFormat:@"MM-dd"];
    return [fm stringFromDate:self];
}


/**
 获取对应日期的 时-分
 
 @return 13:50
 */
- (NSString *)yh_HMString {
    if (!self) {
        return @"";
    }
    NSDateFormatter *fm = [NSDateFormatter new];
    [fm setDateFormat:@"HH:mm"];
    return [fm stringFromDate:self];
}



/**
 获取给定日期对应的 年
 
 @return 2015
 */
- (NSString *)yh_YearString {
    if (!self) {
        return @"";
    }
    NSDateFormatter *fm = [NSDateFormatter new];
    [fm setDateFormat:@"yyyy"];
    return [fm stringFromDate:self];
}

/**
 获取给定日期对应的 月
 
 @return 09
 */
- (NSString *)yh_MonthString {
    if (!self) {
        return @"";
    }
    NSDateFormatter *fm = [NSDateFormatter new];
    [fm setDateFormat:@"MM"];
    return [fm stringFromDate:self];
}


/**
 获取给定日期对应的 天
 
 @return 21
 */
- (NSString *)yh_DayString {
    if (!self) {
        return @"";
    }
    NSDateFormatter *fm = [NSDateFormatter new];
    [fm setDateFormat:@"dd"];
    return [fm stringFromDate:self];
}


/**
 获取给定日期对应的 周几
 
 @return 周三
 */
- (NSString *)yh_WeekString {
    if (!self) {
        return @"";
    }
    NSDateFormatter *fm = [NSDateFormatter new];
    [fm setDateFormat:@"EE"];
    return [fm stringFromDate:self];
}


@end
