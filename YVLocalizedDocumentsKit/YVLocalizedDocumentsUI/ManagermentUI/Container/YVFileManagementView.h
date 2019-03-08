//
//  YVFileManagementView.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/2/28.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIBaseHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    ToolBarActionSelectedAll = 0,
    ToolBarActionSelectedNone,
    ToolBarActionUploadCloud,
    ToolBarActionSelectedDelete
} ToolBarActionType;

@class YVFileSelectButton;

@interface YVFileManagementView : UIView

- (instancetype)initWithParentView:(UIView *)view;

@property (nonatomic, strong) UIToolbar *toolBar;

@property (nonatomic, copy) void(^didTouchResponse)(ToolBarActionType actionType);

/*!
 * @brief 更新选中数量统计
 * @param selectedCount 当前选中数量
 * @param totalCount 总数
 */
- (void)updateSelectedCount:(NSInteger)selectedCount
                 totalCount:(NSInteger)totalCount;

- (void)showManagementView;
- (void)dismissManagementView;

@end

@interface YVFileSelectButton : UIButton

@end

NS_ASSUME_NONNULL_END
