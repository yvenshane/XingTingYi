//
//  VENLabelPickerViewTwo.h
//  XingTingYi
//
//  Created by YVEN on 2019/11/28.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^labelPickerViewBlock)(NSDictionary *);
@interface VENLabelPickerViewTwo : UIView
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, copy) labelPickerViewBlock labelPickerViewBlock;

@end

NS_ASSUME_NONNULL_END
