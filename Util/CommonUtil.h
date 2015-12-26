//
// Created by xialeistudio on 15/12/21.
// Copyright (c) 2015 Group Friend Information. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommonUtil : NSObject
/**
 * 格式化时间戳
 */
+(NSString *)formatTime:(NSTimeInterval) timestamp withFormat:(NSString *)format;

/**
 * 七牛缩略图处理
 */
+(NSString *)thumbQiniu:(NSString *)url
                  width:(NSString *)width
                 height:(NSString *)height;

+ (NSString *)thumbQiniu:(id)o width:(NSString *)width height:(NSString *)height type:(NSString *)type;
@end