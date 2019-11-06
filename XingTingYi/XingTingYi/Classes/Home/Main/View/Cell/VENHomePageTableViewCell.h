//
//  VENHomePageTableViewCell.h
//  XingTingYi
//
//  Created by YVEN on 2019/7/15.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENHomePageModel;

NS_ASSUME_NONNULL_BEGIN

@interface VENHomePageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *discriptionLabel;

@property (nonatomic, strong) VENHomePageModel *model;

@end

NS_ASSUME_NONNULL_END
