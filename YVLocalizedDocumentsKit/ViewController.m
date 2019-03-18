//
//  ViewController.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/13.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "ViewController.h"

#import "YVLocalizedCacheManager.h"
#import "UIBaseControlRespoder.h"

#import "YVLocalizedFilesContainerViewController.h"

#import <stdarg.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    [self updateDataBaseInfoWithQueryString:@"第一",@"第二",nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 200, 100, 50);
    [button setTitle:@"展示UI" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(showManageUI) forControlEvents:UIControlEventTouchUpInside];
}

//- (void)updateDataBaseInfoWithQueryString:(NSString *)queryString,...NS_REQUIRES_NIL_TERMINATION
//{
//    if(!queryString) return;
//
//    va_list args;
//    va_start(args, queryString);
//    NSString *otherstring = nil;
//    while((otherstring = va_arg(args, NSString *)))
//    {
//        //依次取得所有参数
////        NSString *query = va_arg(args, NSString *);
//
//        NSLog(@"query = %@", otherstring);
//    }
//    va_end(args);
//}

- (void)showManageUI
{
    [UIBaseControlRespoder present:self toNextControl:@"YVLocalizedFilesContainerViewController" withProperties:nil];
}

@end
