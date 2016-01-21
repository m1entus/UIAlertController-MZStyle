//
//  UIAlertController+MZStyle.m
//  customAlert
//
//  Created by Michal Zaborowski on 16.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

#import "UIAlertController+MZStyle.h"
#import <objc/runtime.h>
#import "UIView+INSRecursiveSubviews.h"

static NSMutableSet <Class> *instanceOfClassesSet = nil;

@interface MZLabel : UILabel
@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, strong) UIColor *backgroundViewColor;
@end

@implementation MZLabel
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.backgroundView) {
        self.backgroundView.backgroundColor = self.backgroundViewColor;
    }
}
@end

@implementation UIAlertController (MZStyle)

+ (void)mz_swizzleInstanceSelector:(SEL)originalSelector
                 withNewSelector:(SEL)newSelector {
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    
    BOOL methodAdded = class_addMethod([self class],
                                       originalSelector,
                                       method_getImplementation(newMethod),
                                       method_getTypeEncoding(newMethod));
    
    if (methodAdded) {
        class_replaceMethod([self class],
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}


+ (MZAlertControllerStyle *)mz_sharedStyle {
    static MZAlertControllerStyle *instanceOfSharedStyle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanceOfSharedStyle = [[MZAlertControllerStyle alloc] init];
    });
    
    return instanceOfSharedStyle;
}

- (void)setDisableCustomStyle:(BOOL)disableCustomStyle {
    objc_setAssociatedObject(self, @selector(disableCustomStyle), @(disableCustomStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)disableCustomStyle {
    return [objc_getAssociatedObject(self, @selector(disableCustomStyle)) boolValue];
}

- (void)setCurrentStyle:(MZAlertControllerStyle *)currentStyle {
    objc_setAssociatedObject(self, @selector(currentStyle), currentStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MZAlertControllerStyle *)currentStyle {
    MZAlertControllerStyle *style = objc_getAssociatedObject(self, @selector(currentStyle));
    if (!style) {
        style = [[UIAlertController mz_sharedStyle] copy];
        self.currentStyle = style;
    }
    return style;
}

+ (void)mz_applyCustomStyleForAlertControllerClass:(Class)alertControllerClass {
    NSParameterAssert(alertControllerClass);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanceOfClassesSet = [[NSMutableSet alloc] init];
    });
    if (instanceOfClassesSet.count <= 0) {
        [self mz_swizzleInstanceSelector:@selector(viewWillAppear:) withNewSelector:@selector(mz_viewWillAppear:)];
    }
    [instanceOfClassesSet addObject:alertControllerClass];
}

- (UIColor *)colorForActionStyle:(UIAlertActionStyle)actionStyle {
    switch (actionStyle) {
        case UIAlertActionStyleDefault:
            return self.currentStyle.defaultButtonColor;
        case UIAlertActionStyleCancel:
            return self.currentStyle.cancelButtonColor;
        case UIAlertActionStyleDestructive:
            return self.currentStyle.destructiveButtonColor;
        default:
            return nil;
            break;
    }
}

- (void)mz_viewWillAppear:(BOOL)animated {
    [self mz_viewWillAppear:animated];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_8_4) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self applyCustomStyle];
        });
    } else {
        [self applyCustomStyle];
    }
}

