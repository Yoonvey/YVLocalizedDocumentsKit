//
//  AppDelegate.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/13.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "AppDelegate.h"

#import "YVLocalizedCacheManager.h"

#import "YVRequestTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"admin" forKey:@"userName"];
    [parameters setValue:@"888888" forKey:@"password"];
    [parameters setValue:@"ios" forKey:@"sysType"];
    
    __weak AppDelegate *weakSelf = self;
    [YVRequestTool postWithUrlString:LoginUrl(AppLogin) parameters:parameters success:^(id responseObject)
     {
         NSLog(@"responseString>%@",responseObject);
         NSDictionary *data = responseObject[@"data"];
         NSDictionary *loginInfo = data[@"loginInfo"];
         NSString *token = loginInfo[@"token"];
         weakSelf.token = token;
     } failure:^(NSError *error)
     {

     }];
    
    return YES;
}



#pragma mark - <第三方调用App后回调>
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if (url)
    {
        // 获取文件信息
        NSString *fileName = [url lastPathComponent];
        NSData *fileData = [NSData dataWithContentsOfURL:url];
        
        // 删除传输的时候的文件(一定要清除，否则会出现内存增大无法管理的问题)
        [self deleteFileDataWithUrl:url];
        
        // 缓存
        [[YVLocalizedCacheManager shareManager] addLocalizedCacheWithFileData:fileData fileName:fileName];
    }
    return YES;
}

/// 删除拷贝时候url中的文件
- (void)deleteFileDataWithUrl:(NSURL *)url
{
    NSString *openPath = url.path;
    if ([[NSFileManager defaultManager] fileExistsAtPath:openPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:openPath  error:nil];
    }
}

@end
