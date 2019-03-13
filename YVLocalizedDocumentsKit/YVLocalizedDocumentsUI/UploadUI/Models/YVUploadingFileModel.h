//
//  YVUploadingFileModel.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/3/11.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "YVResultFileModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YVUploadingFileModel : YVResultFileModel

@property (nonatomic) float upload;// 当前已上传大小B
@property (nonatomic) float uploadVariable;// 瞬间上传大小(上传变量)
//@property (nonatomic) YVUploadingState uploadStatus;// 当前上传状态
@property (nonatomic, strong) NSURLSessionDataTask *task;

- (instancetype)initWithResultFileModel:(YVResultFileModel *)resultFileModel;

@end

NS_ASSUME_NONNULL_END
