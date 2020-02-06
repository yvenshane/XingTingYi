//
//  VENMaterialDetailsPageFooterView.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/4.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^categoryButtonBlock)(NSInteger, BOOL);
typedef void (^bottomViewButtonBlock)(NSInteger);
@interface VENMaterialDetailsPageFooterView : UIView
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *bottomViewLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomViewRightButton;
@property (weak, nonatomic) IBOutlet UILabel *sectionDictationTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *categoryButtonView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLeftLabel;
@property (weak, nonatomic) IBOutlet UIView *categoryLeftView;
@property (weak, nonatomic) IBOutlet UILabel *categoryRightLabel;
@property (weak, nonatomic) IBOutlet UIView *categoryRightView;
@property (weak, nonatomic) IBOutlet UIButton *categoryLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *categoryRightButton;
@property (weak, nonatomic) IBOutlet UIView *sectionDictationView;
@property (weak, nonatomic) IBOutlet UIView *audioView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sectionDictationViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryButtonViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioViewHeightLayoutConstraint;

@property (nonatomic, copy) categoryButtonBlock categoryButtonBlock;
@property (nonatomic, copy) bottomViewButtonBlock bottomViewButtonBlock;

@property (nonatomic, assign) BOOL isTextInfo;

- (CGFloat)getHeightFromData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
