//
// Created by xialeistudio on 15/12/19.
// Copyright (c) 2015 Vikaa. All rights reserved.
//

#import "UITextField+PlaceHolderColor.h"


@implementation UITextField (PlaceHolderColor)
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName : placeholderColor}];
}
@end