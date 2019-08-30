//
//  VENNewsPageListTableViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2019/8/30.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENNewsPageListTableViewCell.h"

@implementation VENNewsPageListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    ViewRadius(self.avatarImageView, 18.0f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
