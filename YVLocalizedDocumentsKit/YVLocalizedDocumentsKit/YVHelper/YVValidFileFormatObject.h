//
//  YVValidFileFormatObject.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/13.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    YVLocalizedFileTypeDocument = 0,// 文案
    YVLocalizedFileTypeAtla,// 图片
    YVLocalizedFileTypeVideo// 视频
} YVLocalizedFileType;

NS_ASSUME_NONNULL_BEGIN

@interface YVValidFileFormatObject : NSObject

+ (BOOL)isValidFileFormat:(NSString *)fileFormat;
+ (NSString *)uppercaseFileKindWithFileExtension:(NSString *)extension;// 返回文件分类(大写)
+ (NSString *)lowercaseFileKindWithFileExtension:(NSString *)extension;// 返回文件分类(小写)

+ (NSString *)kindClassWithFileExtension:(NSString *)extension;// 英文分类
+ (NSString *)kindClassEncodingWithFileExtension:(NSString *)extension;// 中文分类
+ (NSString *)kindClassEncodingWithFileUpExtension:(NSString *)upExtension;// 中文分类
+ (NSString *)kindClassWithFileType:(YVLocalizedFileType)fileType;// 枚举分类
+ (YVLocalizedFileType)fileTypeWithKindClass:(NSString *)kindClass;// 枚举

@end

NS_ASSUME_NONNULL_END
