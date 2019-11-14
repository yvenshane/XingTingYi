//
//  VENDynamicCirclePageListViewController.h
//  XingTingYi
//
//  Created by YVEN on 2019/8/30.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"
#import "JXCategoryListContainerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^listViewSelectBlock)(NSString *);
@interface VENDynamicCirclePageListViewController : VENBaseViewController <JXCategoryListContentViewDelegate>
@property (nonatomic, copy) listViewSelectBlock listViewSelectBlock;
@property (nonatomic, copy) NSString *sort_id;

@end

NS_ASSUME_NONNULL_END
