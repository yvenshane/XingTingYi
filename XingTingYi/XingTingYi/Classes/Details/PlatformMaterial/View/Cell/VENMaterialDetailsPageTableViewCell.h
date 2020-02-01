//
//  VENMaterialDetailsPageTableViewCell.h
//  XingTingYi
//
//  Created by YVEN on 2019/9/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENMaterialDetailsPageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *contentVieww;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

NS_ASSUME_NONNULL_END
