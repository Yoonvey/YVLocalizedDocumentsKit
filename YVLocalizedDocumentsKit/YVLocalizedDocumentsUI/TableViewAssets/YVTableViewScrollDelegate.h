//
//  YVTableViewScrollDelegate.h
//  MDHandheldOperations
//
//  Created by Yoonvey on 2018/11/12.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import <Foundation/Foundation.h>

/*****
 *** 子控制器滑动代理协议
 *****/

@protocol YVTableViewScrollDelegate <NSObject>

@optional

/*!
 * @brief 滑动中
 * @param scrollView 滑动中的ScrolView
 * @param viewController 滑动中的ScrolView所在的控制器
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
             viewController:(UIViewController *)viewController;

/*!
 * @brief 拖动结束
 * @param scrollView 拖动的ScrolView
 * @param viewController 拖动的ScrolView所在的控制器
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
                  viewController:(UIViewController *)viewController;

/*!
 * @brief 滑动结束
 * @param scrollView 滑动的ScrolView
 * @param viewController 滑动的ScrolView所在的控制器
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
                      viewController:(UIViewController *)viewController;

@end
