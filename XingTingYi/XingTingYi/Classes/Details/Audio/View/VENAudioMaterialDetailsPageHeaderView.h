//
//  VENAudioMaterialDetailsPageHeaderView.h
//  XingTingYi
//
//  Created by YVEN on 2019/9/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENAudioMaterialDetailsPageModel;

NS_ASSUME_NONNULL_BEGIN

@interface VENAudioMaterialDetailsPageHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *titileLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *contentButton;
@property (weak, nonatomic) IBOutlet UIView *audioView;
@property (weak, nonatomic) IBOutlet UIView *categoryView;

@property (weak, nonatomic) IBOutlet UIView *myDictationView;
@property (weak, nonatomic) IBOutlet UIView *myDictationContentView;
@property (weak, nonatomic) IBOutlet UILabel *myDictationContentLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureImageViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioViewHeightLayoutConstraint;

@property (nonatomic, strong) VENAudioMaterialDetailsPageModel *model;

@end

NS_ASSUME_NONNULL_END
