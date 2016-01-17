//
//  MZAlertControllerStyle.h
//  customAlert
//
//  Created by Michal Zaborowski on 16.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MZAlertViewControllerStyleBackgroundConfigurationHandler)(UIView *dimmingBackdropView, UIView *backgroundView, UIVisualEffectView *blurView);
typedef void(^MZAlertViewControllerStyleLabelConfigurationHandler)(UILabel *label);
typedef void(^MZAlertViewControllerStyleButtonConfigurationHandler)(UIAlertAction *action, UILabel *label);
typedef void(^MZAlertViewControllerStyleCancelButtonConfigurationHandler)(UIAlertAction *action, UILabel *label, UIView *backgroundView);

@interface MZAlertControllerStyle : NSObject <NSCopying>
@property (nonatomic, strong) UIColor *cancelButtonColor;
@property (nonatomic, strong) UIColor *defaultButtonColor;
@property (nonatomic, strong) UIColor *destructiveButtonColor;

@property (nonatomic, strong) UIFont *titleLabelFont;
@property (nonatomic, strong) UIFont *messageLabelFont;
@property (nonatomic, strong) UIFont *buttonLabelFont;
@property (nonatomic, strong) UIFont *cancelButtonLabelFont;

@property (nonatomic, strong) UIColor *actionSheetCancelButtonBackgroundColor;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle;
@property (nonatomic, assign) CGFloat blurEffectAlpha;
@property (nonatomic, assign) BOOL shouldApplyBlur;

@property (nonatomic, copy) MZAlertViewControllerStyleBackgroundConfigurationHandler backgroundViewConfigurationHandler;
@property (nonatomic, copy) MZAlertViewControllerStyleLabelConfigurationHandler titleLabelConfigurationHandler;
@property (nonatomic, copy) MZAlertViewControllerStyleLabelConfigurationHandler messageLabelConfigurationHandler;

@property (nonatomic, copy) MZAlertViewControllerStyleButtonConfigurationHandler buttonConfigurationHandler;

@property (nonatomic, copy) MZAlertViewControllerStyleCancelButtonConfigurationHandler actionSheetCancelButtonConfigurationHandler;
@end
