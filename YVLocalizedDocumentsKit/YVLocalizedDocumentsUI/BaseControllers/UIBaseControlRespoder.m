//
//  UIBaseControlRespoder.m
//  MDHandheldOperations
//
//  Created by Yoonvey on 2018/10/29.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "UIBaseControlRespoder.h"

#import <objc/runtime.h>

#import "UIBaseNavigationController.h"

@implementation UIBaseControlRespoder

+ (void)push:(UIBaseViewController *)viewControl toNextControl:(id)classObject withProperties:(NSDictionary *)properties
{
    if (viewControl.navigationController)
    {
        UIBaseViewController *nextControl = nil;
        if ([classObject isKindOfClass:[NSString class]])
        {
            nextControl = (UIBaseViewController *)[[NSClassFromString(classObject) alloc] init];
        }
        else
        {
            nextControl = classObject;
        }
        
        if (!nextControl)
        {
            return;
        }
        
        if (properties.count != 0)
        {
            NSArray *propertyKeys = [properties allKeys];
            NSArray *propertyValues = [properties allValues];
            for (int i=0; i<propertyKeys.count; i++)
            {
                NSString *propertyKey = propertyKeys[i];
                NSString *propertyValue = propertyValues[i];
                //属性写入
                if ([self checkIsExistPropertyWithInstance:nextControl verifyPropertyName:propertyKey])
                {
                    [nextControl setValue:propertyValue forKey:propertyKey];
                }
            }
        }
        [viewControl.navigationController pushViewController:nextControl animated:YES];
    }
}

+ (void)present:(id)viewControl toNextControl:(id)classObject withProperties:(NSDictionary *)properties
{
    UIBaseViewController *nextControl = nil;
    if ([classObject isKindOfClass:[NSString class]])
    {
        nextControl = (UIBaseViewController *)[[NSClassFromString(classObject) alloc] init];
    }
    else
    {
        nextControl = classObject;
    }

    if (!nextControl)
    {
        return;
    }
    
    if (properties.count != 0)
    {
        NSArray *propertyKeys = [properties allKeys];
        NSArray *propertyValues = [properties allValues];
        for (int i=0; i<propertyKeys.count; i++)
        {
            NSString *propertyKey = propertyKeys[i];
            NSString *propertyValue = propertyValues[i];
            //属性写入
            if ([self checkIsExistPropertyWithInstance:nextControl verifyPropertyName:propertyKey])
            {
                [nextControl setValue:propertyValue forKey:propertyKey];
            }
        }
    }
    if ([viewControl isKindOfClass:[UIBaseViewController class]])
    {
        UIBaseViewController *baseControl = (UIBaseViewController *)viewControl;
        if (baseControl.navigationController)
        {
            [baseControl presentViewController:nextControl animated:YES completion:nil];
        }
        else
        {
            UIBaseNavigationController *navControl = [[UIBaseNavigationController alloc] initWithRootViewController:nextControl];
            [baseControl presentViewController:navControl animated:YES completion:nil];
        }
    }
    else
    {
        UIViewController *baseControl = (UIViewController *)viewControl;
        if (baseControl.navigationController)
        {
            [baseControl presentViewController:nextControl animated:YES completion:nil];
        }
        else
        {
            UIBaseNavigationController *navControl = [[UIBaseNavigationController alloc] initWithRootViewController:nextControl];
            [baseControl presentViewController:navControl animated:YES completion:nil];
        }
    }

}

+ (BOOL)checkIsExistPropertyWithInstance:(id _Nonnull)instance
                      verifyPropertyName:(NSString *_Nonnull)verifyPropertyName
{
    unsigned int outCount, i;
    //获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName])
        {
            free(properties);
            return YES;
        }
    }
    free(properties);
    return NO;
}

@end
