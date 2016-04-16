//
//  HTTPClient.m
//  HappyWriting
//
//  Created by ZhangLe on 16/3/21.
//  Copyright © 2016年 lhs. All rights reserved.
//

#import "HTTPClient.h"
#include "netdb.h"

typedef NS_ENUM(NSInteger, HTTPMethodType) {
    HTTPMethodTypeGET,
    HTTPMethodTypePOST,
    HTTPMethodTypePUT,
    HTTPMethodTypeDELETE
};

@interface HTTPClient ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation HTTPClient

- (instancetype)init {
    if (self = [super init]) {
        // 创建请求管理者
        self.manager = [AFHTTPSessionManager manager];
        // 请求参数序列化类型
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //超时时间的设置
        self.manager.requestSerializer.timeoutInterval = 20;
        // 设置请求ContentType
        NSSet <NSString *>*acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/html", nil];;
        self.manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    }
    return self;
}

+ (instancetype)sharedHTTPClient {
    static HTTPClient *httpClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpClient = [[HTTPClient alloc] init];
    });
    return httpClient;
}

#pragma mark - Public Class Method

+ (void)get:(NSString *)url
  parameter:(NSDictionary *)params
    success:(void (^)(id JSON))successHandler
    failure:(void (^)(NSError *error))failureHandler;
{
    [self request:url
        parameter:params
           method:HTTPMethodTypeGET
          success:successHandler
          failure:failureHandler];
}

+ (void)post:(NSString *)url
   parameter:(NSDictionary *)params
     success:(void (^)(id JSON))successHandler
     failure:(void (^)(NSError *error))failureHandler;
{
    [self request:url
        parameter:params
           method:HTTPMethodTypePOST
          success:successHandler
          failure:failureHandler];
}

+ (void)put:(NSString *)url
  parameter:(NSDictionary *)params
    success:(void (^)(id JSON))successHandler
    failure:(void (^)(NSError *error))failureHandler
{
    [self request:url
        parameter:params
           method:HTTPMethodTypePUT
          success:successHandler
          failure:failureHandler];
}

+ (void)deleteWithUrl:(NSString *)url
            parameter:(NSDictionary *)params
              success:(void (^)(id JSON))successHandler
              failure:(void (^)(NSError *error))failureHandler
{
    [self request:url
        parameter:params
           method:HTTPMethodTypeDELETE
          success:successHandler
          failure:failureHandler];
}

+ (void)request:(NSString *)url
      parameter:(NSDictionary *)params
         method:(HTTPMethodType)method
        success:(void (^)(id))successHandler
        failure:(void (^)(NSError *))failureHandler
{
    AFHTTPSessionManager *manager = [HTTPClient sharedHTTPClient].manager;
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    switch (method) {
        case HTTPMethodTypeGET: {
            [manager GET:url parameters:params progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (successHandler) {
                    successHandler(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString *errorMsg = [error localizedDescription];
                //[SVProgressHUD showErrorWithStatus:errorMsg];
                NSLog(@"GET Request error:\n %@", errorMsg);
                if (failureHandler) {
                    failureHandler(error);
                }
            }];
        } break;
        case HTTPMethodTypePOST: {
            [manager POST:url parameters:params progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (successHandler) {
                    successHandler(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString *errorMsg = [error localizedDescription];
                //[SVProgressHUD showErrorWithStatus:errorMsg];
                NSLog(@"POST Request error:\n %@", errorMsg);
                if (failureHandler) {
                    failureHandler(error);
                }
            }];

        } break;
        case HTTPMethodTypePUT: {
            [manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                if (successHandler) {
                    successHandler(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString *errorMsg = [error localizedDescription];
                //[SVProgressHUD showErrorWithStatus:errorMsg];
                NSLog(@"PUT Request error:\n %@", errorMsg);
                if (failureHandler) {
                    failureHandler(error);
                }
            }];
        } break;
        case HTTPMethodTypeDELETE:{
            [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                if (successHandler) {
                    successHandler(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString *errorMsg = [error localizedDescription];
                //[SVProgressHUD showErrorWithStatus:errorMsg];
                NSLog(@"DELETE Request error:\n %@", errorMsg);
                if (failureHandler) {
                    failureHandler(error);
                }
            }];
        } break;
    }
}

#pragma mark - Network Connection Available

/* 查看网络状态. 创建零地址，0.0.0.0的地址表示查询本机的网络连接状态 */
+ (BOOL)isConnectionAvailable {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        printf("Error. Could not recover network reachability flagsn");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

@end
