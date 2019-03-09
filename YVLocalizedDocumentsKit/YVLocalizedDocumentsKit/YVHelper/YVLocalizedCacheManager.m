//
//  YVLocalizedCacheManager.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/13.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "YVLocalizedCacheManager.h"

#import "YVFileModel.h"
#import "YVFileHelper.h"

@interface YVLocalizedCacheManager ()

@property (nonatomic, strong) NSMutableArray<NSString *> *additions;

@end

@implementation YVLocalizedCacheManager

#pragma makr - <创建单例>
static YVLocalizedCacheManager *manager = nil;
static dispatch_once_t onceToken;

+(YVLocalizedCacheManager * _Nullable)shareManager
{
    dispatch_once(&onceToken, ^ {
        manager = [[YVLocalizedCacheManager alloc]init];
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

- (NSMutableArray<NSString *> *)additions
{
    if (!_additions)
    {
        _additions = [NSMutableArray array];
    }
    return _additions;
}

#pragma mark - <文件存取逻辑>
/// 存储文件
- (void)addLocalizedCacheWithFileData:(NSData *)fileData fileName:(NSString *)fileName
{
    if (![YVValidFileFormatObject isValidFileFormat:[fileName pathExtension]]) return;// 不支持的文件
    
    // 缓存文件
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];
    
    // 移除旧的相同缓存
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [self deleteLocalizedCacheFile:fileName];
    }
    
    // 写入新的文件
    BOOL writeResult = [fileData writeToFile:filePath atomically:YES];
    
    // 存储成功
    if (writeResult)
    {
        YVFileModel *fileModel = [[YVFileModel alloc] init];
        fileModel.fileName = fileName;
        fileModel.fileExtension = [fileName pathExtension];
        fileModel.fileSize = [self getSizeWithFilePath:filePath];
        fileModel.createTime = [YVFileHelper getDateStringForTodayWithDateFormat:@"yyyy-MM-dd"];
        [self setFileModelToUserDefaults:fileModel];
        
        [self.additions addObject:filePath];
        
        if (_delegate && [_delegate respondsToSelector:@selector(didAddedLocalizedCacheWithFileType:)])
        {
            [_delegate didAddedLocalizedCacheWithFileType:[YVValidFileFormatObject fileTypeWithKindClass:[YVValidFileFormatObject kindClassWithFileExtension:[fileName pathExtension]]]];
        }
    }
}

/// 将文件数据模型存储到本地缓存
- (void)setFileModelToUserDefaults:(YVFileModel *)fileModel
{
    // 打开NSUserDefaults存储的缓存
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 获取用户缓存
    NSMutableDictionary *userCache = [NSMutableDictionary dictionaryWithDictionary:[userDefaults valueForKey:@"userCache"]];
    // 获取文件所属分类
    NSString *kindClass = [YVValidFileFormatObject kindClassWithFileExtension:fileModel.fileExtension];
    NSMutableArray *files = [NSMutableArray arrayWithArray:[userCache valueForKey:kindClass]];
    // 数据模型归档保存
    NSError *error = nil;
    NSData *fileData = [NSKeyedArchiver archivedDataWithRootObject:fileModel requiringSecureCoding:YES error:&error];
    NSLog(@"%@",error);
    [files addObject:fileData];
    // 添加新的缓存
    [userCache setValue:files forKey:kindClass];
    [userDefaults setValue:userCache forKey:@"userCache"];
    // 关闭缓存
    [userDefaults synchronize];
}

/// 从本地缓存中取出一种文件集合
- (NSArray<YVResultFileModel *> *)getFileModelsWithFileType:(YVLocalizedFileType)fileType
{
    // 打开NSUserDefaults存储的缓存
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 获取用户缓存
    NSMutableDictionary *userCache = [NSMutableDictionary dictionaryWithDictionary:[userDefaults valueForKey:@"userCache"]];
    // 获取文件所属分类
    NSString *kindClass = [YVValidFileFormatObject kindClassWithFileType:fileType];
    NSMutableArray *files = [NSMutableArray arrayWithArray:[userCache valueForKey:kindClass]];
    // 反序列输出数据模型集合
    NSMutableArray<YVResultFileModel *> *fileModels = [NSMutableArray array];
    for (NSData *fileData in files)
    {
        YVFileModel *fileModel = [NSKeyedUnarchiver unarchivedObjectOfClass:YVFileModel.class fromData:fileData error:nil];
        
        YVResultFileModel *resultModel = [[YVResultFileModel alloc] init];
        resultModel.filePath = [self getFilePathWithFileName:fileModel.fileName];
        resultModel.fileName = fileModel.fileName;
        resultModel.fileExtension = fileModel.fileExtension;
        resultModel.fileSize = fileModel.fileSize;
        resultModel.createTime = fileModel.createTime;
        
        // 视频获取封面
        if (fileType == YVLocalizedFileTypeVideo)
        {
            resultModel.cover = [YVFileHelper getImageWithVideoPath:resultModel.filePath];
        }
        
        [fileModels addObject:resultModel];
    }
    
    // 关闭缓存
    [userDefaults synchronize];
    
    return fileModels;
}

/// 根据文件类型获取本地存储的文件信息并返回分组集合
- (NSArray<YVResultFileGroupModel *> *)getFileModelsGroupWithFileType:(YVLocalizedFileType)fileType
{
    NSArray *groupTitles = [NSMutableArray arrayWithObjects:@"WORD", @"EXCEL", @"PPT", @"PDF", @"ATLA", @"VIDEO", nil];
    
    NSMutableDictionary *groupModelsInfo = [NSMutableDictionary dictionary];
    // WORD
    YVResultFileGroupModel *wordGroupModel = [[YVResultFileGroupModel alloc] init];
    wordGroupModel.groupName = @"WORD";
    [groupModelsInfo setObject:wordGroupModel forKey:@"WORD"];
    
    //EXCEL
    YVResultFileGroupModel *excelGroupModel = [[YVResultFileGroupModel alloc] init];
    excelGroupModel.groupName = @"EXCEL";
    [groupModelsInfo setObject:excelGroupModel forKey:@"EXCEL"];
    
    //PPT
    YVResultFileGroupModel *pptGroupModel = [[YVResultFileGroupModel alloc] init];
    pptGroupModel.groupName = @"PPT";
    [groupModelsInfo setObject:pptGroupModel forKey:@"PPT"];
    
    //PDF
    YVResultFileGroupModel *pdfGroupModel = [[YVResultFileGroupModel alloc] init];
    pdfGroupModel.groupName = @"PDF";
    [groupModelsInfo setObject:pdfGroupModel forKey:@"PDF"];
    
    //ATLA
    YVResultFileGroupModel *atlaGroupModel = [[YVResultFileGroupModel alloc] init];
    atlaGroupModel.groupName = @"ATLA";
    [groupModelsInfo setObject:atlaGroupModel forKey:@"ATLA"];
    
    //VIDEO
    YVResultFileGroupModel *videoGroupModel = [[YVResultFileGroupModel alloc] init];
    videoGroupModel.groupName = @"VIDEO";
    [groupModelsInfo setObject:videoGroupModel forKey:@"VIDEO"];
    
    // 遍历q获取数据并进行分组
    NSArray *fileModels = [self getFileModelsWithFileType:fileType];
    for (YVResultFileModel *fileModel in fileModels)
    {
        for (NSString *froupTitle in groupTitles)
        {
            if ([[YVValidFileFormatObject uppercaseFileKindWithFileExtension:fileModel.fileExtension] isEqualToString:froupTitle])
            {
                YVResultFileGroupModel *groupModel = [groupModelsInfo objectForKey:froupTitle];
                [groupModel.fileModels addObject:fileModel];
            }
        }
    }
    
    // 添加非空的数据
    NSMutableArray<YVResultFileGroupModel *> *groupModels = [NSMutableArray array];
    
    int i = 0;
    for (NSString *title in groupTitles)
    {
        YVResultFileGroupModel *groupModel = [groupModelsInfo objectForKey:title];
        if (groupModel.fileModels.count != 0)
        {
            groupModel.isExtend = (i == 0) ? YES : groupModel.isExtend;
            [groupModels addObject:groupModel];
        }
        i ++;
    }
    
    return groupModels;
}

/// 根据文件类型获取本地存储的文件信息并返回分组集合
- (NSArray<YVResultFileGroupModel *> *)getFileModelsGroupWithFileType:(YVLocalizedFileType)fileType contrastModelsGroup:(nonnull NSArray<YVResultFileGroupModel *> *)contrastGroup
{
    NSArray *groupTitles = [NSMutableArray arrayWithObjects:@"WORD", @"EXCEL", @"PPT", @"PDF", @"ATLA", @"VIDEO", nil];
    
    NSMutableDictionary *groupModelsInfo = [NSMutableDictionary dictionary];
    // WORD
    YVResultFileGroupModel *wordGroupModel = [[YVResultFileGroupModel alloc] init];
    wordGroupModel.groupName = @"WORD";
    [groupModelsInfo setObject:wordGroupModel forKey:@"WORD"];
    
    //EXCEL
    YVResultFileGroupModel *excelGroupModel = [[YVResultFileGroupModel alloc] init];
    excelGroupModel.groupName = @"EXCEL";
    [groupModelsInfo setObject:excelGroupModel forKey:@"EXCEL"];
    
    //PPT
    YVResultFileGroupModel *pptGroupModel = [[YVResultFileGroupModel alloc] init];
    pptGroupModel.groupName = @"PPT";
    [groupModelsInfo setObject:pptGroupModel forKey:@"PPT"];
    
    //PDF
    YVResultFileGroupModel *pdfGroupModel = [[YVResultFileGroupModel alloc] init];
    pdfGroupModel.groupName = @"PDF";
    [groupModelsInfo setObject:pdfGroupModel forKey:@"PDF"];
    
    //ATLA
    YVResultFileGroupModel *atlaGroupModel = [[YVResultFileGroupModel alloc] init];
    atlaGroupModel.groupName = @"ATLA";
    [groupModelsInfo setObject:atlaGroupModel forKey:@"ATLA"];
    
    //VIDEO
    YVResultFileGroupModel *videoGroupModel = [[YVResultFileGroupModel alloc] init];
    videoGroupModel.groupName = @"VIDEO";
    [groupModelsInfo setObject:videoGroupModel forKey:@"VIDEO"];
    
    // 遍历q获取数据并进行分组
    NSArray *fileModels = [self getFileModelsWithFileType:fileType];
    for (YVResultFileModel *fileModel in fileModels)
    {
        for (NSString *groupTitle in groupTitles)
        {
            // 遍历对比数据
            BOOL isExtend = NO;
            for (YVResultFileGroupModel *groupModel in contrastGroup)
            {
                if([groupModel.groupName isEqualToString:groupTitle])
                {
                    isExtend = groupModel.isExtend;
                    for (YVResultFileModel *tFileModel in groupModel.fileModels)
                    {
                        if ([fileModel.fileName isEqualToString:tFileModel.fileName])
                        {
                            fileModel.isSelected = tFileModel.isSelected;
                        }
                    }
                    break;
                }
            }
        
            if ([[YVValidFileFormatObject uppercaseFileKindWithFileExtension:fileModel.fileExtension] isEqualToString:groupTitle])
            {
                // 判断当前文件是否未查看
                NSArray *additionPaths = [NSArray arrayWithArray:self.additions];
                int i = 0;
                for (NSString *additionPath in additionPaths)
                {
                    if ([fileModel.filePath isEqualToString:additionPath])
                    {
                        [self.additions removeObjectAtIndex:i];
                        isExtend = YES;
                        break;
                    }
                    i++;
                }
                
                // 添加分组
                YVResultFileGroupModel *groupModel = [groupModelsInfo objectForKey:groupTitle];
                groupModel.isExtend = isExtend;
                [groupModel.fileModels addObject:fileModel];
            }
        }
    }
    
    // 添加非空的数据
    NSMutableArray<YVResultFileGroupModel *> *groupModels = [NSMutableArray array];
    int i = 0;
    for (NSString *title in groupTitles)
    {
        YVResultFileGroupModel *groupModel = [groupModelsInfo objectForKey:title];
        if (groupModel.fileModels.count != 0)
        {
            groupModel.isExtend = (i == 0) ? YES : groupModel.isExtend;
            [groupModels addObject:groupModel];
            i ++;
        }
    }
    
    return groupModels;
}

/// 根据文件名称清除缓存文件
- (BOOL)deleteLocalizedCacheFile:(NSString *)fileName
{
    NSString *filePath = [self getFilePathWithFileName:fileName];
    
    // 清除文件
    BOOL removeResult = NO;
    NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        removeResult = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }
    
    if (removeResult)
    {
        [self removeFileModel:fileName];
    }
    else
    {
        NSLog(@"文件%@删除失败  ,错误: %@", fileName, error);
    }
    
    return removeResult;
}

