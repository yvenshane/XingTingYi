//
//  VENDynamicCirclePageListModel.h
//  XingTingYi
//
//  Created by YVEN on 2019/11/6.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENDynamicCirclePageListModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSArray *commentList;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *num;

@end

NS_ASSUME_NONNULL_END
