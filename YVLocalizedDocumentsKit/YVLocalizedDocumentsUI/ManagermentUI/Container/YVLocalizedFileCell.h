//
//  YVLocalizedFileCell.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/2/16.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIBaseHeader.h"
#import "YVFileHelper.h"
#import "YVLocalizedCacheManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YVLocalizedFileCell : UITableViewCell

@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) UILabel *fileName;
@property (nonatomic, strong) UILabel *createTime;
@property (nonatomic, strong) UILabel *fileSize;
@property (nonatomic, strong) UIButton *select;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *checkButton;

- (void)setContentModel:(YVResultFileModel *)contentModel;
- (void)updateConstraintsWithUserControlStatus:(UserEditStatus)status;

@end

NS_ASSUME_NONNULL_END
