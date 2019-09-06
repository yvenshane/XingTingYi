//
//  VENHomePageTableViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2019/7/15.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageTableViewCell.h"

@implementation VENHomePageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    ViewRadius(self.iconImageView, 4);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
