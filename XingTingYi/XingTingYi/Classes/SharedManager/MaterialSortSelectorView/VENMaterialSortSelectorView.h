//
//  VENMaterialSortSelectorView.h
//  XingTingYi
//
//  Created by YVEN on 2019/9/9.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^didSelectItemBlock)(NSDictionary *);
@interface VENMaterialSortSelectorView : UIView
@property (nonatomic, copy) NSArray *sourceCategoryArr;
@property (nonatomic, copy) NSString *category_one_id;
@property (nonatomic, copy) NSString *category_two_id;
@property (nonatomic, copy) NSString *category_three_id;

@property (nonatomic, copy) didSelectItemBlock didSelectItemBlock;

- (void)hidden;

@end

NS_ASSUME_NONNULL_END
