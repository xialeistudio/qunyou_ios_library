//
//  RegexTool.h
//  IOS
//
//  Created by xialeistudio on 15/11/30.
//  Copyright © 2015年 Group Friend Information. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegexTool : NSObject
/**
 * 检测手机号码是否合法
 */
+(BOOL)isPhone:(NSString *)string;

/**
 * 检测邮箱是否合法
 */
+(BOOL)isEmail:(NSString *)string;
@end
