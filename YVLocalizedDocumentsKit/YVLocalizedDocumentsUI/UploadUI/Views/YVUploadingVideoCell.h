//
//  YVUploadingVideoCell.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/3/11.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import "YVUploadingDocumentCell.h"

#import "UIBaseHeader.h"
#import "YVFileHelper.h"

#import "YVUploadingFileModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YVUploadingVideoCell : UITableViewCell

@property (nonatomic, strong) UIImageView *logo;// 图标
@property (nonatomic, strong) UILabel *name;// 名称

@property (nonatomic, strong) UILabel *uploadSize;// 已上传大小
@property (nonatomic, strong) UILabel *uploadVariable;// 上传增量(上传速度)
@property (nonatomic, strong) UILabel *totalSize;// 总大小

@property (nonatomic, strong) UIProgressView *progressView;// 进度

- (void)setContentModel:(YVUploadingFileModel *)contentModel;

@end

NS_ASSUME_NONNULL_END
