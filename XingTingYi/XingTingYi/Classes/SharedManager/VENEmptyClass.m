//
//  VENEmptyClass.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/7.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENEmptyClass.h"

@implementation VENEmptyClass

+ (BOOL)isEmptyString:(NSString *)string {
    if (!string) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!string.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [string stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isEmptyArray:(NSArray *)array {
    if (!array) {
        return YES;
    }
    if ([array isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!array.count) {
        return YES;
    }
    return NO;
}

+ (BOOL)isEmptyDictionary:(NSDictionary *)dict {
    if (!dict) {
        return YES;
    }
    if ([dict isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!dict.count) {
        return YES;
    }
    return NO;
}

@end
