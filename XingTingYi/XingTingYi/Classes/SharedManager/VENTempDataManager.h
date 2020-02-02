//
//  VENTempDataManager.h
//  XingTingYi
//
//  Created by YVEN on 2020/2/3.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENTempDataManager : NSObject
+ (instancetype)shareManager;

- (void)setValue:(id)value forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
