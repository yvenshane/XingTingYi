//
//  VENHomePageSignRecordPageTableViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2020/1/30.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageSignRecordPageTableViewCell.h"

@implementation VENHomePageSignRecordPageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    
    self.backgroundVieww.layer.cornerRadius = 8.0f;
    
    self.backgroundVieww.layer.shadowOpacity = 0.1;
    self.backgroundVieww.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
    self.backgroundVieww.layer.shadowOpacity = 0.1;
    self.backgroundVieww.layer.shadowRadius = 2.5;
    self.backgroundVieww.layer.shadowOffset = CGSizeMake(0,0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
