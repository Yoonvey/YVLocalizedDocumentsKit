//
//  YVUploadingFileModel.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/3/11.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import "YVUploadingFileModel.h"

@implementation YVUploadingFileModel

- (instancetype)initWithResultFileModel:(YVResultFileModel *)resultFileModel
{
    self = [super init];
    if (self)
    {
        self.filePath = resultFileModel.filePath;// 文件存储路径
        self.fileName = resultFileModel.fileName;// 文件名称
        self.fileExtension = resultFileModel.fileExtension;// 文件格式(后缀)
        self.fileDescription = resultFileModel.fileDescription;// 文件描述
        
        self.fileSize = resultFileModel.fileSize;// B
        self.createTime = resultFileModel.createTime;
        
        self.cover = resultFileModel.cover;// 封面图
        
        self.isNew = resultFileModel.isNew; //
        self.isSelected = resultFileModel.isSelected; //选中状态
    }
    return self;
}

@end
