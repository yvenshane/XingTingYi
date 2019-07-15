//
//  VENBaseWebViewController.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/21.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENBaseWebViewController : UIViewController
@property (nonatomic, copy) NSString *HTMLString;
@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, copy) NSString *navigationItemTitle;

@end

NS_ASSUME_NONNULL_END
