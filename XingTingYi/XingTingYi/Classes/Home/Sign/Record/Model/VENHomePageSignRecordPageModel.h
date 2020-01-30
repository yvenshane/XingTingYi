//
//  VENHomePageSignRecordPageModel.h
//  XingTingYi
//
//  Created by YVEN on 2020/1/30.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENHomePageSignRecordPageModel : NSObject
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *days;
@property (nonatomic, copy) NSString *dictationNum;
@property (nonatomic, copy) NSString *readNum;
@property (nonatomic, copy) NSString *subtitles;
@property (nonatomic, copy) NSString *translationNum;
@property (nonatomic, copy) NSString *wordsNum;

@end

NS_ASSUME_NONNULL_END
