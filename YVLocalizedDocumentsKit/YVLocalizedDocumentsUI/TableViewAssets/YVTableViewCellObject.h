//
//  YVTableViewCellObject.h
//  MDSmartHouseHoldLock
//
//  Created by Yoonvey on 2018/6/25.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface YVTableViewCellObject : NSObject

/*!
 * @brief 设置表格的分割线从最左边显示(两个方法配套使用)
 */
+ (void)setSeparatorInsetsZeroWithTableView:(UITableView *)tableView;
+ (void)setSeparatorInsetsZeroWithCell:(UITableViewCell *)cell;
/*!
 * @brief 设置表格的分割线不可见（适用于针对特定的cell分割线不可见而部分cell分割线可见的混差模式）
 */
+ (void)setSeparatorInsetsScreenWithCell:(UITableViewCell *)cell;

/*!
 * @brief 设置表格的分割线自定义边距
 */
+ (void)setSeparatorInsetWithCell:(UITableViewCell *)cell
                            inset:(UIEdgeInsets)inset;
/*!
 * @brief 隐藏(替换)表格多余的分割线
 */
+ (void)setExtraCellLineHidden: (UITableView *)tableView;
+ (void)setExtraCellLineHidden: (UITableView *)tableView
                 withCellColor:(UIColor *)color;

@end
