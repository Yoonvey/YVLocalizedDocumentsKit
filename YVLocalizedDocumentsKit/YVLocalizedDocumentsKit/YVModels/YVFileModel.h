//
//  YVFileModel.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/13.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YVFileModel : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileExtension;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic) float fileSize;// MB

@end

NS_ASSUME_NONNULL_END
