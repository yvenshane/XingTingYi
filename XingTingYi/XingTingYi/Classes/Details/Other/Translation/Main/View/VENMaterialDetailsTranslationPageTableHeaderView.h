//
//  VENMaterialDetailsTranslationPageTableHeaderView.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/10.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^titleButtonClickBlock)(void);
@interface VENMaterialDetailsTranslationPageTableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UITextField *otherTextField;
@property (weak, nonatomic) IBOutlet UITextField *otherTextFieldTwo;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@property (nonatomic, copy) titleButtonClickBlock titleButtonClickBlock;

@end

NS_ASSUME_NONNULL_END
