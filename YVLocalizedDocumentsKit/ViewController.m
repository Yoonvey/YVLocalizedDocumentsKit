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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 200, 100, 50);
    [button setTitle:@"展示UI" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(showManageUI) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showManageUI
{
    [UIBaseControlRespoder present:self toNextControl:@"YVLocalizedFilesContainerViewController" withProperties:nil];
}

@end
