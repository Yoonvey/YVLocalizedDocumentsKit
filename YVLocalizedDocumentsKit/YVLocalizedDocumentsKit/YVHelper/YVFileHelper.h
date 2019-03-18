//
//  YVFileHelper.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/14.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YVFileHelper : NSObject

/*!
 * @brief 获取视频封面
 * @param videoPath 视频文件本地存储的路径
 * @return 视频封面图片
 */
+ (UIImage *)getImageWithVideoPath:(NSString *)videoPath;

/*!
 * @brief 获取视频时长
 * @param videoPath 视频文件本地存储的路径
 * @return 视频时长
 */
+ (double)getDurationWithViedeoPath:(NSString *)videoPath;

/*!
 * @brief 根据字节长度转换合适的单位
 * @param size 字节长度大小
 * @return 合适的大小单位
 */
+ (NSString *)sizeExplain:(float)size;

/*!
 * @breif 获取今日的日期并返回字符串
 * @param dateFormart 时间字符串格式
 * @return 返回时间格式字符串
 */
+ (NSString *)getDateStringForTodayWithDateFormat:(NSString *)dateFormart;

/*!
 * @breif 时间转换方法(秒-->时:分:秒)
 * @param times 时间(秒)
 * @return 返回时间格式字符串(当times>=3600时,会返回时:分:秒,否则为分:秒)
 */
+ (NSString *)conversionTimeWithSecond:(NSInteger)times;

@end

NS_ASSUME_NONNULL_END
