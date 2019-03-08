//
//  YVFileModel.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/13.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "YVFileModel.h"

@implementation YVFileModel

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.fileName forKey:@"fileName"];
    [coder encodeObject:self.fileExtension forKey:@"fileExtension"];
    [coder encodeFloat:self.fileSize forKey:@"fileSize"];
    [coder encodeObject:self.createTime forKey:@"createTime"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.fileName = [coder decodeObjectForKey:@"fileName"];
        self.fileExtension = [coder decodeObjectForKey:@"fileExtension"];
        self.fileSize = [coder decodeFloatForKey:@"fileSize"];
        self.createTime = [coder decodeObjectForKey:@"createTime"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding
{
    return true;
}

@end
