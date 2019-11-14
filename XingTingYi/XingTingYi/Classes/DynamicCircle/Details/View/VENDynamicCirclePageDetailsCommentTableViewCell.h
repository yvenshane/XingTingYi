//
//  VENDynamicCirclePageDetailsCommentTableViewCell.h
//  XingTingYi
//
//  Created by YVEN on 2019/9/6.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENDynamicCirclePageDetailsModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^userNameClickBlock)(NSDictionary *);
@interface VENDynamicCirclePageDetailsCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *contentVieww;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewwLayoutConstraintHeight;

@property (nonatomic, strong) VENDynamicCirclePageDetailsModel *model;
@property (nonatomic, copy) userNameClickBlock userNameClickBlock;

@end

NS_ASSUME_NONNULL_END
