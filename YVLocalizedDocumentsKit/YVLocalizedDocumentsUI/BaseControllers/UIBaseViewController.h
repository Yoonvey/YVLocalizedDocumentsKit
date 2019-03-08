//
//  UIBaseViewController.h
//  IOTUnitedPlatform
//
//  Created by 周荣飞 on 17/12/13.
//  Copyright © 2017年 ModouTech. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "Reachability.h"

@protocol UIBaseViewControllerDataSource<NSObject>

- (NSMutableAttributedString *)setTitle;//重写导航栏标题
- (UIButton *)set_leftButton;//重写导航栏左按钮
- (UIButton *)set_rightButton;;//重写导航栏右按钮
- (NSArray<UIButton *> *)set_rightButtons;//重写导航栏右按钮（多个按钮）
- (UIColor *)set_colorBackground;//重设导航栏背景
- (CGFloat)set_navigationHeight;//重设导航栏高度
- (UIView *)set_bottomView;//重设导航栏titleView
- (UIImage *)navBackgroundImage;
- (BOOL)hideNavigationBottomLine;//导航栏分割线设置
- (UIImage *)set_leftBarButtonItemWithImage;
- (UIImage *)set_rightBarButtonItemWithImage;
- (NSArray<UIImage *> *)set_rightBarButtonItemsWithImage;

@end

@protocol UIBaseViewControllerDelegate <NSObject>

@optional
- (void)left_button_event:(UIButton *)sender;
- (void)right_button_event:(UIButton *)sender;
- (void)title_click_event:(UIView *)sender;

@end

@interface UIBaseViewController : UIViewController <UIBaseViewControllerDelegate, UIBaseViewControllerDataSource, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *navBGView;//导航栏顶部默认加载的一个图层，可以通过设置hidden属性个性化隐藏

- (void)setNavigationBarColor:(UIColor *)color;
- (void)changeNavigationBarTranslationY:(CGFloat)translationY;
- (void)set_Title:(NSMutableAttributedString *)title;
- (NSMutableAttributedString *)changeTitle:(NSString *)curTitle;

@end
