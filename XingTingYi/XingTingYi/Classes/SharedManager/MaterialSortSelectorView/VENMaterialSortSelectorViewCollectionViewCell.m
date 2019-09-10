//
//  VENMaterialSortSelectorViewCollectionViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/10.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialSortSelectorViewCollectionViewCell.h"

@implementation VENMaterialSortSelectorViewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.layer.cornerRadius = 20.0f;
    self.titleLabel.layer.masksToBounds = YES;
}

@end
