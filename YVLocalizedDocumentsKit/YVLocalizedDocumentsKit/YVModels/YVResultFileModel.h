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

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileExtension;
@property (nonatomic, copy) NSString *fileDescription;

@property (nonatomic) float fileSize;// B
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, strong) UIImage *cover;// 封面图

@property (nonatomic) BOOL isSelected; //选中状态

@end

NS_ASSUME_NONNULL_END
