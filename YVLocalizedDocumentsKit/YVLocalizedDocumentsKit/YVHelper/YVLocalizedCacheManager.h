//
//  YVLocalizedCacheManager.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/13.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YVValidFileFormatObject.h"

#import "YVResultFileModel.h"
#import "YVResultFileGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YVLocalizedCacheManagerDelegate <NSObject>

@optional
/*!
 * @brief 存储文件成功后返回文件分类信息
 */
- (void)didAddedLocalizedCacheWithFileType:(YVLocalizedFileType)fileType;

@end

@interface YVLocalizedCacheManager : NSObject

+ (YVLocalizedCacheManager * _Nullable)shareManager;

@property (nonatomic, weak) id<YVLocalizedCacheManagerDelegate> delegate;

#pragma mark - <文件缓存和获取>
/*!
 * @brief 文件进行本地存储
 * @param fileData 文件二进制
 * @param fileName 文件名称(包含后缀名)
 */
- (void)addLocalizedCacheWithFileData:(NSData * _Nonnull)fileData
                             fileName:(NSString * _Nonnull)fileName;

/*!
 * @brief 根据文件类型获取本地存储的文件信息
 * @param fileType 文件类型
 * @return 文件数据模型集合
 */
- (NSArray<YVResultFileModel *> *)getFileModelsWithFileType:(YVLocalizedFileType)fileType;

/*!
 * @brief 根据文件类型获取本地存储的文件信息并返回分组集合(废弃)
 * @param fileType 文件类型
 * @return 文件数据模型分组集合
 */
- (NSArray<YVResultFileGroupModel *> *)getFileModelsGroupWithFileType:(YVLocalizedFileType)fileType;

/*!
 * @brief 根据文件类型和对比数据获取本地存储的文件信息并返回分组集合
 * @param fileType 文件类型
 * @param contrastGroup 对比分组(用于实时更新文件缓存信息的同时能够保持用户本地之前操作的状态信息)
 * @return 文件数据模型分组集合
 */
- (NSArray<YVResultFileGroupModel *> *)getFileModelsGroupWithFileType:(YVLocalizedFileType)fileType
                                                  contrastModelsGroup:(NSArray<YVResultFileGroupModel *> *)contrastGroup;

#pragma mark - <文件清理>
/*！
 * @brief 根据文件名称清除本地文件和缓存信息
 * @param fileName 文件名称(包含后缀名)
 * @return 执行结果
 */
- (BOOL)deleteLocalizedCacheFile:(NSString *)fileName;

/*！
 * @brief 根据文件名称集合清除本地文件和缓存信息
 * @param fileNames 文件名称集合(包含后缀名)
 */
- (void)deleteLocalizedCacheFiles:(NSArray<NSString *> *)fileNames;

@end

NS_ASSUME_NONNULL_END
