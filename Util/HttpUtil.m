//
//  HttpUtil.m
//  IOS
//
//  Created by xialeistudio on 15/11/30.
//  Copyright © 2015年 Group Friend Information. All rights reserved.
//

#import "HttpUtil.h"

@implementation HttpUtil
@synthesize api;
@synthesize timeout;

/**
 * 单例
 */
+ (instancetype)sharedInstance {
    static HttpUtil *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    });
    return instance;
}

/**
 * Http请求
 */
- (AFHTTPRequestOperationManager *)getDefaultHttpManager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //超时设置
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = timeout;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    return manager;
}

/**
 * GET请求
 */
- (void)getRequest:(NSString *)url withParams:(NSDictionary *)params successCallback:(void (^)(AFHTTPRequestOperation *, id))successCallback errorCallback:(void (^)(AFHTTPRequestOperation *, NSError *))errorCallback withParams:(AFHTTPRequestOperationManager *)manager {
    AFHTTPRequestOperationManager *_manager = manager == nil ? [self getDefaultHttpManager] : manager;
    [[_manager GET:url parameters:params success:successCallback failure:errorCallback] start];
}

/**
 * POST请求
 */
- (void)postRequest:(NSString *)url withParams:(NSDictionary *)params successCallback:(void (^)(AFHTTPRequestOperation *, id))successCallback errorCallback:(void (^)(AFHTTPRequestOperation *, NSError *))errorCallback withParams:(AFHTTPRequestOperationManager *)manager {
    AFHTTPRequestOperationManager *_manager = manager == nil ? [self getDefaultHttpManager] : manager;
    [[_manager POST:url parameters:params success:successCallback failure:errorCallback] start];
}

/**
 * 上传请求
 */
- (void)uploadRequest:(NSString *)url withParams:(NSDictionary *)params withFieldName:(NSString *)fileName withFilePath:(NSString *)filePath successCallback:(void (^)(AFHTTPRequestOperation *, id))successCallback errorCallback:(void (^)(AFHTTPRequestOperation *, NSError *))errorCallback progressCallback:(void (^)(long, long))progressCallback withManager:(AFHTTPRequestOperationManager *)manager {
    AFHTTPRequestOperationManager *_manager = manager == nil ? [self getDefaultHttpManager] : manager;
    AFHTTPRequestOperation *operation = [_manager POST:url parameters:params constructingBodyWithBlock:^(id <AFMultipartFormData> _Nonnull formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:fileName error:nil];
    }                                          success:successCallback failure:errorCallback];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if (progressCallback) {
            progressCallback((long) totalBytesWritten, (long) totalBytesExpectedToWrite);
        }
    }];
    [operation start];
}

/**
 * 下载请求
 */
- (void)downloadRequest:(NSString *)url withParams:(NSDictionary *)params withLocalPath:(NSString *)filePath successCallback:(void (^)(AFHTTPRequestOperation *, id))successCallback errorCallback:(void (^)(AFHTTPRequestOperation *, NSError *))errorCallback progressCallback:(void (^)(long, long))progressCallback {
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:url parameters:params error:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:filePath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (progressCallback) {
            progressCallback((long) totalBytesRead, (long) totalBytesExpectedToRead);
        }
    }];
    [operation setCompletionBlockWithSuccess:successCallback failure:errorCallback];
    [operation start];
}

/**
 * 保存Cookies
 */
- (void)storeCookies {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:api]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"app.cookies"];
}

/**
 * 加载Cookies
 */
- (void)loadCookies {
    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"app.cookies"];
    if ([data length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
}


@end
