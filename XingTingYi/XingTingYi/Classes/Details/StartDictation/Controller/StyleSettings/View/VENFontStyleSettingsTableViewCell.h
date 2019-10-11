//
//  VENFontStyleSettingsTableViewCell.h
//  XingTingYi
//
//  Created by YVEN on 2019/9/29.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENFontStyleSettingsTableViewCell : UITableViewCell
@property (nonatomic, copy) NSArray *fontSizeArr;
@property (nonatomic, assign) CGFloat currentFontSize;

@end

NS_ASSUME_NONNULL_END
