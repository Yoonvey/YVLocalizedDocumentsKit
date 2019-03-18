//
//  YVUploadingManager.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/3/12.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import "YVUploadingManager.h"

#import "YVValidFileFormatObject.h"
#import "YVRequestTool.h"

#import "AppDelegate.h"

@implementation YVUploadingManager

static YVUploadingManager *manager = nil;
static dispatch_once_t onceToken;

+(YVUploadingManager * _Nullable)shareManager
{
    dispatch_once(&onceToken, ^ {
        manager = [[YVUploadingManager alloc]init];
    });
    return manager;
}

+ (id)alloc
{
    if (manager == nil)
    {
        return [super alloc];
    }
    else
    {
        return nil;
    }
}

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

//- (NSMutableDictionary *)tasksObject
//{
//    if (!_tasksObject)
//    {
//        _tasksObject = [NSMutableDictionary dictionary];
//    }
//    return _tasksObject;
//}

- (YVUploadingFileGroupModel *)initlizedUploadingFileGroupModelWithGroupName:(NSString *)name
{
    YVUploadingFileGroupModel *model = [[YVUploadingFileGroupModel alloc] init];
    model.groupName = name;
    return model;
}

- (NSMutableArray<YVUploadingFileGroupModel *> *)tasksObjects
{
    if (!_tasksObjects)
    {
        _tasksObjects = [NSMutableArray array];
        [_tasksObjects addObject:[self initlizedUploadingFileGroupModelWithGroupName:@"文档"]];
        [_tasksObjects addObject:[self initlizedUploadingFileGroupModelWithGroupName:@"图册"]];
        [_tasksObjects addObject:[self initlizedUploadingFileGroupModelWithGroupName:@"视频"]];
    }
    return _tasksObjects;
}

- (NSInteger)sectionIndexWithGroupName:(NSString *)groupName
{
    if ([groupName isEqualToString:@"文档"])
    {
        return 0;
    }
    else if([groupName isEqualToString:@"图册"])
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (NSIndexPath *)indexPathWithUploadingFileModel:(YVUploadingFileModel *)uploadingFileModel
{
    
    NSString *kindClass = [YVValidFileFormatObject kindClassEncodingWithFileExtension:uploadingFileModel.fileExtension];
    
    // section
    NSInteger section = [self sectionIndexWithGroupName:kindClass];
    YVUploadingFileGroupModel *uploadingGroupModel = self.tasksObjects[section];
    
    int row = 0;
    for (YVUploadingFileModel *fileModel in uploadingGroupModel.fileModels)
    {
        if (fileModel == uploadingFileModel)
        {
            break;
        }
        row ++;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    return indexPath;
}

#pragma mark - <Add model>
- (void)addUploadingFile:(YVResultFileModel *)fileModel atGroup:(nonnull NSString *)groupName
{
    [self addUploadingFiles:@[fileModel] atGroup:groupName];
}

- (void)addUploadingFiles:(NSArray<YVResultFileModel *> *)fileModels atGroup:(nonnull NSString *)groupName
{
    NSString *kindClass = [YVValidFileFormatObject kindClassEncodingWithFileUpExtension:groupName];
    YVUploadingFileGroupModel *uploadingGroupModel = self.tasksObjects[[self sectionIndexWithGroupName:kindClass]];
    
    for (YVResultFileModel *fileModel in fileModels)
    {
        BOOL same = NO;
        for (YVUploadingFileModel *uploadingFileModel in uploadingGroupModel.fileModels)
        {
            if ([uploadingFileModel.fileName isEqualToString:fileModel.fileName])
            {
                same = YES;
            }
        }
        if (!same)
        {
            YVUploadingFileModel *uploadingModel = [[YVUploadingFileModel alloc] initWithResultFileModel:fileModel];
            [uploadingGroupModel.fileModels addObject:uploadingModel];
//            [self initRequest:uploadingModel];
        }
        else
        {
            NSLog(@"重复上传文件: %@", fileModel);
        }
    }
}

- (void)addUploadingFilesGroup:(NSMutableDictionary *)groupInfo
{
    for (NSString *groupName in [groupInfo allKeys])
    {
        [self addUploadingFiles:[groupInfo valueForKey:groupName] atGroup:groupName];
    }
}

#pragma mark - <Remove model>
- (void)removeUploadFileModel:(YVUploadingFileModel *)uploadingFileModel
{
    NSString *kindClass = [YVValidFileFormatObject kindClassEncodingWithFileExtension:uploadingFileModel.fileExtension];
    YVUploadingFileGroupModel *uploadingGroupModel = self.tasksObjects[[self sectionIndexWithGroupName:kindClass]];
    NSArray *fileModels = [NSArray arrayWithArray:uploadingGroupModel.fileModels];
    for (YVUploadingFileModel *model in fileModels)
    {
        if ([model.fileName isEqualToString:uploadingFileModel.fileName])
        {
            [uploadingGroupModel.fileModels removeObject:uploadingFileModel];
            if (self.uploadComplatedResponse)
            {
                self.uploadComplatedResponse();
            }
        }
    }
}

#pragma mark - <Control tasks>
- (void)startAllOfUploadingTasks
{
    for (YVUploadingFileGroupModel *uploadingGroupModel in self.tasksObjects)
    {
        for (YVUploadingFileModel *uploadingFileModel in uploadingGroupModel.fileModels)
        {
            [self initRequest:uploadingFileModel];
        }
    }
}

#pragma mark - <上传任务>
- (void)initRequest:(YVUploadingFileModel *)uploadingFileModel
{
    YVRequestTool *paramBody = [[YVRequestTool alloc] init];
    paramBody.filename = uploadingFileModel.fileName;
    paramBody.data = [NSData dataWithContentsOfFile:uploadingFileModel.filePath];
    paramBody.name = @"file";
    paramBody.mimeType = [self mimeTypeForFileAtPath:uploadingFileModel.filePath];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:uploadingFileModel.fileName forKey:@"title"];
    [parameter setValue:@"inCover" forKey:@"deviceType"];
    [parameter setValue:uploadingFileModel.fileDescription forKey:@"synopsis"];
    [parameter setValue:[[YVValidFileFormatObject kindClassWithFileExtension:uploadingFileModel.fileExtension] stringByReplacingOccurrencesOfString:@"atla" withString:@"picture"] forKey:@"documentType"];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    uploadingFileModel.task = [YVRequestTool uploadFileWithUrl:CommonUrl(AddFile, delegate.token) parameter:parameter uploadParam:paramBody executing:^(YVRequestTool * _Nonnull param, float progress) {
        uploadingFileModel.upload = uploadingFileModel.fileSize * progress;
        if ([YVUploadingManager shareManager].uploadingResponse)
        {
            if (progress >= 1.0)
            {
                [[YVUploadingManager shareManager] removeUploadFileModel:uploadingFileModel];
            }
            [YVUploadingManager shareManager].uploadingResponse(uploadingFileModel, progress);
        }
    } completion:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, id  _Nonnull responseObject) {
        if (!error)// 成功
        {
//            [[YVUploadingManager shareManager] removeUploadFileModel:uploadingFileModel];
//            if ([YVUploadingManager shareManager].uploadComplatedResponse)
//            {
//                [YVUploadingManager shareManager].uploadComplatedResponse([manager indexPathWithUploadingFileModel:uploadingFileModel]);
//            }
        }
    }];
}


// 调用C语言API
- (NSString *)mimeTypeForFileAtPath:(NSString *)path
{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path])
    {
        return nil;
    }
    
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType)
    {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType);
}

@end
