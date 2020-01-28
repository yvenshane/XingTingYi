//
//  VENHomePageModel.h
//  XingTingYi
//
//  Created by YVEN on 2019/11/5.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENHomePageModel : NSObject
@property (nonatomic, copy) NSArray *aboutUs;
@property (nonatomic, copy) NSArray *banner;

@property (nonatomic, copy) NSArray *introduce;
@property (nonatomic, copy) NSString *descriptionn;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *logo;

@property (nonatomic, copy) NSArray *news;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, copy) NSArray *source;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *source_id;

@end

NS_ASSUME_NONNULL_END
