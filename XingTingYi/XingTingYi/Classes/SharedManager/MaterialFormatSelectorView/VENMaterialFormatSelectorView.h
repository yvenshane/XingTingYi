//
//  VENMaterialFormatSelectorView.h
//  XingTingYi
//
//  Created by YVEN on 2019/9/10.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^didSelectRowBlock)(NSString *);
@interface VENMaterialFormatSelectorView : UIView
@property (nonatomic, copy) NSArray *typeListArr;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) didSelectRowBlock didSelectRowBlock;

- (void)hidden;

@end

NS_ASSUME_NONNULL_END
