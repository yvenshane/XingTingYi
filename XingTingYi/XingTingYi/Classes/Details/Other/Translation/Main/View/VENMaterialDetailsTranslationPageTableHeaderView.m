//
//  VENMaterialDetailsTranslationPageTableHeaderView.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/10.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsTranslationPageTableHeaderView.h"

@interface VENMaterialDetailsTranslationPageTableHeaderView () <UITextViewDelegate>

@end

@implementation VENMaterialDetailsTranslationPageTableHeaderView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.contentTextView.delegate = self;
}

#pragma mark - UITextView
- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length > 0 ? YES : NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
