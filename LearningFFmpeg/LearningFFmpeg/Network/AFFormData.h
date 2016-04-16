//
//  AFFormData.h
//  HappyWriting
//
//  Created by ZhangLe on 16/3/21.
//  Copyright © 2016年 lhs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFFormData : NSObject

/**
 *  上传文件的二进制数据
 */
@property (nonatomic, strong) NSData *data;
/**
 *  上传的参数名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  上传到服务器的文件名称
 */
@property (nonatomic, copy) NSString *fileName;

/**
 *  上传文件的类型
 */
@property (nonatomic, copy) NSString *mimeType;

+ (AFFormData *)generateFormData:(UIImage *)image;

- (instancetype)initWithData:(NSData *)data filePath:(NSString *)filePath;

@end
