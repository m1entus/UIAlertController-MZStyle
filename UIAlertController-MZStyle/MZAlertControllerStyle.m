//
//  MZAlertControllerStyle.m
//  customAlert
//
//  Created by Michal Zaborowski on 16.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

#import "MZAlertControllerStyle.h"

@implementation MZAlertControllerStyle

- (instancetype)init {
    if (self = [super init]) {
        _blurEffectStyle = UIBlurEffectStyleDark;
        _shouldApplyBlur = YES;
        _blurEffectAlpha = 1.0;
        _backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        
    }
    return self;
}

- (UIColor *)actionSheetCancelButtonBackgroundColor {
    if (!_actionSheetCancelButtonBackgroundColor) {
        return [_backgroundColor colorWithAlphaComponent:0.7];
    }
    return _actionSheetCancelButtonBackgroundColor;
}

- (UIColor *)defaultButtonColor {
    if (!_defaultButtonColor) {
        _defaultButtonColor = [UIColor whiteColor];
    }
    return _defaultButtonColor;
}

- (UIColor *)cancelButtonColor {
    if (!_cancelButtonColor) {
        _cancelButtonColor = [UIColor whiteColor];
    }
    return _cancelButtonColor;
}

- (UIColor *)destructiveButtonColor {
    if (!_destructiveButtonColor) {
        _destructiveButtonColor = [UIColor colorWithRed:1 green:0.23 blue:0.19 alpha:1.0];
    }
    return _destructiveButtonColor;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    MZAlertControllerStyle *copy = [[self class] allocWithZone:zone];
    copy.cancelButtonColor = [_cancelButtonColor copy];
    copy.defaultButtonColor = [_defaultButtonColor copy];
    copy.destructiveButtonColor = [_destructiveButtonColor copy];
    copy.titleLabelFont = [_titleLabelFont copy];
    copy.messageLabelFont = [_messageLabelFont copy];
    copy.buttonLabelFont = [_buttonLabelFont copy];
    copy.cancelButtonColor = [_cancelButtonColor copy];
    copy.actionSheetCancelButtonBackgroundColor = [_actionSheetCancelButtonBackgroundColor copy];
    copy.blurEffectStyle = _blurEffectStyle;
    copy.shouldApplyBlur = _shouldApplyBlur;
    copy.backgroundColor = [_backgroundColor copy];
    copy.blurEffectAlpha = _blurEffectAlpha;
    
    return copy;
}

@end
