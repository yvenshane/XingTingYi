//
//  VENHomePageTableViewHeaderViewTwo.h
//  XingTingYi
//
//  Created by YVEN on 2019/7/22.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENHomePageModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^moreButtonClickBlock)(NSString *);
@interface VENHomePageTableViewHeaderViewTwo : UIView
@property (nonatomic, strong) VENHomePageModel *model;
@property (nonatomic, copy) moreButtonClickBlock moreButtonClickBlock;

@end

NS_ASSUME_NONNULL_END
