//
//  YVRequestTool.h
//  YVLocalizedDocumentsKit
//
//  Created by Yoonvey on 2019/3/9.
//  Copyright © 2019年 Yoonvey. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface YVRequestTool : NSObject

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic, strong) NSURL *fileUrl;

/*!
 * @brief 发送post请求(
 * @param urlString  请求的网址字符串
 * @param parameters 请求的参数
 * @param success    请求成功的回调
 * @param failure    请求失败的回调
 */
+ (void)postWithUrlString:(NSString *)urlString
               parameters:(id)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;


/*!
 * @brief 单个上传文件
 * @param urlString 服务器地址
 * @param parameter 附带表单参数
 * @param uploadParam 存放文件信息的实体类
 * @block executingResponse 执行中的回调(通过这里的Block回调可以获取文件的上传进度信息)
 * @block completionResponse 执行完成后的回调
 */
+ (NSURLSessionDataTask *)uploadFileWithUrl:(NSString *)urlString
                parameter:(id)parameter
              uploadParam:(YVRequestTool *)uploadParam
                executing:(void (^)(YVRequestTool *param, float progress))executingResponse
               completion:(void (^)(NSURLSessionDataTask *task, NSError * _Nullable error, id _Nullable responseObject))completionResponse;

/*!
 * @brief 队列形式上传文件(这里的队列形式的上传文件，是没有将整个线程的文件打包的，要区别于uploadImagePost方法使用)
 * @param urlString 服务器地址
 * @param parameter 附带表单参数
 * @param uploadParams 存放文件信息的实体类集合
 * @param maxOperationCount 最大同时执行任务数量
 * @block executingResponse 执行中的回调(通过这里的Block回调可以获取文件的上传进度信息)
 * @block completionResponse 执行完成后的回调
 */
+ (void)queueTypeToUploadFilesWithUrl:(NSString *)urlString
                            parameter:(id)parameter
                         uploadParams:(NSArray<YVRequestTool *> *)uploadParams
                    maxOperationCount:(NSInteger)maxOperationCount
                            executing:(void (^)(YVRequestTool *param, float progress))executingResponse
                           completion:(void (^)(void))completionResponse;



@end

#pragma mark - <YVSingletonManager>
@interface YVSingletonManager : AFHTTPSessionManager

+ (YVSingletonManager *)sharedManager;

@end


NS_ASSUME_NONNULL_END
