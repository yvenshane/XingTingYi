//
//  VENDynamicCirclePageDetailsCommentTableViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/6.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENDynamicCirclePageDetailsCommentTableViewCell.h"
#import "VENDynamicCirclePageDetailsModel.h"

@implementation VENDynamicCirclePageDetailsCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(VENDynamicCirclePageDetailsModel *)model {
    _model = model;
    
    for (UIView *subviews in self.contentVieww.subviews) {
        [subviews removeFromSuperview];
    }
    
    NSString *contentStr = @"";
    
    if ([VENEmptyClass isEmptyString:model.replyusername]) {
        contentStr = [NSString stringWithFormat:@"%@：%@", model.username, model.content];
    } else {
        contentStr = [NSString stringWithFormat:@"%@ 回复 %@：%@", model.username, model.replyusername, model.content];
    }
    
    YYLabel *contentLabel = [[YYLabel alloc] init];
    contentLabel.numberOfLines = 0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    attributedString.yy_color = UIColorFromRGB(0x666666);
    attributedString.yy_font = [UIFont systemFontOfSize:12.0f];
    attributedString.yy_lineSpacing = 5.0f;
    
    if ([VENEmptyClass isEmptyString:model.replyusername]) {
        [attributedString yy_setFont:[UIFont systemFontOfSize:12.0f weight:UIFontWeightMedium] range:NSMakeRange(0, model.username.length + 1)];
        [attributedString yy_setTextHighlightRange:NSMakeRange(0, model.username.length) color:UIColorFromRGB(0x222222) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (self.userNameClickBlock) {
                self.userNameClickBlock(@{@"name" : model.username,
                @"id" : model.user_id});
            }
        }];
    } else {
        [attributedString yy_setFont:[UIFont systemFontOfSize:12.0f weight:UIFontWeightMedium] range:NSMakeRange(0, model.username.length + 1)];
        [attributedString yy_setTextHighlightRange:NSMakeRange(0, model.username.length) color:UIColorFromRGB(0x222222) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (self.userNameClickBlock) {
                self.userNameClickBlock(@{@"name" : model.username,
                @"id" : model.user_id});
            }
        }];
        
        [attributedString yy_setFont:[UIFont systemFontOfSize:12.0f weight:UIFontWeightMedium] range:NSMakeRange(model.username.length + 4, model.replyusername.length + 1)];
        [attributedString yy_setTextHighlightRange:NSMakeRange(model.username.length + 4, model.replyusername.length + 1) color:UIColorFromRGB(0x222222) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (self.userNameClickBlock) {
                self.userNameClickBlock(@{@"name" : model.username,
                @"id" : model.user_id});
            }
        }];
    }
    
    contentLabel.attributedText = attributedString;
    CGFloat width = kMainScreenWidth - 66 - 20 - 12;
    CGFloat height = [contentLabel sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height;
    contentLabel.frame = CGRectMake(10, 6, width, height);
    [self.contentVieww addSubview:contentLabel];
    
    self.contentViewwLayoutConstraintHeight.constant = height + 12;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
