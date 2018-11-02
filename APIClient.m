//
//  APIClient.m
//  EHomeland
//
//  Created by zhangcn on 16/8/26.
//  Copyright (c) 2016年 zhangcn. All rights reserved.
//

#import "APIClient.h"
#import "CustomError.h"

@implementation APIClient

static APIClient *sharedMgr = nil;

+ (instancetype)sharedClient {
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:APP_HOST]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

- (NSString *)buildURL:(NSString *)url{
    return [NSString stringWithFormat:@"%@%@",APP_HOST,url];
}

- (void)get:(NSString*)action params:(NSDictionary*)params success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSError *error))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"%@",[self buildURL:action]);

    [manager GET:[self buildURL:action] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        
        success(dic);


    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        CustomError *err = [[CustomError alloc]initWithDomain:error.domain code:error.code userInfo:error.userInfo localizedDescription:[self errorDescriptionErr:error]];
        failure(err);
        
    }];
    
}

- (void)post:(NSString*)action params:(id)params success:(void(^)(NSDictionary *responseObject))success failure:(void(^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/plain", nil];
    
   manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json", @"text/javascript", @"text/html", nil];

    NSLog(@"%@",[self buildURL:action]);

    [manager POST:[self buildURL:action] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hideLoading();
        showAlter(@"服务器异常");
        CustomError *err = [[CustomError alloc]initWithDomain:error.domain code:error.code userInfo:error.userInfo localizedDescription:[self errorDescriptionErr:error]];
        if (failure) {
            failure(err);
        }
    }];
}

-(NSString *)errorDescriptionErr:(NSError *)error{
    
    if (error.code == kCFURLErrorCannotFindHost ||
        error.code == kCFURLErrorBadServerResponse ||
        error.code == kCFURLErrorUnsupportedURL) {
        return @"服务器异常.";
    }else if (error.code == kCFURLErrorTimedOut) {
        return @"网络连接超时.";
    }else if (error.code == kCFURLErrorNotConnectedToInternet ||
              error.code == kCFURLErrorNetworkConnectionLost || error.code == kCFURLErrorNotConnectedToInternet) {
        return @"网络连接失败";
    }else if (error.code==kCFURLErrorCannotConnectToHost){
        return @"请检查您的网络.";
    }
    
    return error.localizedDescription;
}


- (NSString *)didFinishWithError:(NSError *)error {
    
    NSString *err;
    
    if (error.code == -1001 || error.code == 502) {
        err = @"网络连接超时.";
    }
    
    if (error.code == -1009) {
        err = @"未连接到网络.";
    }
    
    if (error.code == -1004) {
        err = @"未连接到服务器.";
    }
    
    
    if (error.code == 404 || error.code == -1005) {
        err = @"服务器异常.";
    }
    
    if (error.code == -1016) {
        err = @"数据内容解码异常.";
    }else {
        err = @"未知错误.";
    }
    
    return err;

}
- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

@end
