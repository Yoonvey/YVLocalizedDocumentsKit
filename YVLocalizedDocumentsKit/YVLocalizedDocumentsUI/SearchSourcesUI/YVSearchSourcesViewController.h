//
//  YVSearchSourcesViewController.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/3/18.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import "UIBaseViewController.h"

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface YVSearchSourcesViewController : UIBaseViewController

@property (nonatomic) PHAssetMediaType mediaType;
@property (nonatomic, copy) void(^didEndEdit)(void);

@end

NS_ASSUME_NONNULL_END
