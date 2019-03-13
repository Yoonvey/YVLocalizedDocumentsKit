//
//  YVRequestTool.m
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/3/9.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import "YVRequestTool.h"

@implementation YVRequestTool

+ (void)postWithUrlString:(NSString *)urlString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //初始化请求对象
    YVSingletonManager *manager = [YVSingletonManager sharedManager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.validatesDomainName = NO;
    // 是否在证书域字段中验证域名
    manager.securityPolicy = securityPolicy;
    
    //设置请求超时
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"下载进度>%f",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success)
        {
            if ([responseObject isKindOfClass:[NSData class]])
            {
                NSString *responseString =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                id responseDictionary = [self dictionaryWithJsonString:responseString];
                success(responseDictionary);
            }
            else
            {
                success(responseObject);
            }
        }
    }  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (failure)
        {
            failure(error);
        }
    }];
}

+ (NSURLSessionDataTask *)uploadFileWithUrl:(NSString *)urlString parameter:(id)parameter uploadParam:(YVRequestTool *)uploadParam executing:(void (^)(YVRequestTool * _Nonnull, float))executingResponse completion:(nonnull void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nullable, id _Nullable))completionResponse
{
    return [[YVSingletonManager sharedManager] POST:urlString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        float progressValue = 1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        if (executingResponse)
        {
            executingResponse(uploadParam, progressValue);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseDataString =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        id responseDictionary = [self dictionaryWithJsonString:responseDataString];
        if(completionResponse)
        {
            completionResponse(task, nil, responseDictionary);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(completionResponse)
        {
            completionResponse(task, error, nil);
        }
    }];
}

+ (void)queueTypeToUploadFilesWithUrl:(NSString *)urlString parameter:(id)parameter uploadParams:(NSArray<YVRequestTool *> *)uploadParams maxOperationCount:(NSInteger)maxOperationCount executing:(nonnull void (^)(YVRequestTool * _Nonnull, float))executingResponse completion:(nonnull void (^)(void))completionResponse
{
    // 初始化队列对象
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = maxOperationCount;
    
    // 队列执行完成后监听(这里的后续方法的执行一定要在主线程中进行！！！)
    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 回到主线程执行,方便更新UI等
            if(completionResponse)
            {
                completionResponse();
            }
        }];
    }];
    
    // 建立上传文件队列执行逻辑
    for (YVRequestTool *uploadParam in uploadParams)
    {
        // 加上自动释放池,及时的释放临时变量,防止内存崩溃
        @autoreleasepool
        {
            // 创建一个任务
            NSBlockOperation *uploadOperation = [NSBlockOperation blockOperationWithBlock:^ {
                [self uploadTaskWithUrlStr:urlString parameter:parameter uploadParam:uploadParam filesCount:uploadParams.count uploadProgress:^(YVRequestTool *param, float progress) {
                     // 回调上传进度
                     if(executingResponse)
                     {
                         executingResponse(param, progress);
                     }
                 }];
            }];
            // 添加依赖以便获取队列执行完成的回调。
            [completionOperation addDependency:uploadOperation];
            // 将任务加入到队列中
            [queue addOperation:uploadOperation];
        }
    }
    // 将刷新UI的任务加入队列,当所有的上传任务结束才会调用completionOperation。
    [queue addOperation:completionOperation];
}

// 单个文件上传
+ (void)uploadTaskWithUrlStr:(NSString *)urlString parameter:(id)parameter uploadParam:(YVRequestTool *)uploadParam filesCount:(NSInteger)count uploadProgress:(void(^)(YVRequestTool *param, float progress))progress
{
    // 因为afn上传是异步执行的所以创建一个信号量。就是为了让一个任务完全的执行完毕后才执行下一个任务。加信号量就是为了把afn异步转化为同步。
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [[YVSingletonManager sharedManager] POST:urlString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        float progressValue = 1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        if (progress)
        {
            progress(uploadParam, progressValue);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_semaphore_signal(semaphore);// 图片成功了让信号量加1
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_semaphore_signal(semaphore);//图片传失败了让信号量加1
    }];
    //信号量等待。DISPATCH_TIME_FOREVER 永远等到吧。
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

+ (NSDictionary * _Nonnull)dictionaryWithJsonString:(NSString * _Nonnull)jsonString
{
    if (jsonString)
    {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if(error)
        {
            return nil;
        }
        return dictionary;
    }
    return nil;
}

@end



#pragma mark - <YVSingletonManager>

static YVSingletonManager *manager = nil;

@implementation YVSingletonManager

+ (YVSingletonManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        manager = [[YVSingletonManager alloc]init];
    });
    return manager;
}

+ (id)alloc
{
    if (manager == nil)
    {
        return [super alloc];
    }
    else
    {
        return nil;
    }
}

- (id)init
{
    if (self = [super init])
    {

    }
    return self;
}
@end
