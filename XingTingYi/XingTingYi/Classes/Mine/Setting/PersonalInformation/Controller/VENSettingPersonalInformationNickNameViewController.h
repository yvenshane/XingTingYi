//
//  VENSettingPersonalInformationNickNameViewController.h
//  XingTingYi
//
//  Created by YVEN on 2019/8/15.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^modifyNickNameBlock)(NSString *);
typedef void (^modifySignatureBlock)(NSString *);
@interface VENSettingPersonalInformationNickNameViewController : VENBaseViewController
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) modifyNickNameBlock modifyNickNameBlock;
@property (nonatomic, copy) modifySignatureBlock modifySignatureBlock;

@end

NS_ASSUME_NONNULL_END
