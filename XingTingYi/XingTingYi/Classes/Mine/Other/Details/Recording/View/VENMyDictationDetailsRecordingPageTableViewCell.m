//
//  VENMyDictationDetailsRecordingPageTableViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2020/1/2.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyDictationDetailsRecordingPageTableViewCell.h"

@implementation VENMyDictationDetailsRecordingPageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundVieww.layer.cornerRadius = 20.0f;
    self.backgroundVieww.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
