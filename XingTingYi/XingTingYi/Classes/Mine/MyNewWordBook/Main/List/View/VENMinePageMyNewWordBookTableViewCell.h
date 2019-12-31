//
//  VENMinePageMyNewWordBookTableViewCell.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/14.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENMinePageMyNewWordBookTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *discriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *editImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discriptionLabelRightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabel2RightLayoutConstraint;

@end

NS_ASSUME_NONNULL_END
