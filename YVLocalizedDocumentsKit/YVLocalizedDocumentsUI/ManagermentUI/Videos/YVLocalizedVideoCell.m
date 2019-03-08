//
//  YVLocalizedVideoCell.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/2/16.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import "YVLocalizedVideoCell.h"

@implementation YVLocalizedVideoCell

- (void)setContentModel:(YVResultFileModel *)contentModel
{
    self.select.selected = contentModel.isSelected;
    [self.playButton setImage:[UIImage imageNamed:Bundle_Name(@"playVideoSmall")] forState:UIControlStateNormal];
    
    self.cover.image = contentModel.cover;
    self.fileName.text = contentModel.fileName;
    self.createTime.text = contentModel.createTime;
    self.fileSize.text = [YVFileHelper sizeExplain:contentModel.fileSize];
}


@end
