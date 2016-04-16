//
//  HTTPClient.h
//  HappyWriting
//
//  Created by ZhangLe on 16/3/21.
//  Copyright © 2016年 lhs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFFormData.h"

@interface HTTPClient : NSObject

+ (void)get:(NSString *)url
  parameter:(NSDictionary *)params
    success:(void (^)(id JSON))successHandler
    failure:(void (^)(NSError *error))failureHandler;

+ (void)post:(NSString *)url
   parameter:(NSDictionary *)params
     success:(void (^)(id JSON))successHandler
     failure:(void (^)(NSError *error))failureHandler;

+ (void)put:(NSString *)url
  parameter:(NSDictionary *)params
    success:(void (^)(id JSON))successHandler
    failure:(void (^)(NSError *error))failureHandler;

+ (void)deleteWithUrl:(NSString *)url
            parameter:(NSDictionary *)params
              success:(void (^)(id JSON))successHandler
              failure:(void (^)(NSError *error))failureHandler;
@end
