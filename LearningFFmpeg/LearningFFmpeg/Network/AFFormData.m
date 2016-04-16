//
//  AFFormData.m
//  HappyWriting
//
//  Created by ZhangLe on 16/3/21.
//  Copyright © 2016年 lhs. All rights reserved.
//

#import "AFFormData.h"

static NSString *const kPhotoFilePath = @"happywriting_upload_photo";

@implementation AFFormData

- (instancetype)initWithData:(NSData *)data filePath:(NSString *)filePath {
    if (self = [super init]) {
        _data = data;
        _fileName = filePath;
        _name = @"file";
        _mimeType = @"image/png";
    }
    return self;
}

+ (AFFormData *)generateFormData:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.75);
    NSString *filePath = [self filePathToUploadImage];
    if ([data writeToFile:filePath atomically:YES]) {
        AFFormData *formData = [[AFFormData alloc] initWithData:data
                                                       filePath:filePath];
        return formData;
    }
    return nil;
}

#pragma mark - helpers

+ (NSString *)createSubFolder:(NSString *)folder {
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:folder];
    BOOL existed = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return folderPath;
}

+ (NSString *)filePathWithName:(NSString *)name withFolder:(NSString *)folder {
    NSString *filePath = [[self createSubFolder:folder] stringByAppendingPathComponent:name];
    return filePath;
}

+ (NSString *)filePathToUploadImage {
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *imageName = [NSString stringWithFormat:@"%.2f.png",timestamp];
    return [self filePathWithName:imageName withFolder:kPhotoFilePath];
}

@end
