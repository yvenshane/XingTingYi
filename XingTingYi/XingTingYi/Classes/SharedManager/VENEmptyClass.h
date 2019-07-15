//
//  VENEmptyClass.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/7.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENEmptyClass : NSObject

+ (BOOL)isEmptyString:(NSString *)string;
+ (BOOL)isEmptyArray:(NSArray *)array;
+ (BOOL)isEmptyDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
