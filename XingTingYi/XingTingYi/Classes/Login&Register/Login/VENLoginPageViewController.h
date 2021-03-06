//
//  VENLoginPageViewController.h
//
//  Created by YVEN on 2019/5/7.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^loginSuccessBlock)(void);
@interface VENLoginPageViewController : UIViewController
@property (nonatomic, copy) loginSuccessBlock loginSuccessBlock;

@end

NS_ASSUME_NONNULL_END
