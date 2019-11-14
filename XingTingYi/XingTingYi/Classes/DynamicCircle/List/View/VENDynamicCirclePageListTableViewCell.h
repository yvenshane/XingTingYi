//
//  VENDynamicCirclePageListTableViewCell.h
//  XingTingYi
//
//  Created by YVEN on 2019/8/30.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENDynamicCirclePageListModel;

NS_ASSUME_NONNULL_BEGIN

@interface VENDynamicCirclePageListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

@property (nonatomic, strong) VENDynamicCirclePageListModel *model;

@end

NS_ASSUME_NONNULL_END