//
//  YVUploadingFileGroupModel.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/3/12.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YVUploadingFileModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YVUploadingFileGroupModel : NSObject

@property (nonatomic, copy) NSString *groupName;
@property (nonatomic) NSInteger uploadingCount; 
@property (nonatomic, strong) NSMutableArray<YVUploadingFileModel *> *fileModels;

@end

NS_ASSUME_NONNULL_END
