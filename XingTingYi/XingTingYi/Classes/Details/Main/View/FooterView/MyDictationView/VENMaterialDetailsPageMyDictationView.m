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
    
    self.contentLabel.numberOfLines = 3;
        
    [self.contentButton addTarget:self action:@selector(contentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)contentButtonClick:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        self.contentLabel.numberOfLines = 3;
    } else {
        button.selected = YES;
        self.contentLabel.numberOfLines = 0;
    }
    
    CGFloat height = [self.contentLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 35 * 2, CGFLOAT_MAX)].height;
    
    if (self.myDictationViewBlock) {
        self.myDictationViewBlock(height);
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
