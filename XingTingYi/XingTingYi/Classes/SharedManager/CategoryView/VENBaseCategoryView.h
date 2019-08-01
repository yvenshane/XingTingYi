//
//  VENBaseCategoryView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/21.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENBaseCategoryView : UIControl
@property (nonatomic, assign) CGFloat offset_X;
@property (nonatomic, assign) NSUInteger pageNumber;
@property (nonatomic, copy) NSArray<UIButton *> *btnsArr;

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles;

@end

NS_ASSUME_NONNULL_END
