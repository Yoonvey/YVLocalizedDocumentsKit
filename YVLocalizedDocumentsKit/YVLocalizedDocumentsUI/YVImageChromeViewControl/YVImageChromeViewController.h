//
//  YVImageChromeViewController.h
//  MDSmartHouseHoldLock
//
//  Created by Yoonvey on 2018/8/9.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "UIBaseViewController.h"

@interface YVImageChromeViewController : UIBaseViewController

@property (nonatomic) NSInteger itemTag;//一定要在imageModels之前设置!!!
@property (nonatomic) BOOL deleteEnabled;
@property (nonatomic, strong) NSMutableArray<NSString *> *imagePaths;//图片路径
@property (nonatomic, strong) NSMutableArray *imageModels;//图片数据模型

@property (nonatomic, copy) void(^deleteCallBack)(NSString *imageName, id imageModel);

@end
