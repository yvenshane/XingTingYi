//
//  VENSettingPersonalInformationModel.h
//  XingTingYi
//
//  Created by YVEN on 2019/11/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENSettingPersonalInformationModel : NSObject
@property (nonatomic, copy) NSString *formatAvatar;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *sex_name;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *english_level;
@property (nonatomic, copy) NSString *english_level_name;
@property (nonatomic, copy) NSString *japanese_level;
@property (nonatomic, copy) NSString *japanese_level_name;

@end

NS_ASSUME_NONNULL_END
