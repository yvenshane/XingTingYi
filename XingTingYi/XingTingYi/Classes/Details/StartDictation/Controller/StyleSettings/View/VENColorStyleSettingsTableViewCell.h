//
//  VENColorStyleSettingsTableViewCell.h
//  XingTingYi
//
//  Created by YVEN on 2019/9/29.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENColorStyleSettingsTableViewCell : UITableViewCell
@property (nonatomic, copy) NSArray *colorArr;
@property (nonatomic, strong) UIColor *selectedColor;

@end

NS_ASSUME_NONNULL_END
