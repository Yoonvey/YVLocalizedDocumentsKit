//
//  YVUploadingAtlaCell.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/3/11.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import "YVUploadingAtlaCell.h"

@implementation YVUploadingAtlaCell

- (void)setContentModel:(YVUploadingFileModel *)contentModel
{
    self.logo.image = [UIImage imageWithContentsOfFile:contentModel.filePath];
    self.name.text = contentModel.fileName;
    self.totalSize.text = [YVFileHelper sizeExplain:contentModel.fileSize];
    self.progressView.progress = (double)contentModel.upload/contentModel.fileSize;
    
    if (contentModel.task.state == NSURLSessionTaskStateSuspended)
    {
        self.progressView.progressTintColor = [UIColor colorWithRed:176.0/255 green:176.0/255 blue:176.0/255 alpha:1.0];
        self.uploadSize.text = @"已暂停";
        self.uploadSize.textColor = [UIColor redColor];
        self.uploadVariable.text = @"";
    }
    else
    {
        self.progressView.progressTintColor = [UIColor colorWithRed:68.0/255 green:186.0/255 blue:255.0/255 alpha:1.0];
        self.uploadSize.text = [YVFileHelper sizeExplain:contentModel.upload];
        self.uploadSize.textColor = [UIColor grayColor];
        self.uploadVariable.text = [NSString stringWithFormat:@"+%@/s", [YVFileHelper sizeExplain:contentModel.uploadVariable]];
    }
}

@end
