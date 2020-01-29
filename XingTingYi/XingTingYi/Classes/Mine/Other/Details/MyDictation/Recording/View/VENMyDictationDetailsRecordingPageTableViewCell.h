//
//  VENMyDictationDetailsRecordingPageTableViewCell.h
//  XingTingYi
//
//  Created by YVEN on 2020/1/2.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENMyDictationDetailsRecordingPageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backgroundVieww;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundViewWidthLayoutConstraint;

@end

NS_ASSUME_NONNULL_END