- (void)applyCustomStyle {
    
    __block BOOL canApplyCustomStyle = NO;
    [instanceOfClassesSet enumerateObjectsUsingBlock:^(Class obj, BOOL * _Nonnull stop) {
        if ([self isKindOfClass:obj]) {
            canApplyCustomStyle = YES;
            *stop = YES;
        }
    }];
    if (!canApplyCustomStyle || self.disableCustomStyle) {
        return;
    }
    
    [self.presentationController.containerView enumerateAllSubviewsUsingBlock:^(__kindof UIView *subview) {
        if ([NSStringFromClass([subview class]) containsString:@"EffectView"] && ![subview isAnySuperviewUntilView:self.view isKindOfClass:[UIScrollView class]]) {
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_8_4) {
                subview = subview.superview;
            }
            
            UIView *visualEffectContainerView = subview.superview;
            UIVisualEffectView *view = nil;
            
            if (self.currentStyle.shouldApplyBlur) {
                view = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:self.currentStyle.blurEffectStyle]];
                view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                view.frame = subview.frame;
                view.alpha = self.currentStyle.blurEffectAlpha;
                [subview.superview addSubview:view];
            }
            
            [subview removeFromSuperview];
            
            UIView *backgroundView = nil;
            for (UIView *subview in visualEffectContainerView.subviews) {
                if (subview != view) {
                    backgroundView = subview;
                }
            }
            
            if (!self.currentStyle.shouldApplyBlur) {
                backgroundView.backgroundColor = [UIColor clearColor];
                backgroundView = backgroundView.superview;
            }
            backgroundView.backgroundColor = self.currentStyle.backgroundColor;
            
            if (self.currentStyle.backgroundViewConfigurationHandler) {
                self.currentStyle.backgroundViewConfigurationHandler(view.superview,backgroundView,view);
            }
        } else if ([subview respondsToSelector:@selector(action)]) {
            UIAlertAction *action = [subview valueForKey:@"action"];
            [subview enumerateAllSubviewsUsingBlock:^(__kindof UILabel *label) {
                if ([label isKindOfClass:[UILabel class]] && ![action isKindOfClass:[NSNumber class]]) {
                    MZLabel *newLabel = [self labelFromLabelAttributes:label];
                    newLabel.text = action.title;
                    newLabel.textColor = [self colorForActionStyle:action.style];
                    newLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                    [label.superview addSubview:newLabel];
                    
                    label.hidden = YES;
                    
                    if (self.preferredStyle == UIAlertControllerStyleActionSheet && action.style == UIAlertActionStyleCancel) {
                        UIView *superView = newLabel.superview;
                        
                        __block UIView *backgroundView = nil;
                        
                        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_8_4) {
                            backgroundView = superView.superview;
                        } else {
                            [superView.superview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if (obj != superView) {
                                    backgroundView = [obj.subviews firstObject];
                                    *stop = YES;
                                }
                            }];
                        }
                        
                        newLabel.translatesAutoresizingMaskIntoConstraints = NO;
                        [superView.superview addConstraint:[NSLayoutConstraint constraintWithItem:newLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:superView.superview
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.f constant:0.f]];
                        [superView.superview addConstraint:[NSLayoutConstraint constraintWithItem:newLabel
                                                                                   attribute:NSLayoutAttributeCenterY
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:superView.superview
                                                                                   attribute:NSLayoutAttributeCenterY
                                                                                  multiplier:1.f constant:0.f]];
  
                        backgroundView.backgroundColor = self.currentStyle.actionSheetCancelButtonBackgroundColor ?: self.currentStyle.backgroundColor;
                        newLabel.backgroundView = backgroundView;
                        newLabel.backgroundViewColor = backgroundView.backgroundColor;
                        
                        newLabel.font = self.currentStyle.cancelButtonLabelFont ? self.currentStyle.cancelButtonLabelFont : newLabel.font;
                        
                        if (self.currentStyle.actionSheetCancelButtonConfigurationHandler) {
                            self.currentStyle.actionSheetCancelButtonConfigurationHandler(action,newLabel,backgroundView);
                        }
                        
                    } else {
                        newLabel.font = self.currentStyle.buttonLabelFont ? self.currentStyle.buttonLabelFont : newLabel.font;
                        
                        if (self.currentStyle.buttonConfigurationHandler) {
                            self.currentStyle.buttonConfigurationHandler(action,newLabel);
                        }
                    }
                }
            }];
            
        } else if ([subview isKindOfClass:[UILabel class]] && ![subview respondsToSelector:@selector(action)]) {
            UILabel *label = subview;
            if ([label.text isEqualToString:self.title] || [label.text isEqualToString:self.message]) {
                
                UILabel *newLabel = [self labelFromLabelAttributes:label];
                newLabel.textColor = [UIColor whiteColor];
                
                [label.superview addSubview:newLabel];
                
                [self swapView:label withView:newLabel];
                label.hidden = YES;

                if ([label.text isEqualToString:self.title]) {
                    newLabel.font = self.currentStyle.titleLabelFont ? self.currentStyle.titleLabelFont : newLabel.font;
                } else {
                    newLabel.font = self.currentStyle.messageLabelFont ? self.currentStyle.messageLabelFont : newLabel.font;
                }
                
                CGRect frame = newLabel.frame;
                frame.size.height = [newLabel sizeThatFits:CGSizeMake(frame.size.width, CGFLOAT_MAX)].height;
                newLabel.frame = frame;
                
                if ([label.text isEqualToString:self.message]) {
                    if (self.currentStyle.messageLabelConfigurationHandler) {
                        self.currentStyle.messageLabelConfigurationHandler(newLabel);
                    }
                } else {
                    if (self.currentStyle.titleLabelConfigurationHandler) {
                        self.currentStyle.titleLabelConfigurationHandler(newLabel);
                    }
                }
            }
        }
    }];
}

- (MZLabel *)labelFromLabelAttributes:(UILabel *)label {
    MZLabel *newLabel = [[MZLabel alloc] initWithFrame:label.frame];
    newLabel.text = label.text;
    newLabel.numberOfLines = label.numberOfLines;
    newLabel.textColor = label.textColor;
    newLabel.tintColor = label.tintColor;
    newLabel.font = label.font;
    newLabel.tintAdjustmentMode = label.tintAdjustmentMode;
    newLabel.backgroundColor = label.backgroundColor;
    newLabel.textAlignment = label.textAlignment;
    return newLabel;
}


- (void)swapView:(UIView *)sourceView withView:(UIView *)destinationView {
    NSArray *constraints = sourceView.superview.constraints;
    
    // Recreate constraints, replace containerView with self
    for (NSLayoutConstraint *oldConstraint in constraints) {
        id firstItem = oldConstraint.firstItem;
        id secondItem = oldConstraint.secondItem;
        if (firstItem == sourceView) {
            firstItem = destinationView;
        }
        if (secondItem == sourceView) {
            secondItem = destinationView;
        }
        
        NSLayoutAttribute firstAttribute = oldConstraint.firstAttribute;
        NSLayoutAttribute secondAttribute = oldConstraint.secondAttribute;
        
        // This case was causing constraints error in alert controller
        if (firstAttribute == NSLayoutAttributeFirstBaseline || secondAttribute == NSLayoutAttributeFirstBaseline) {
            continue;
        }
        
        
        NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                                         attribute:firstAttribute
                                                                         relatedBy:oldConstraint.relation
                                                                            toItem:secondItem
                                                                         attribute:secondAttribute
                                                                        multiplier:oldConstraint.multiplier
                                                                          constant:oldConstraint.constant];
        [sourceView.superview addConstraint:newConstraint];
    }
}

@end
