//
//  YVResultFileModel.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/13.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YVResultFileModel : NSObject

@property (nonatomic, copy) NSURL *localizedUrl;// 文件本地url
@property (nonatomic, strong) NSData *fileData;// 文件内容(当文件进行另外的缓存的时候,这个键将为nil)
@property (nonatomic, copy) NSString *filePath;// 文件存储路径
@property (nonatomic, copy) NSString *fileName;// 文件名称
@property (nonatomic, copy) NSString *fileExtension;// 文件格式(后缀)
@property (nonatomic, copy) NSString *fileDescription;// 文件描述

@property (nonatomic) float fileSize;// B
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, strong) UIImage *cover;// 封面图
@property (nonatomic) double duration;// 时长

@property (nonatomic) BOOL isNew; //
@property (nonatomic) BOOL isSelected; //选中状态

@end

NS_ASSUME_NONNULL_END
