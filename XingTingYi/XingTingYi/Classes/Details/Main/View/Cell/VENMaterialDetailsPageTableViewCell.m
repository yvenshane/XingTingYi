//
//  VENMaterialDetailsPageTableViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsPageTableViewCell.h"

@implementation VENMaterialDetailsPageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentVieww.layer.cornerRadius = 8.0f;
    self.contentVieww.layer.masksToBounds = YES;
    
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
