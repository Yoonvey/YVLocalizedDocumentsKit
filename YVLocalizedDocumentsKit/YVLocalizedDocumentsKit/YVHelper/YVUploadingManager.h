//
//  YVUploadingManager.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/3/12.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YVResultFileModel.h"
#import "YVResultFileGroupModel.h"
#import "YVUploadingFileModel.h"
#import "YVUploadingFileGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YVUploadingManager : NSObject

+ (YVUploadingManager * _Nullable)shareManager;

@property (nonatomic, strong) NSMutableArray<YVUploadingFileGroupModel *> *tasksObjects;
@property (nonatomic, copy) void(^uploadingResponse)(YVUploadingFileModel *targetObject, CGFloat progress);// 上传回调
@property (nonatomic, copy) void(^uploadComplatedResponse)(void);// 所有文件上传完成响应回调

- (void)addUploadingFile:(YVResultFileModel *)fileModel atGroup:(NSString *)groupName;
- (void)addUploadingFiles:(NSArray<YVResultFileModel *> *)fileModels atGroup:(NSString *)groupName;
- (void)addUploadingFilesGroup:(NSMutableDictionary *)groupInfo;

/// Tasks control
- (void)startAllOfUploadingTasks;
- (void)pauseAllOfUpalodingTasks;
- (void)cancelAllOfUploadingTasks;

@end

NS_ASSUME_NONNULL_END
