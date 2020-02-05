//
//  VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController : VENBaseViewController
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *translation;
@property (nonatomic, copy) NSString *source_id;

@property (nonatomic, copy) NSString *origin;

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, copy) NSString *words_id;

@property (nonatomic, assign) BOOL isPersonalMaterial;

@end

NS_ASSUME_NONNULL_END
