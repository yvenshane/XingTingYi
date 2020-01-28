//
//  VENVideoMaterialDetailsPageModel.h
//  XingTingYi
//
//  Created by YVEN on 2019/9/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENMaterialDetailsPageModel : NSObject
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *category_one_id;
@property (nonatomic, copy) NSString *category_three_id;
@property (nonatomic, copy) NSString *category_two_id;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *descriptionn;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *notice;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *source_path;
@property (nonatomic, copy) NSString *subtitles;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *view_count;
@property (nonatomic, copy) NSString *words;

@property (nonatomic, copy) NSDictionary *dictationInfo;
//@property (nonatomic, copy) NSArray *id;
//@property (nonatomic, copy) NSArray *path;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSArray *subtitlesList;

// dictationInfo
//@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *source_id;
@property (nonatomic, copy) NSString *source_period_id;
@property (nonatomic, copy) NSString *content;
//@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *user_id;
//@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSArray *dictation_tag;

@property (nonatomic, copy) NSString *read;
@property (nonatomic, copy) NSDictionary *translation;
@property (nonatomic, copy) NSString *merge_audio;

@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
