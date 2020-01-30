//
//  VENHomePageSignRecordPageTableViewCell.h
//  XingTingYi
//
//  Created by YVEN on 2020/1/30.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENHomePageSignRecordPageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backgroundVieww;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

NS_ASSUME_NONNULL_END
