//
//  VENMaterialDetailsPageFooterView.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/4.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsPageFooterView.h"
#import "VENMaterialDetailsPageModel.h"
#import "VENMaterialDetailsPageCategoryView.h"
#import "VENMaterialDetailsPageMyDictationView.h"

@interface VENMaterialDetailsPageFooterView ()
@property (nonatomic, strong) VENMaterialDetailsPageCategoryView *categoryVieww;
@property (nonatomic, strong) VENMaterialDetailsPageMyDictationView *myDictationVieww;

@end

@implementation VENMaterialDetailsPageFooterView

- (void)setContentDict:(NSDictionary *)contentDict {
    _contentDict = contentDict;
    
    VENMaterialDetailsPageModel *infoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:contentDict[@"info"]];
    NSArray *avInfoArr = [NSArray yy_modelArrayWithClass:[VENMaterialDetailsPageModel class] json:contentDict[@"avInfo"]];
    
    VENMaterialDetailsPageModel *avInfoModel;
    if (avInfoArr.count > 0) {
        avInfoModel = avInfoArr[0];
    }
    
    // category view
    self.categoryContentView.layer.cornerRadius = 8.0f;
    self.categoryContentView.layer.masksToBounds = YES;
    
    self.categoryVieww.categoryViewTitle = self.categoryViewTitle;
    self.categoryVieww.titleArr = @[@"提示词", @"生词汇总", @"标准答案"];
    
    __weak typeof(self) weakSelf = self;
    self.categoryVieww.buttonClickBlock = ^(UIButton *button) {
        
        weakSelf.lockButton.hidden = YES;
        weakSelf.categoryContentLabel.hidden = NO;
        
        NSString *tempStr = @"";
        
        if (button.tag == 0) {
            tempStr = infoModel.notice;
        } else if (button.tag == 1) {
            tempStr = infoModel.words;
        } else {
            tempStr = infoModel.answer;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDetailPage" object:nil userInfo:@{@"content" : tempStr, @"title" : button.titleLabel.text}];
    };

    self.categoryContentLabel.text = [VENEmptyClass isEmptyString:self.categoryViewContent] ? infoModel.notice : self.categoryViewContent;
    CGFloat height = [self.categoryContentLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 20 * 2 - 15 * 2, CGFLOAT_MAX)].height;

    self.categoryContentViewHeightLayoutConstraint.constant = height + 15 * 2;
    
    if ([self.categoryViewTitle isEqualToString:@"标准答案"]) {
        if ([VENEmptyClass isEmptyString:avInfoModel.dictationInfo[@"id"]]) {
            self.lockButton.hidden = NO;
            self.categoryContentLabel.hidden = YES;
            self.categoryContentViewHeightLayoutConstraint.constant = 120;
        }
    }
    
    // my dictation view
    if (![VENEmptyClass isEmptyString:avInfoModel.dictationInfo[@"content"]]) {
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[avInfoModel.dictationInfo[@"content"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        self.myDictationVieww.numberOfLines = self.numberOfLines;
        self.myDictationVieww.contentLabel.numberOfLines = [self.numberOfLines integerValue];
        self.myDictationVieww.contentLabel.attributedText = attributedString;
        [self.myDictationView addSubview:self.myDictationVieww];
        
        CGFloat height = [self.myDictationVieww.contentLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 35 * 2, CGFLOAT_MAX)].height;
        
        self.myDictationViewHeightLayoutConstraint.constant = 23.5 + 20 + 15 + 40 + height + 36;
    } else {
        self.myDictationViewHeightLayoutConstraint.constant = 0.0f;
    }
    
    // sectionDictationView
    if (avInfoArr.count > 1) {
        self.sectionDictationView.hidden = NO;
    } else {
        self.sectionDictationView.hidden = YES;
    }
}

#pragma mark - 分类视图
- (VENMaterialDetailsPageCategoryView *)categoryVieww {
    if (!_categoryVieww) {
        _categoryVieww = [[VENMaterialDetailsPageCategoryView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 25)];
        [self.categoryView addSubview:_categoryVieww];
    }
    return _categoryVieww;
}

#pragma mark - 我的听写视图
- (VENMaterialDetailsPageMyDictationView *)myDictationVieww {
    if (!_myDictationVieww) {
        _myDictationVieww = [[NSBundle mainBundle] loadNibNamed:@"VENMaterialDetailsPageMyDictationView" owner:nil options:nil].lastObject;
        _myDictationVieww.frame = CGRectMake(0, 0, kMainScreenWidth, 200);
    }
    return _myDictationVieww;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
