//
// Created by xialeistudio on 15/12/11.
// Copyright (c) 2015 Group Friend Information. All rights reserved.
//

#import "SecureUtil.h"
#import <CommonCrypto/CommonDigest.h>


@implementation SecureUtil {

}
- (NSString *)md5:(NSString *)string
           length:(unsigned int)length {
    const char *chars = [string UTF8String];
    unsigned char result[length];
    CC_MD5(chars, length, result);
    NSMutableString *hash = [[NSMutableString alloc] init];

    for (int i = 0; i < length; ++i) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return hash;
}

@end