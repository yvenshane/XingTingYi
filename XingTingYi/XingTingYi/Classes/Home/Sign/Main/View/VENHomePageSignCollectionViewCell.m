//
//  VENHomePageSignCollectionViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2020/1/29.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageSignCollectionViewCell.h"

@implementation VENHomePageSignCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.numberButton.layer.cornerRadius = 12.0f;
    self.numberButton.layer.masksToBounds = YES;
    
    [self.numberButton addTarget:self action:@selector(numberButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)numberButtonClick {
    if (self.numberButtonClickBlock) {
        self.numberButtonClickBlock();
    }
}

@end
