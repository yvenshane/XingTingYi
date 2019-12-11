//
//  VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView.h"

@interface VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView () <UITextViewDelegate>

@end

@implementation VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.nnewWordsTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 48)];
    self.nnewWordsTextField.rightViewMode = UITextFieldViewModeAlways;
    
    self.translateTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 48)];
    self.translateTextField.rightViewMode = UITextFieldViewModeAlways;
    
    self.textViewOne.delegate = self;
    self.textViewOne.tag = 998;
    self.textViewTwo.delegate = self;
    self.textViewTwo.tag = 999;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        if (textView.tag == 998) {
            self.placeholderLabelOne.hidden = YES;
        } else {
            self.placeholderLabelTwo.hidden = YES;
        }
    } else {
        if (textView.tag == 998) {
            self.placeholderLabelOne.hidden = NO;
        } else {
            self.placeholderLabelTwo.hidden = NO;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
