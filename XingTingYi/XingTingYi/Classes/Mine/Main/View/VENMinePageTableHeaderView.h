//
//  VENMinePageTableHeaderView.h
//  XingTingYi
//
//  Created by YVEN on 2019/8/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENMinePageModel;

NS_ASSUME_NONNULL_BEGIN

@interface VENMinePageTableHeaderView : UIView
@property (nonatomic, strong) UIButton *setttingButton;
@property (nonatomic, strong) VENMinePageModel *model;

@end

NS_ASSUME_NONNULL_END
