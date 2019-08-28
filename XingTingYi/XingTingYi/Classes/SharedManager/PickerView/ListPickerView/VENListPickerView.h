//
//  VENListPickerView.h
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^listPickerViewBlock)(NSDictionary *);
@interface VENListPickerView : UIView
@property (nonatomic, copy) NSArray *dataSourceArr;
@property (nonatomic, copy) listPickerViewBlock listPickerViewBlock;

@end

NS_ASSUME_NONNULL_END
