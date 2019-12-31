//
//  VENMinePageMyNewWordBookDetailsPageViewController.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/27.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^myNewWordBookDetailsPageBlock)(void);
@interface VENMinePageMyNewWordBookDetailsPageViewController : VENBaseViewController
@property (nonatomic, copy) NSString *words_id;
@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, copy) NSArray *dataSourceArr;
@property (nonatomic, assign) NSInteger indexPathRow;

@property (nonatomic, copy) myNewWordBookDetailsPageBlock myNewWordBookDetailsPageBlock;

@end

NS_ASSUME_NONNULL_END
