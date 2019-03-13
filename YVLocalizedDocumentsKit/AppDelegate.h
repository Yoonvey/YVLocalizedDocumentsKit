//
//  AppDelegate.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2018/12/13.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SERVER_IP @"172.29.6.149"
#define SERVER_Port @"28182"
#define SERVER_DomainName @"http"
#define BaseUrl [NSString stringWithFormat:@"%@://%@:%@/", SERVER_DomainName, SERVER_IP, SERVER_Port]

#define LoginUrl(interface) [NSString stringWithFormat:@"%@%@?", BaseUrl, interface]// 调用登录时拼接的Url头
#define CommonUrl(interface, token) [NSString stringWithFormat:@"%@loginToken=%@", LoginUrl(interface), token]// 调用普通拼接的Url头

#define AppLogin @"total/login"// 登录接口(登录界面)
#define AddFile @"engineering/document/add"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) NSString *token;


@end

