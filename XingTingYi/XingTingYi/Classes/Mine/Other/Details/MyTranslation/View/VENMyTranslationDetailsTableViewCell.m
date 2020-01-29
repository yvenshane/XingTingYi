//
//  VENMyTranslationDetailsTableViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2020/1/29.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyTranslationDetailsTableViewCell.h"

@implementation VENMyTranslationDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundVieww.layer.cornerRadius = 8.0f;
    self.backgroundVieww.layer.masksToBounds = YES;
    
    self.contentView.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
    self.contentView.layer.shadowOpacity = 0.1;
    self.contentView.layer.shadowRadius = 2.5;
    self.contentView.layer.shadowOffset = CGSizeMake(0,0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
