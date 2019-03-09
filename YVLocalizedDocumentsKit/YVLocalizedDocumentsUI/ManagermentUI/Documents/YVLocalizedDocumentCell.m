//
//  YVLocalizedDocumentCell.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/14.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "YVLocalizedDocumentCell.h"

@implementation YVLocalizedDocumentCell

- (void)setContentModel:(YVResultFileModel *)contentModel
{
    self.select.selected = contentModel.isSelected;
    [self.playButton setImage:[UIImage imageNamed:Bundle_Name(@"chechFileSmall")] forState:UIControlStateNormal];
    self.playButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 7, 7);
    
    UIImage *cover = [UIImage imageNamed:Bundle_Name(contentModel.fileExtension)];
    if (!cover)//适应某些文档类型的老版本
    {
        NSString *extension = [NSString stringWithFormat:@"%@x", contentModel.fileExtension];
        cover = [UIImage imageNamed:Bundle_Name(extension)];
    }
    self.cover.image = cover;
    
    self.fileName.text = contentModel.fileName;
    self.fileSize.text = [YVFileHelper sizeExplain:contentModel.fileSize];
    self.createTime.text = contentModel.createTime;
}

@end
