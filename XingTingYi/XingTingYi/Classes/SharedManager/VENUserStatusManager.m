//
//  VENUserStatusManager.m
//
//  Created by YVEN.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENUserStatusManager.h"

static VENUserStatusManager *instance;
static dispatch_once_t onceToken;
@implementation VENUserStatusManager

+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        instance = [[VENUserStatusManager alloc] init];
    });
    return instance;
}

- (BOOL)isLogin {
    return [VENEmptyClass isEmptyString:[[NSUserDefaults standardUserDefaults] objectForKey:@"LOGIN"]] ? NO : YES;
}

@end
