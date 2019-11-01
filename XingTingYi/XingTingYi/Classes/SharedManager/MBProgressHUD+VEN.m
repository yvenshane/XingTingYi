//
//  MBProgressHUD+VEN.m
//
//
//  Created by YVEN.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "MBProgressHUD+VEN.h"

@implementation MBProgressHUD (VEN)

+ (void)showText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
    
    hud.userInteractionEnabled = NO;
}

+ (void)addLoading {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)removeLoading {
    [self hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

@end
