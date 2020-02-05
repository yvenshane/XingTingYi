//
//  VENVideoMaterialDetailsStartDictationPageViewController.h
//  XingTingYi
//
//  Created by YVEN on 2019/10/10.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VENMaterialDetailsStartDictationPageViewController : VENBaseViewController
@property (nonatomic, copy) NSString *source_id;
@property (nonatomic, copy) NSString *source_period_id;
@property (nonatomic, assign) BOOL isSectionDictation;

@property (nonatomic, assign) BOOL isPersonalMaterial;
@property (nonatomic, strong) NSURL *videoURL;

@end

NS_ASSUME_NONNULL_END
