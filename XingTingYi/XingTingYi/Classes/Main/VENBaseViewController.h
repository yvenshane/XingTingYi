//
//  VENBaseViewController.h
//
//
//  Created by YVEN.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENBaseViewController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isPresent;

- (void)setupNavigationItemLeftBarButtonItem;

@end

NS_ASSUME_NONNULL_END
