//
//  VENMaterialPageAddPersonalAudioVideoMaterialViewController.h
//  XingTingYi
//
//  Created by YVEN on 2020/1/31.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VENMaterialPageAddPersonalAudioVideoMaterialViewController : VENBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *addCoverButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@end

NS_ASSUME_NONNULL_END