/// 从本地缓存中清除文件缓存数据模型(单一文件清除)
- (void)removeFileModel:(NSString *)fileName
{
    // 打开NSUserDefaults存储的缓存
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 获取用户缓存
    NSMutableDictionary *userCache = [NSMutableDictionary dictionaryWithDictionary:[userDefaults valueForKey:@"userCache"]];
    // 获取文件所属分类
    NSString *kindClass = [YVValidFileFormatObject kindClassWithFileExtension:[fileName pathExtension]];
    // 反序列输出数据模型集合
    NSMutableArray *files = [NSMutableArray arrayWithArray:[userCache valueForKey:kindClass]];
    
    // 遍历数据删除数据
    NSMutableArray *cFiles = [NSMutableArray arrayWithArray:files];
    int i = 0;
    for (NSData *fileData in cFiles)
    {
        YVFileModel *fileModel = [NSKeyedUnarchiver unarchivedObjectOfClass:YVFileModel.class fromData:fileData error:nil];
        if ([fileModel.fileName isEqualToString:fileName])
        {
            [files removeObjectAtIndex:i];
            break;
        }
        i ++;
    }
    
    // 更新缓存
    [userCache setValue:files forKey:kindClass];
    [userDefaults setValue:userCache forKey:@"userCache"];
    // 关闭缓存
    [userDefaults synchronize];
}

