//
//  VENHomePageBannerCollectionViewCell.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/15.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageBannerCollectionViewCell.h"

@implementation VENHomePageBannerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    ViewRadius(self.bannerImageView, 5.0f);
}

@end
