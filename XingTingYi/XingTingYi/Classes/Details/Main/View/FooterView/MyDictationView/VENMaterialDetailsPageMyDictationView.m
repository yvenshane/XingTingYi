//
//  VENMaterialDetailsPageMyDictationView.m
//  XingTingYi
//
//  Created by YVEN on 2019/11/25.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsPageMyDictationView.h"

@implementation VENMaterialDetailsPageMyDictationView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.contentVieww.layer.cornerRadius = 8.0f;
    self.contentVieww.layer.masksToBounds = YES;
    self.contentVieww.layer.borderWidth = 1.0f;
    self.contentVieww.layer.borderColor = UIColorFromRGB(0xE8E8E8).CGColor;
    
    if ([self.numberOfLines integerValue] == 0) {
        self.contentButton.selected = YES;
        [self.contentButton setImage:[UIImage imageNamed:@"icon_more_up"] forState:UIControlStateNormal];
    } else {
        self.contentButton.selected = NO;
        [self.contentButton setImage:[UIImage imageNamed:@"icon_more_down"] forState:UIControlStateNormal];
    }
    
    [self.contentButton addTarget:self action:@selector(contentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)contentButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShrinkButtonClick" object:nil userInfo:@{@"button" : button}];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
