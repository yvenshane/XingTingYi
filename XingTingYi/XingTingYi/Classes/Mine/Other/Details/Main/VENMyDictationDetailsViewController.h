//
//  VENMyDictationDetailsViewController.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/31.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^deleteBlock)(void);
@interface VENMyDictationDetailsViewController : VENBaseViewController
@property (nonatomic, copy) NSString *source_id;
@property (nonatomic, copy) deleteBlock deleteBlock;

@end

NS_ASSUME_NONNULL_END
