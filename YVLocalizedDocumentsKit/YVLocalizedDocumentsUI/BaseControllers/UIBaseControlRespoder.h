//
//  UIBaseControlRespoder.h
//  MDHandheldOperations
//
//  Created by Yoonvey on 2018/10/29.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIBaseViewController.h"

@interface UIBaseControlRespoder : NSObject

/*!
 * @brief push跳转
 * @param viewControl 跳转发起类(必须是存在于一个NavigationController的控制器类，否则无法使用push跳转)
 * @param classObject 跳转目标类(可以是类名称，也可以是实例化的类对象，通常需要带返回的时候传入实例化的类对象)
 * @param properties 传递的属性(KVC模式,将要传递的属性的键值写入字典,该方法会查询目标类中是否含有相应的属性名,对应进行传值)
 */
+ (void)push:(UIBaseViewController *)viewControl toNextControl:(id)classObject withProperties:(NSDictionary *)properties;

/*!
 * @brief present跳转
 * @param viewControl 跳转发起类(viewControl没有导航栏控制器时，会自动添加封装一个导航栏控制器)
 * @param classObject 跳转目标类(可以是类名称，也可以是实例化的类对象，通常需要带返回的时候传入实例化的类对象)
 * @param properties 传递的属性(KVC模式,将要传递的属性的键值写入字典,该方法会查询目标类中是否含有相应的属性名,对应进行传值)
 */
+ (void)present:(id)viewControl toNextControl:(id)classObject withProperties:(NSDictionary *)properties;

@end
