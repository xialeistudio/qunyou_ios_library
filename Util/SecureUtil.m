//
// Created by xialeistudio on 15/12/11.
// Copyright (c) 2015 Group Friend Information. All rights reserved.
//

#import "SecureUtil.h"
#import <CommonCrypto/CommonDigest.h>


@implementation SecureUtil {

}
+ (NSString *)md5:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, string.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}
@end