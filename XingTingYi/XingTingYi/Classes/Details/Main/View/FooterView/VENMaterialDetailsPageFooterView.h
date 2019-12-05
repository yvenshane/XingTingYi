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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryContentViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myDictationViewHeightLayoutConstraint;

@property (nonatomic, copy) NSDictionary *contentDict;
@property (nonatomic, copy) NSString *categoryViewContent;
@property (nonatomic, copy) NSString *categoryViewTitle;
@property (nonatomic, copy) NSString *numberOfLines;

@property (weak, nonatomic) IBOutlet UIButton *lockButton;
@property (weak, nonatomic) IBOutlet UIView *sectionDictationView;

@end

NS_ASSUME_NONNULL_END
