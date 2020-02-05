//
//  VENExcellentCourseDetailsPageModel.h
//  XingTingYi
//
//  Created by YVEN on 2020/2/5.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENExcellentCourseDetailsPageModel : NSObject
@property (nonatomic, copy) NSString *buynum;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *descriptionn;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) NSInteger orderStatus;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
