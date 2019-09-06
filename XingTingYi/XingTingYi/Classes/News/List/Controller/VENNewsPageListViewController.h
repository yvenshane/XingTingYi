//
//  VENNewsPageListViewController.h
//  XingTingYi
//
//  Created by YVEN on 2019/8/30.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"
#import "JXCategoryListContainerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^listViewSelectBlock)(NSIndexPath *);
@interface VENNewsPageListViewController : VENBaseViewController <JXCategoryListContentViewDelegate>
@property (nonatomic, copy) listViewSelectBlock listViewSelectBlock;

@end

NS_ASSUME_NONNULL_END
