//
//  VENHomePageTableViewCellTwo.m
//  XingTingYi
//
//  Created by YVEN on 2019/7/19.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageTableViewCellTwo.h"

@implementation VENHomePageTableViewCellTwo

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
