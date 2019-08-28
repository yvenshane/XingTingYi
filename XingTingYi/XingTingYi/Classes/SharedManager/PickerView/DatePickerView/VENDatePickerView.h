//
//  VENDatePickerView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^datePickerViewBlock)(NSString *);
@interface VENDatePickerView : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) datePickerViewBlock datePickerViewBlock;

@end

NS_ASSUME_NONNULL_END
