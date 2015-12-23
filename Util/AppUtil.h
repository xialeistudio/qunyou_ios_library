//
// Created by xialeistudio on 15/12/19.
// Copyright (c) 2015 Group Friend Information. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppUtil : NSObject


/**
 * 获取APP版本
 */
+ (NSString *)getAppVersion;

/**
 * 获取APP Build
 */
+ (NSString *)getAppBuild;

/**
 * 打开AppStore
 */
+(void)openAppStore:(NSString *)appID;
/**
 * 存储对象
 */
+(void)storeMutableDataToLocal:(id)data
                 forKey:(NSString *)key;
/**
 * 读取对象
 */
+(id)loadMutableDataFromLocal:(NSString *)key;
@end