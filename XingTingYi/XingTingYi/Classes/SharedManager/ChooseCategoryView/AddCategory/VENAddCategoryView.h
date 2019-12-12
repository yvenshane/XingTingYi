//
//  VENAddCategoryView.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^addCategoryViewBlock)(void);
@interface VENAddCategoryView : UIView
@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) addCategoryViewBlock addCategoryViewBlock;

@end

NS_ASSUME_NONNULL_END
