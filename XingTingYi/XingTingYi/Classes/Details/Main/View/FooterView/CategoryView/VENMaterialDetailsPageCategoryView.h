//
//  VENMaterialDetailsPageCategoryView.h
//  XingTingYi
//
//  Created by YVEN on 2019/11/22.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^buttonClickBlock)(UIButton *);
@interface VENMaterialDetailsPageCategoryView : UIView
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, copy) NSString *categoryViewTitle;
@property (nonatomic, copy) buttonClickBlock buttonClickBlock;

@end

NS_ASSUME_NONNULL_END
