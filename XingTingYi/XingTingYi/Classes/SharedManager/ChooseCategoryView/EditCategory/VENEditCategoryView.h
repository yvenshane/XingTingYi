//
//  VENEditCategoryView.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^editCategoryViewBlock)(void);
@interface VENEditCategoryView : UIView
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *idName;

@property (nonatomic, copy) editCategoryViewBlock editCategoryViewBlock;

@end

NS_ASSUME_NONNULL_END
