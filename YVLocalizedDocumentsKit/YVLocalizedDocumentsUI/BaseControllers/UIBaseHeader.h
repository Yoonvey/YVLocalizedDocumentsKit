//
//  UIBaseHeader.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/14.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#ifndef UIBaseHeader_h
#define UIBaseHeader_h

#define ScreenWidth      [UIScreen mainScreen].bounds.size.width
#define ScreenHeight     [UIScreen mainScreen].bounds.size.height
#define SafeAreaTopHeight (ScreenHeight == 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (ScreenHeight == 812.0 ? 83.5 : 49.5)

#define KColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1]
#define KColorAlpha(r,g,b,a) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(a)]
#define DarkGrayColor KColor(63, 70, 74)// 暗灰色

#define Bundle_Name(imageNamed) [NSString stringWithFormat:@"YVLocalizedDocumentsUIResources.bundle/%@", imageNamed]// 模块图标资源路径

typedef enum
{
    UserEditStatusNormal = 0,
    UserEditStatusEditing
} UserEditStatus;

#import "UIBaseControlRespoder.h"
#import "UIBaseViewController.h"
#import "UIBaseNavigationController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#endif /* UIBaseHeader_h */
