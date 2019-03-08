//
//  YVResultFileGroupModel.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/15.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "YVResultFileGroupModel.h"

@implementation YVResultFileGroupModel

- (NSMutableArray<YVResultFileModel *> *)fileModels
{
    if (!_fileModels)
    {
        _fileModels = [NSMutableArray array];
    }
    return _fileModels;
}

@end