/// 根据文件名称集合清除本地文件和缓存信息
- (void)deleteLocalizedCacheFiles:(NSArray<NSString *> *)fileNames
{
    if (fileNames.count == 0)
    {
        return ;
    }
    // 打开NSUserDefaults存储的缓存
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 获取用户缓存
    NSMutableDictionary *userCache = [NSMutableDictionary dictionaryWithDictionary:[userDefaults valueForKey:@"userCache"]];
    
    NSMutableArray *documents = nil;
    NSMutableArray *atlas = nil;
    NSMutableArray *videos = nil;
    
    for (NSString *fileName in fileNames)
    {
        // 获取文件所属分类
        NSString *kindClass = [YVValidFileFormatObject kindClassWithFileExtension:[fileName pathExtension]];
        NSMutableArray *removeFiles = nil;
        if ([kindClass isEqualToString:@"atla"])//图片
        {
            atlas = !atlas ? [NSMutableArray arrayWithArray:[userCache valueForKey:kindClass]] : atlas ;
            removeFiles = atlas;
        }
        else if([kindClass isEqualToString:@"video"])// 视频
        {
            videos = !videos ? [NSMutableArray arrayWithArray:[userCache valueForKey:kindClass]] : videos ;
            removeFiles = videos;
        }
        else// 文档
        {
            documents = !documents ? [NSMutableArray arrayWithArray:[userCache valueForKey:kindClass]] : documents ;
            removeFiles = documents;
        }
        
        // 拼接文件地址
        NSString *filePath = [self getFilePathWithFileName:fileName];
        
        // 删除文件资源
        BOOL removeResult = NO;
        NSError *error = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            removeResult = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        }
        
        if (removeResult)
        {
            // 移除文件存储信息
            [self removeFile:fileName fromFiles:removeFiles];
        }
        else
        {
            NSLog(@"文件%@删除失败 ,错误: %@", fileName, error);
        }
    }
    
    // 更新缓存
    if (atlas)
    {
        [userCache setValue:atlas forKey:@"atla"];
    }
    if (videos)
    {
        [userCache setValue:videos forKey:@"video"];
    }
    if (documents)
    {
        [userCache setValue:documents forKey:@"document"];
    }
    [userDefaults setValue:userCache forKey:@"userCache"];
    
    // 关闭缓存
    [userDefaults synchronize];
}

/// 从本地缓存中清除文件缓存数据模型(多文件清除时，清除执行完成后才关闭NSUserDefaultds以y提高效率)
- (void)removeFile:(NSString *)fileName fromFiles:(NSMutableArray *)files
{
    // 遍历数据删除数据
    NSMutableArray *cFiles = [NSMutableArray arrayWithArray:files];
    int i = 0;
    for (NSData *fileData in cFiles)
    {
        YVFileModel *fileModel = [NSKeyedUnarchiver unarchivedObjectOfClass:YVFileModel.class fromData:fileData error:nil];
        if ([fileModel.fileName isEqualToString:fileName])
        {
            [files removeObjectAtIndex:i];
            break;
        }
        i ++;
    }
}

/// 根据文件名获取文件存储路径
- (NSString *)getFilePathWithFileName:(NSString *)fileName
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];
    return filePath;
}

/// 获取文件大小
- (float)getSizeWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath])
    {
        long long size = [fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
        return size;
    }
    return 0;
}


@end
