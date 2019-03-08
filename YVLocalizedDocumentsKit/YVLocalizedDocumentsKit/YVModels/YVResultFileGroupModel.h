//
//  YVResultFileGroupModel.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/15.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YVResultFileModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YVResultFileGroupModel : NSObject

@property (nonatomic, copy) NSString *groupName;
@property (nonatomic) BOOL isExtend; //分组展开状态
@property (nonatomic, strong) NSMutableArray<YVResultFileModel *> *fileModels;

@end

NS_ASSUME_NONNULL_END
