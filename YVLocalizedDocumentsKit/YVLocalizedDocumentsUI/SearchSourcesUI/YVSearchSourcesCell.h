//
//  YVSearchSourcesCell.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/3/18.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIBaseHeader.h"

#import "YVResultFileModel.h"

#define ItemWidth (ScreenWidth - 8.0)*0.5
#define ItemHeight ItemWidth

NS_ASSUME_NONNULL_BEGIN

@interface YVSearchSourcesCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *playButton;

- (void)setContentModel:(YVResultFileModel *)contentModel
         selectedStatus:(NSString *)status;

@end

NS_ASSUME_NONNULL_END
