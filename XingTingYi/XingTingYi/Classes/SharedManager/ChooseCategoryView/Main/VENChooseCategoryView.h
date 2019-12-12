//
//  VENChooseCategoryView.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^chooseCategoryViewBlock)(NSDictionary *);
@interface VENChooseCategoryView : UIView
@property (nonatomic, copy) chooseCategoryViewBlock chooseCategoryViewBlock;

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *sort_id;

@end

NS_ASSUME_NONNULL_END
