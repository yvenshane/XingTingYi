//
//  VENSettingTableViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2019/8/13.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENSettingTableViewCell.h"

@implementation VENSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    ViewRadius(self.iconImageView, 20.0f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
