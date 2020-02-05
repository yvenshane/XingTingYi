//
//  VENExcellentCoursePageTableViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2020/2/4.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENExcellentCoursePageTableViewCell.h"

@implementation VENExcellentCoursePageTableViewCell

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
