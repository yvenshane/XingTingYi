//
//  VENBottomToolsBarView.m
//  XingTingYi
//
//  Created by YVEN on 2019/10/10.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBottomToolsBarView.h"

@implementation VENBottomToolsBarView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    // 键盘
    [self.keyboardButton setImage:[UIImage imageNamed:@"icon_keyboard"] forState:UIControlStateNormal];
    [self.keyboardButton setImage:[UIImage imageNamed:@"icon_keyboard01"] forState:UIControlStateSelected];
    [self.keyboardButton addTarget:self action:@selector(keyboardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    

}

- (void)keyboardButtonClick:(UIButton *)button {
    if (button.selected) {
        if (self.textView.inputView) {
            [self.keyboardButton setImage:[UIImage imageNamed:@"icon_keyboard01"] forState:UIControlStateSelected];
            self.textView.inputView = nil;
            [self.textView reloadInputViews];
        } else {
            button.selected = NO;
            [self.textView resignFirstResponder];
        }
    } else {
        button.selected = YES;
        [self.textView becomeFirstResponder];
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
