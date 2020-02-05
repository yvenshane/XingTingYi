//
//  VENStyleSettingsController.h
//  XingTingYi
//
//  Created by YVEN on 2019/9/29.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMTextStyle;

NS_ASSUME_NONNULL_BEGIN

@interface VENStyleSettingsController : UIViewController
@property (nonatomic, strong) LMTextStyle *textStyle;

- (void)reload;

@end

NS_ASSUME_NONNULL_END
