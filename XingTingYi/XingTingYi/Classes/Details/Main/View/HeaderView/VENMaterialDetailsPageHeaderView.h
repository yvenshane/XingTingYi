//
//  VENVideoMaterialDetailsPageHeaderView.h
//  XingTingYi
//
//  Created by YVEN on 2019/9/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENMaterialDetailsPageModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^refreshBlock)(NSString *);
@interface VENMaterialDetailsPageHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *titileLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *contentButton;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIView *audioView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureImageViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioViewYLayoutConstraint;

@property (nonatomic, copy) NSDictionary *contentDict;

@end

NS_ASSUME_NONNULL_END
