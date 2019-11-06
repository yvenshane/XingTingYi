//
//  VENHomePageTableViewCellTwo.h
//  XingTingYi
//
//  Created by YVEN on 2019/7/19.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENHomePageModel;

NS_ASSUME_NONNULL_BEGIN

@interface VENHomePageTableViewCellTwo : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) VENHomePageModel *model;

@end

NS_ASSUME_NONNULL_END
