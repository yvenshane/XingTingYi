//
//  VENMaterialDetailsReadAloudPageViewController.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/9.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VENMaterialDetailsReadAloudPageViewController : VENBaseViewController
@property (nonatomic, copy) NSString *source_period_id;
@property (nonatomic, assign) BOOL isPersonalMaterial;
@property (nonatomic, assign) BOOL isExcellentCourse;

@end

NS_ASSUME_NONNULL_END
