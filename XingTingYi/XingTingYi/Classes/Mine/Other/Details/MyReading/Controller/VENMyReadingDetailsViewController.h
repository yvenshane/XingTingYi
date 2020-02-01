//
//  VENMyReadingDetailsViewController.h
//  XingTingYi
//
//  Created by YVEN on 2020/1/28.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^deleteBlock)(void);
@interface VENMyReadingDetailsViewController : VENBaseViewController
@property (nonatomic, copy) NSString *source_id;
@property (nonatomic, copy) deleteBlock deleteBlock;

@property (nonatomic, assign) BOOL isPersonalMaterial;

@end

NS_ASSUME_NONNULL_END
