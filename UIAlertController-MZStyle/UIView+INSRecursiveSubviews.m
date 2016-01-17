//
//  UIView+INSRecursiveSubviews.m
//  customAlert
//
//  Created by Michal Zaborowski on 15.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

#import "UIView+INSRecursiveSubviews.h"

@implementation UIView (INSRecursiveSubviews)

- (void)enumerateAllSubviewsUsingBlock:(void (^)(__kindof UIView *subview))block {
    block(self);
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateAllSubviewsUsingBlock:block];
    }];
}

- (BOOL)isAnySuperviewUntilView:(UIView *)view isKindOfClass:(Class)class {
    UIView *superview = self.superview;
    do {
        if (superview == view) {
            return NO;
        }
        if ([superview isKindOfClass:class]) {
            return YES;
        }
        superview = superview.superview;
    } while (superview);
    
    return NO;
}

@end
