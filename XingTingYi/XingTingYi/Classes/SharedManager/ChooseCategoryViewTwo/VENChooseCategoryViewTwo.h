//
//  VENChooseCategoryViewTwo.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/27.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^chooseCategoryViewTwoBlock)(NSDictionary *);
@interface VENChooseCategoryViewTwo : UIView
@property (nonatomic, copy) chooseCategoryViewTwoBlock chooseCategoryViewTwoBlock;

@property (nonatomic, copy) NSString *sort_id;
@property (nonatomic, copy) NSString *pid;

@end

NS_ASSUME_NONNULL_END
