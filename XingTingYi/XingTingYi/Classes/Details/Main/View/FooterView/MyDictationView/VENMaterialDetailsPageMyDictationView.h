//
//  VENMaterialDetailsPageMyDictationView.h
//  XingTingYi
//
//  Created by YVEN on 2019/11/25.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENMaterialDetailsPageMyDictationView : UIView
@property (weak, nonatomic) IBOutlet UIView *contentVieww;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *contentButton;

@property (nonatomic, copy) NSString *numberOfLines;

@end

NS_ASSUME_NONNULL_END
