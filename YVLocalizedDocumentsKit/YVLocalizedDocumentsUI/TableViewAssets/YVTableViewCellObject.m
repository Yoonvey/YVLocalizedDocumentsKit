//
//  YVTableViewCellObject.m
//  MDSmartHouseHoldLock
//
//  Created by Yoonvey on 2018/6/25.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "YVTableViewCellObject.h"

@implementation YVTableViewCellObject

+ (void)setSeparatorInsetsZeroWithTableView:(UITableView *)tableView
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

+ (void)setSeparatorInsetsZeroWithCell:(UITableViewCell *)cell
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

+ (void)setSeparatorInsetsScreenWithCell:(UITableViewCell *)cell
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width, 0, 0)];
    }
}

+ (void)setSeparatorInsetWithCell:(UITableViewCell *)cell inset:(UIEdgeInsets)inset
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:inset];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:inset];
    }
}

+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

+ (void)setExtraCellLineHidden: (UITableView *)tableView withCellColor:(UIColor *)color
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
