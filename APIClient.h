//
//  APIClient.h
//  EHomeland
//
//  Created by zhangcn on 16/8/26.
//  Copyright (c) 2016年 zhangcn. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

#define APIsHost  [APIClient sharedInstance]

@interface APIClient : AFHTTPSessionManager

/**是否判断登录*/
@property (nonatomic) BOOL isVerdict;

+ (instancetype)sharedClient;

- (NSString *)didFinishWithError:(NSError *)error;

- (void)get:(NSString*)action params:(NSDictionary*)params success:(void(^)(NSDictionary *responseObject))success
    failure:(void(^)(NSError *error))failure;

- (void)post:(NSString*)action params:(id)params success:(void(^)(NSDictionary *responseObject))success
     failure:(void(^)(NSError *error))failure;


@end
