//
// Created by xialeistudio on 15/12/11.
// Copyright (c) 2015 Vikaa. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SecureUtil : NSObject
/**
 * md5加密
 */
- (NSString *)md5:(NSString *)string
           length:(unsigned int)length;
@end