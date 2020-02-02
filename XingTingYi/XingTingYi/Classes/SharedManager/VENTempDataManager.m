//
//  VENTempDataManager.m
//  XingTingYi
//
//  Created by YVEN on 2020/2/3.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENTempDataManager.h"

@interface VENTempDataManager ()
@property (nonatomic, strong) NSMutableArray *dataMuArr;

@end

@implementation VENTempDataManager
+ (instancetype)shareManager {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([VENEmptyClass isEmptyString:key]) {
        return;
    }
    
    if (!value) {
        return;
    }
    
    [self.dataMuArr addObject:@{key : value}];
}

- (id)objectForKey:(NSString *)key {
    if ([VENEmptyClass isEmptyString:key]) {
        return nil;
    }
    
    for (NSDictionary *dict in self.dataMuArr) {
        if ([dict objectForKey:key]) {
            return [dict objectForKey:key];
        }
    }
    return nil;
}

- (NSMutableArray *)dataMuArr {
    if (!_dataMuArr) {
        _dataMuArr = [NSMutableArray array];
    }
    return _dataMuArr;
}

@end
