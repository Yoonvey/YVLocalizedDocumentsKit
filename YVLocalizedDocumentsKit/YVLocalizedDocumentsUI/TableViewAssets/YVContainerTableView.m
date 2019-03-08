//
//  YVContainerTableView.m
//  YVDrawerListViewDemo
//
//  Created by Yoonvey on 2018/12/12.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "YVContainerTableView.h"

typedef enum
{
    ScrollDirectionNone = 0,
    ScrollDirectionDown,
    ScrollDirectionUp
} ScrollDirection;

@interface YVContainerTableView ()

@property (nonatomic) UIView *customBackgroundView;

@property (nonatomic) CGPoint dismissOrigin;
@property (nonatomic) CGPoint hoverOrigin;
@property (nonatomic) CGPoint halfOrigin;
@property (nonatomic) CGPoint screenOrigin;

@property (nonatomic) CGPoint scrollStartPoint;
@property (nonatomic) ScrollDirection scrollDirection;

@end

@implementation YVContainerTableView

#pragma mark - <初始化>
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style customBackgroundView:(nonnull UIView *)customBackgroundView
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        // 背景视图
        self.backgroundView = customBackgroundView;
        self.customBackgroundView = customBackgroundView;
        
        // 头部预留视图(开辟一块空白空间)
        [self setupHeaderView];
        
        [self setupCommon];
    }
    return self;
}

- (void)setupCommon
{
    self.delaysContentTouches = NO;
    self.bounces = NO;// 不允许回弹效果(这个属性将使刷新无效)
    self.showsVerticalScrollIndicator = NO;
    
    self.validScrollDistance = 40;
    
    // 初始化滑动起点
    self.scrollStartPoint = CGPointMake(0, 0);
    
    // 初始化各个停滞点坐标
    self.screenOrigin = CGPointMake(self.bounds.origin.x, self.bounds.size.height);
    self.dismissOrigin = CGPointMake(self.bounds.origin.x, 0);
    self.hoverOrigin = CGPointMake(self.bounds.origin.x, 0);
    self.halfOrigin = CGPointMake(self.bounds.origin.x, 0);
}

// 初始停滞点
- (void)setHoverHeight:(CGFloat)hoverHeight
{
    _hoverHeight = hoverHeight;
    self.hoverOrigin = CGPointMake(self.bounds.origin.x, hoverHeight);
}

// 半置停滞点
- (void)setHalfheight:(CGFloat)halfheight
{
    _halfheight = halfheight;
    self.halfOrigin = CGPointMake(self.bounds.origin.x, halfheight);
}

- (void)setValidScrollDistance:(CGFloat)validScrollDistance
{
    validScrollDistance = (validScrollDistance > 0) ? validScrollDistance : 40;
    _validScrollDistance = validScrollDistance;
}

#pragma mark - <添加HeaderView>
- (void)setupHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:self.bounds];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.userInteractionEnabled = NO;
    self.tableHeaderView = headerView;
}

#pragma mark - <进行响应触发拦截判断，屏蔽HeaderView的滑动s触发事件>
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if([view isMemberOfClass:[NSClassFromString(@"UITableViewCellContentView") class]])
    {
        return YES;
    }
    return NO;// NO - 不取消，touch事件由view处理，scrollView不滚动; YES - scrollView取消，touch事件由scrollView处理，可滚动
}

#pragma mark - <视图滑动过程监控>
- (void)scrollView:(UIScrollView *)scrollView willBeginDraggingInContentOffset:(CGPoint)contentOffset
{
    self.scrollStartPoint = (contentOffset.y < self.bounds.size.height) ? contentOffset : CGPointMake(contentOffset.x, self.bounds.size.height);
}

- (void)scrollView:(UIScrollView *)scrollView didScrollInContentOffset:(CGPoint)contentOffset
{
    // 限制滑动点坐标
    if (contentOffset.y <= self.hoverHeight)
    {
        contentOffset.y = self.hoverHeight;
        scrollView.contentOffset = CGPointMake(contentOffset.x, contentOffset.y);
    }
    
    // 判断滑动方向
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:self];
    self.scrollDirection = (point.y > 0) ? ScrollDirectionDown : ScrollDirectionUp;
}

/// 滑动结束时的监控
- (void)scrollView:(UIScrollView *)scrollView didEndScrollInContentOffset:(CGPoint)contentOffset decelerate:(BOOL)decelerate
{
    if ((contentOffset.y < self.bounds.size.height))
    {
        CGFloat duration = decelerate ? 0.02 : 0.15;
        [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^
        {
            [self stayScrollView:scrollView atContentSize:contentOffset];
        } completion:nil];
    }
    // 重置滑动状态
    self.scrollStartPoint = CGPointMake(0, 0);
    self.scrollDirection = ScrollDirectionNone;
}

#pragma mark - <判断悬停位置>
- (void)stayScrollView:(UIScrollView *)scrollView atContentSize:(CGPoint)contentOffset
{
    if (self.scrollDirection == ScrollDirectionUp)// 向上滑动
    {
        if((contentOffset.y - self.scrollStartPoint.y) > self.validScrollDistance)
        {
            self.scrollStartPoint = (contentOffset.y >= self.halfheight) ? self.halfOrigin : self.scrollStartPoint;// 判断设置起始点坐标
            CGPoint endOrigin = (self.scrollStartPoint.y <= self.hoverOrigin.y) ? self.halfOrigin : self.screenOrigin;// 根据起始点设置终止点坐标
            [scrollView setContentOffset:endOrigin animated:YES];
        }
        else
        {
            [scrollView setContentOffset:self.scrollStartPoint animated:YES];
        }
    }
    else// 向下滑动
    {
        if((self.scrollStartPoint.y - contentOffset.y) > self.validScrollDistance)
        {
            self.scrollStartPoint = (contentOffset.y >= self.halfheight) ? self.scrollStartPoint : self.halfOrigin;// 判断设置起始点坐标
            CGPoint endOrigin = (self.scrollStartPoint.y > self.halfOrigin.y) ? self.halfOrigin : self.hoverOrigin;// 根据起始点设置终止点坐标
            [scrollView setContentOffset:endOrigin animated:YES];
        }
        else
        {
            [scrollView setContentOffset:self.scrollStartPoint animated:YES];
        }
    }
}

#pragma mark - <display方法>
// 部分显示
- (void)scrollToHoverRect
{
    [self scrollRectToVisible:CGRectMake(0, self.hoverHeight, self.bounds.size.width, self.bounds.size.height) animated:YES];
}

// 半置屏显示
- (void)scrollToHalfRect
{
    [self scrollRectToVisible:CGRectMake(0, self.halfheight, self.bounds.size.width, self.bounds.size.height) animated:YES];
}

// 全屏显示
- (void)scrollToScreenRect
{
    [self scrollRectToVisible:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height) animated:YES];
}

// 全屏消失
- (void)scrollToDismissRect
{
    [self scrollRectToVisible:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) animated:YES];
}

@end
