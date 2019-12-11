//
//  VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UITextField *nnewWordsTextField;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextField *translateTextField;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabelOne;
@property (weak, nonatomic) IBOutlet UITextView *textViewOne;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabelTwo;
@property (weak, nonatomic) IBOutlet UITextView *textViewTwo;

@end

NS_ASSUME_NONNULL_END
