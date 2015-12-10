//
// Created by xialeistudio on 15/12/10.
// Copyright (c) 2015 Vikaa. All rights reserved.
//

#import "CALayer+InterfaceBuilderConfiguration.h"


@implementation CALayer (InterfaceBuilderConfiguration)

- (void)setBorderUIColor:(UIColor *)borderUIColor {
    self.borderColor = borderUIColor.CGColor;
}

- (UIColor *)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end