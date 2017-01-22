//
//  Utils.m
//  CF360
//
//  Created by kingstartimes on 15/10/14.
//  Copyright (c) 2015年 junde. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (BOOL) validatePassword : (NSString *) str{
    if (!str) {
        return NO;
    }
    
    NSString *patternStr = [NSString stringWithFormat:@"^[0-9A-Za-z_]{6,16}$"];
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:patternStr
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    
    
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
    
}

+ (BOOL) validateUserPhone : (NSString *) str
{
    if (!str) {
        return NO;
    }
    
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|2|3|5|6|7|8|9])\\d{8}$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0)
    {
        DDLog(@"%@ isNumbericString: YES", str);
        return YES;
    }
    
    DDLog(@"%@ isNumbericString: NO", str);
    return NO;
}

+ (BOOL) validateEmail:(NSString *)str
{
    if (!str) {
        return NO;
    }
    NSString *patternEmail = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    NSRegularExpression *regexEmail = [NSRegularExpression regularExpressionWithPattern:patternEmail options:0 error:nil];
    NSTextCheckingResult *isMatchEmail = [regexEmail firstMatchInString:str
                                                                options:0
                                                                  range:NSMakeRange(0, str.length)];
    if(isMatchEmail > 0)
    {
        DDLog(@"%@ isMatchEmail: YES", str);
        return YES;
    }
    
    DDLog(@"%@ isMatchEmail: NO", str);
    return NO;
}

/**
 *校验钱的金额是否合法
 *@param	str	金额
 *@return		金额是否合法
 */
+ (BOOL) validateRMB:(NSString *)str
{
    if (!str) {
        return NO;
    }
    
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^(([0-9]|([1-9][0-9]{0,9}))((.[0-9]{1,2})?))$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0)
    {
        DDLog(@"%@ isNumbericString: YES", str);
        return YES;
    }
    
    DDLog(@"%@ isNumbericString: NO", str);
    return NO;
}

/**
 *校验身份证证号是否合法
 *@param	str	身份证号
 *@return		身份证号是否合法
 */
+ (BOOL) validateIDCard:(NSString *)value{
//    if (!str) {
//        return NO;
//    }
//    
//    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
//                                              initWithPattern:@"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$"
//                                              options:NSRegularExpressionCaseInsensitive
//                                              error:nil];
//    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
//                                                                  options:NSMatchingReportProgress
//                                                                    range:NSMakeRange(0, str.length)];
//    if(numberofMatch > 0)
//    {
//        NSLog(@"%@ isNumbericString: YES", str);
//        return YES;
//    }
//    
//    NSLog(@"%@ isNumbericString: NO", str);
//    return NO;
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

//百度唯一标识
+ (BOOL)storeBaiDuChannelIdCode:(NSString *)recommendCode
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:recommendCode forKey:@"baiduChannelId"];
    [userDefaults synchronize];
    return YES;
}
+ (NSString *)getBaiDuChannelId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"baiduChannelId"]) {
        return [userDefaults objectForKey:@"baiduChannelId"];
    }else {
        return nil;
    }
}
//deviceToken
+ (BOOL)storeDeviceToken:(NSData *)deviceToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:deviceToken forKey:@"deviceToken"];
    [userDefaults synchronize];
    return YES;
}
+ (NSData *)getDeviceToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"deviceToken"]) {
        return [userDefaults objectForKey:@"deviceToken"];
    }else {
        return nil;
    }
}
//推送开关唯一标识
+ (BOOL)storeTuiSong:(NSString*)isOpen
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:isOpen forKey:@"isOpen"];
    [userDefaults synchronize];
    return YES;
}
+ (NSString*)getTuiSong
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"isOpen"]) {
        return [userDefaults objectForKey:@"isOpen"];
    }else {
        return nil;
    }
}

@end
