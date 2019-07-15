//
//  VENNetworkingManager.h
//
//  Created by YVEN.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef enum {
    HttpRequestTypeGET,
    HttpRequestTypePOST,
} HttpRequestType;

typedef void (^HTTPRequestSuccessBlock)(id responseObject);
typedef void (^HTTPRequestFailedBlock)(NSError *error);

@interface VENNetworkingManager : AFHTTPSessionManager
+ (instancetype)shareManager;

- (void)requestWithType:(HttpRequestType)type urlString:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock:(HTTPRequestSuccessBlock)successBlock failureBlock:(HTTPRequestFailedBlock)failureBlock;
- (void)uploadImageWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters images:(NSArray *)images keyName:(NSString *)keyName successBlock:(HTTPRequestSuccessBlock)successBlock failureBlock:(HTTPRequestFailedBlock)failureBlock;

@end
