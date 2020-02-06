//
//  VENHomePageRecommendMaterialListViewController.h
//  XingTingYi
//
//  Created by YVEN on 2019/9/6.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"
#import "JXCategoryListContainerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^cellDidSelectBlock)(NSString *);
@interface VENHomePageRecommendMaterialListViewController : VENBaseViewController <JXCategoryListContentViewDelegate>
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) cellDidSelectBlock cellDidSelectBlock;

@end

NS_ASSUME_NONNULL_END
