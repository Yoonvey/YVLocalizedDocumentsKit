//
//  YVContainerTableView.h
//  YVDrawerListViewDemo
//
//  Created by Yoonvey on 2018/12/12.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YVContainerTableView : UITableView <UIScrollViewDelegate>

/*!
 * @brief 重写表格初始化方法(请务必调用此方法进行表格视图的实例化)
 * @param customBackgroundView 自定义底层视图(注意：这个视图会被默认设置成跟UITableView大小一样的视图，所以在实例化视图时请添加到一个size等于UITableView大小的UIView上)
 */
- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
         customBackgroundView:(UIView *)customBackgroundView;

// 有效滑动距离
@property (nonatomic) CGFloat validScrollDistance;//释放时拖动到设定之后执行拖动生效(正值, 默认为40)

// 滑动到一个悬停展示的高度
@property (nonatomic) CGFloat hoverHeight;// 悬停展示高度
- (void)scrollToHoverRect;

// 滑动到一个半置展示的高度
@property (nonatomic) CGFloat halfheight;// 半置展示高度
- (void)scrollToHalfRect;

//全屏和空屏
- (void)scrollToScreenRect;
- (void)scrollToDismissRect;

/*!
 * @brief 拖动动监控,用于获取拖动的起始位置
 * @param scrollView 拖动的ScrollView
 * @param contentOffset ScrollView拖动的起始坐标
 * @rely  UIScrollViewDelegate: -(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView中调用此方法
 */
- (void)scrollView:(UIScrollView *)scrollView willBeginDraggingInContentOffset:(CGPoint)contentOffset;

/*!
 * @brief 滑动监控
 * @param scrollView 滑动的ScrollView
 * @param contentOffset ScrollView当前滑动的偏移量
 # @rely  UIScrollViewDelegate: -(void)scrollViewDidScroll:(UIScrollView *)scrollView中调用此方法
 */
- (void)scrollView:(UIScrollView *)scrollView didScrollInContentOffset:(CGPoint)contentOffset;

/*!
 * @brief 滑动结束时的监控
 * @param scrollView 滑动的ScrollView
 * @param contentOffset ScrollView结束滑动的偏移量
 * @rely  UIScrollViewDelegate: -(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 中调用此方法
 * @rely  UIScrollViewDelegate: -(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 只有在!decelerate情况下才能调用此方法
 */
- (void)scrollView:(UIScrollView *)scrollView didEndScrollInContentOffset:(CGPoint)contentOffset decelerate:(BOOL)decelerate;

@end

NS_ASSUME_NONNULL_END
