//
//  YVLocalizedAtlaCell.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/17.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIBaseHeader.h"
#import "YVLocalizedCacheManager.h"

#define ItemWidth ([UIScreen mainScreen].bounds.size.width - 25)/4
#define ItemHeight ItemWidth

NS_ASSUME_NONNULL_BEGIN

@interface YVLocalizedAtlaCell : UICollectionViewCell

- (void)setContentModel:(YVResultFileModel *)contentModel;

@end

NS_ASSUME_NONNULL_END
