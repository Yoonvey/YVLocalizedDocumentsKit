//
//  YVValidFileFormatObject.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/13.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "YVValidFileFormatObject.h"

@implementation YVValidFileFormatObject

+ (NSArray *)validFileFormats
{
    NSMutableArray *formats = [NSMutableArray array];
    
    // bin
    [formats addObject:@"bin"];
    
    // excel
    [formats addObject:@"xls"];
    [formats addObject:@"xlsx"];
    
    // word
    [formats addObject:@"doc"];
    [formats addObject:@"docx"];
    
    // ppt
    [formats addObject:@"ppt"];
    [formats addObject:@"pptx"];
    
    // pdf
    [formats addObject:@"pdf"];
    
    // mp4
    [formats addObject:@"mp4"];
    [formats addObject:@"mov"];
    
    // png,jpg
    [formats addObject:@"png"];
    [formats addObject:@"jpg"];
    [formats addObject:@"jpeg"];
    
    return [NSArray arrayWithArray:formats];
}

+ (NSString *)uppercaseFileKindWithFileExtension:(NSString *)extension
{
    extension = [extension lowercaseString];
    if ([extension isEqualToString:@"xlsx"] || [extension isEqualToString:@"xls"])
    {
        return @"EXCEL";
    }
    else if ([extension isEqualToString:@"docx"] || [extension isEqualToString:@"doc"])
    {
        return @"WORD";
    }
    else if([extension isEqualToString:@"pptx"] || [extension isEqualToString:@"ppt"])
    {
        return @"PPT";
    }
    else if([extension isEqualToString:@"pdf"])
    {
        return @"PDF";
    }
    else if([extension isEqualToString:@"bin"])
    {
        return @"BIN";
    }
    else if([extension isEqualToString:@"png"] || [extension isEqualToString:@"jpg"] || [extension isEqualToString:@"jpeg"])
    {
        return @"ATLA";
    }
    else if ([extension isEqualToString:@"mp4"] || [extension isEqualToString:@"MP4"] || [extension isEqualToString:@"mov"] || [extension isEqualToString:@"MOV"])
    {
        return @"VIDEO";
    }
    else
    {
        return @"UNKNOWN";
    }
}

+ (NSString *)lowercaseFileKindWithFileExtension:(NSString *)extension
{
    extension = [extension lowercaseString];
    if ([extension isEqualToString:@"xlsx"] || [extension isEqualToString:@"xls"])
    {
        return @"excel";
    }
    else if ([extension isEqualToString:@"docx"] || [extension isEqualToString:@"doc"])
    {
        return @"word";
    }
    else if([extension isEqualToString:@"pptx"] || [extension isEqualToString:@"ppt"])
    {
        return @"ppt";
    }
    else if([extension isEqualToString:@"pdf"])
    {
        return @"pdf";
    }
    else if([extension isEqualToString:@"bin"])
    {
        return @"bin";
    }
    else if([extension isEqualToString:@"png"] || [extension isEqualToString:@"jpg"] || [extension isEqualToString:@"jpeg"])
    {
        return @"atla";
    }
    else if ([extension isEqualToString:@"mp4"] || [extension isEqualToString:@"MP4"] || [extension isEqualToString:@"mov"] || [extension isEqualToString:@"MOV"])
    {
        return @"video";
    }
    else
    {
        return @"unknown";
    }
}

+ (BOOL)isValidFileFormat:(NSString *)fileFormat
{
    for (NSString *format in [self validFileFormats])
    {
        fileFormat = [fileFormat lowercaseString];
        if ([fileFormat isEqualToString:format])
        {
            return YES;
        }
    }
    
    NSLog(@"不支持的文件类型");
    return NO;
}

+ (NSString *)kindClassWithFileExtension:(NSString *)extension
{
    extension = [extension lowercaseString];
    if ([extension isEqualToString:@"mp4"] || [extension isEqualToString:@"mov"])
    {
        return @"video";
    }
    else if([extension isEqualToString:@"png"] || [extension isEqualToString:@"jpg"] || [extension isEqualToString:@"jpeg"])
    {
        return @"atla";
    }
    else
    {
        return @"document";
    }
}

+ (NSString *)kindClassEncodingWithFileExtension:(NSString *)extension
{
    extension = [extension lowercaseString];
    if ([extension isEqualToString:@"mp4"] || [extension isEqualToString:@"mov"])
    {
        return @"视频";
    }
    else if([extension isEqualToString:@"png"] || [extension isEqualToString:@"jpg"] || [extension isEqualToString:@"jpeg"])
    {
        return @"图册";
    }
    else
    {
        return @"文档";
    }
}

+ (NSString *)kindClassEncodingWithFileUpExtension:(NSString *)upExtension
{
    if ([upExtension isEqualToString:@"VIDEO"])
    {
        return @"视频";
    }
    else if([upExtension isEqualToString:@"ATLA"])
    {
        return @"图册";
    }
    else
    {
        return @"文档";
    }
}

+ (NSString *)kindClassWithFileType:(YVLocalizedFileType)fileType
{
    if (fileType == YVLocalizedFileTypeVideo)
    {
        return @"video";
    }
    else  if (fileType == YVLocalizedFileTypeAtla)
    {
        return @"atla";
    }
    else
    {
        return @"document";
    }
}

+ (YVLocalizedFileType)fileTypeWithKindClass:(NSString *)kindClass
{
    kindClass = [kindClass lowercaseString];
    if ([kindClass isEqualToString:@"video"])
    {
        return YVLocalizedFileTypeVideo;
    }
    else  if ([kindClass isEqualToString:@"atla"])
    {
        return YVLocalizedFileTypeAtla;
    }
    else
    {
        return YVLocalizedFileTypeDocument;
    }
}

@end
