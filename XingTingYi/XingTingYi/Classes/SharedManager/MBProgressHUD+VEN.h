//
//  MBProgressHUD+VEN.h
//  
//
//  Created by YVEN.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (VEN)
+ (void)showText:(NSString *)text;
+ (void)addLoading;
+ (void)removeLoading;

@end

NS_ASSUME_NONNULL_END
