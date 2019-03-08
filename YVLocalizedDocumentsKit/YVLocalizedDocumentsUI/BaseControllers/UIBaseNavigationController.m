//
//  UIBaseNavigationController.m
//  IOTUnitedPlatform
//
//  Created by 周荣飞 on 17/12/13.
//  Copyright © 2017年 ModouTech. All rights reserved.
//

#import "UIBaseNavigationController.h"

@interface UIBaseNavigationController ()

@end

@implementation UIBaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0)
    {
        //第二级则隐藏底部Tab
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    //    self.tabBarController.tabBar.hidden = NO;
    NSLog(@"%@-----%@",self.viewControllers.firstObject,self.viewControllers.lastObject);
    
    return  [super popViewControllerAnimated:animated];
}

@end
