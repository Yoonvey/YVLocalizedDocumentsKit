//
//  YVLocalizedFilesBaseViewController.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/2/28.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIBaseHeader.h"
#import "YVLocalizedCacheManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    SelectedStatusNone = 0,
    SelectedStatusAll
} SelectedStatus;


@protocol YVLocalizedFileManagementDelegate <NSObject>

@optional

- (void)shouldUpdateFileCount:(NSInteger)selectedCount
                   totalCount:(NSInteger)totalCount;

@end

@interface YVLocalizedFilesBaseViewController : UIViewController

@property (nonatomic) CGRect initFrame;
@property (nonatomic) BOOL loadEnd;
@property (nonatomic, copy) NSString *msg;

@property (nonatomic) UserEditStatus editStatus;// 编辑状态

@property (nonatomic) NSInteger selectedFileCount;
@property (nonatomic) NSInteger totalFileCount;
@property (nonatomic, strong) NSMutableArray<YVResultFileGroupModel *> *fileModels;
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedFileNames;
@property (nonatomic, weak) id<YVLocalizedFileManagementDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

/// 更新文件数据模型
- (void)reloadFileModels;

///更新界面高度变化值
- (void)subViewShouldReloadHeight:(CGFloat)height;

/// 更新用户编辑状态
- (void)setUserEditStatus:(UserEditStatus)editStatus;

/*!
 * @breif 设置当前文件选中数量全选或取消全选
 * @param status 当前选中编辑文件的类型
 */
- (void)setSelectedStatus:(SelectedStatus)status;

@end

NS_ASSUME_NONNULL_END
