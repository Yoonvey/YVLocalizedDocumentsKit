//
//  YVUploadingFileGroupModel.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/3/12.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import "YVUploadingFileGroupModel.h"

@implementation YVUploadingFileGroupModel

- (NSMutableArray<YVUploadingFileModel *> *)fileModels
{
    if (!_fileModels)
    {
        _fileModels = [NSMutableArray array];
    }
    return _fileModels;
}

@end
