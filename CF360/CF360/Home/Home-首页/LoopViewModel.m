//
//  LoopViewModel.m
//  CF360
//
//  Created by junde on 2017/1/16.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "LoopViewModel.h"

@implementation LoopViewModel

+ (instancetype)loopViewModelWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initLoopViewModelWithDict:dict];
}

- (instancetype)initLoopViewModelWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}



- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"description"]) {
        [super setValue:value forKey:@"descrip"];
        return;
    }
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}




@end
