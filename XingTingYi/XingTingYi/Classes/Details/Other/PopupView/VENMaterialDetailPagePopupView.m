//
//  VENMaterialDetailPagePopupView.m
//  XingTingYi
//
//  Created by YVEN on 2020/2/5.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailPagePopupView.h"
#import <UShareUI/UShareUI.h>

@implementation VENMaterialDetailPagePopupView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.backgroundButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    self.avatarImageView.layer.cornerRadius = 20.0f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    self.backgroundImageView.layer.cornerRadius = 4.0f;
    self.backgroundImageView.layer.masksToBounds = YES;
    
    self.backgroundView.layer.cornerRadius = 8.0f;
    self.backgroundView.layer.masksToBounds = YES;
    self.logoView.layer.cornerRadius = 8.0f;
    self.logoView.layer.masksToBounds = YES;
}

- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    
    self.signDayLabel.text = [NSString stringWithFormat:@"%@天日签", [formatter stringFromDate:date]];

    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:dataDict[@"bg_img"]]];
    
    NSString *days = [NSString stringWithFormat:@"%ld", [dataDict[@"days"] integerValue]];
    NSString *word = [NSString stringWithFormat:@"%ld", [dataDict[@"dictationNum"] integerValue]];
    NSString *subtitle = [NSString stringWithFormat:@"%ld", [dataDict[@"subtitlesNum"] integerValue]];
    NSString *read = [NSString stringWithFormat:@"%ld", [dataDict[@"readNum"] integerValue]];
    NSString *translation = [NSString stringWithFormat:@"%ld", [dataDict[@"translationNum"] integerValue]];
    NSString *addWords = [NSString stringWithFormat:@"%ld", [dataDict[@"wordsNum"] integerValue]];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今天我在猩听译平台学习了%@分钟", days]];
    [attributedString setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFFDE02)} range:NSMakeRange(12, days.length)];
    self.titleLabel.attributedText = attributedString;
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我已经听写了%@篇文章", word]];
    [attributedString2 setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFFDE02)} range:NSMakeRange(6, word.length)];
    self.wordLabel.attributedText = attributedString2;
    
    NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"制作了%@个字幕", subtitle]];
    [attributedString3 setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFFDE02)} range:NSMakeRange(3, subtitle.length)];
    self.subtitleLabel.attributedText = attributedString3;
    
    NSMutableAttributedString *attributedString4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"朗读了%@篇文章", read]];
    [attributedString4 setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFFDE02)} range:NSMakeRange(3, read.length)];
    self.readingLabel.attributedText = attributedString4;
    
    NSMutableAttributedString *attributedString5 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"翻译了%@篇文章", translation]];
    [attributedString5 setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFFDE02)} range:NSMakeRange(3, translation.length)];
    self.translationLabel.attributedText = attributedString5;
    
    NSMutableAttributedString *attributedString6 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"添加了%@个生词", addWords]];
    [attributedString6 setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFFDE02)} range:NSMakeRange(3, addWords.length)];
    self.addWordsLabel.attributedText = attributedString6;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:dataDict[@"avatar"]]];
    self.nameLabel.text = dataDict[@"nickname"];
}

- (IBAction)closeButtonClick:(id)sender {
    if (self.closeButtonBlock) {
        [self removeFromSuperview];
        
        self.closeButtonBlock();
    }
}

- (IBAction)wxButtonClick:(id)sender {
    [self shareImageToPlatformType:UMSocialPlatformType_WechatSession];
}

- (IBAction)wbButtonClick:(id)sender {
//    [self shareImageToPlatformType:UMSocialPlatformType_Sina];
    [MBProgressHUD showText:@"暂不支持"];
}

- (IBAction)qqButtonClick:(id)sender {
    [self shareImageToPlatformType:UMSocialPlatformType_Qzone];
}

- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    self.closeButton.hidden = YES;
    self.logoView.hidden = NO;
    
    shareObject.shareImage = [self convertViewToImage:self.shareView];
    
    self.closeButton.hidden = NO;
    self.logoView.hidden = YES;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[self getCurrentTopVC] completion:^(id data, NSError *error) {
        
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

- (UIImage *)convertViewToImage:(UIView *)view {
    CGSize size = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 获取当前屏幕显示的rootViewController
- (UIViewController *)getCurrentTopVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return [self getTopViewController:result];
}

- (UIViewController *)getTopViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self getTopViewController:[(UITabBarController *)viewController selectedViewController]];
        
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [self getTopViewController:[(UINavigationController *)viewController topViewController]];
        
    } else if (viewController.presentedViewController) {
        return [self getTopViewController:viewController.presentedViewController];
        
    } else {
        return viewController;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
