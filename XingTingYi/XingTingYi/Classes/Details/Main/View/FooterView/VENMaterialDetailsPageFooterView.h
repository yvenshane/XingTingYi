//
//  VENMaterialDetailsPageFooterView.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/4.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENMaterialDetailsPageFooterView : UIView
@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (weak, nonatomic) IBOutlet UIView *categoryContentView;
@property (weak, nonatomic) IBOutlet UILabel *categoryContentLabel;
@property (weak, nonatomic) IBOutlet UIView *myDictationView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *sectionDictationTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *categoryButtonView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLeftLabel;
@property (weak, nonatomic) IBOutlet UIView *categoryLeftView;
@property (weak, nonatomic) IBOutlet UILabel *categoryRightLabel;
@property (weak, nonatomic) IBOutlet UIView *categoryRightView;
@property (weak, nonatomic) IBOutlet UIButton *categoryLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *categoryRightButton;

@property (weak, nonatomic) IBOutlet UIView *audioView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryContentViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myDictationViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sectionDictationViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryButtonViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioViewHeightLayoutConstraint;

@property (nonatomic, copy) NSDictionary *contentDict;
@property (nonatomic, copy) NSString *categoryViewContent;
@property (nonatomic, copy) NSString *categoryViewTitle;
@property (nonatomic, copy) NSString *numberOfLines;

@property (weak, nonatomic) IBOutlet UIButton *lockButton;
@property (weak, nonatomic) IBOutlet UIView *sectionDictationView;

@property (nonatomic, assign) BOOL isTextInfo; // 切换分段听写/朗读翻译

@end

NS_ASSUME_NONNULL_END
