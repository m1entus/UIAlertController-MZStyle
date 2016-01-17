//
//  UIAlertController+MZStyle.h
//  customAlert
//
//  Created by Michal Zaborowski on 16.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZAlertControllerStyle.h"

@interface UIAlertController (MZStyle)
+ (MZAlertControllerStyle *)mz_sharedStyle;
+ (void)mz_applyCustomStyleForAlertControllerClass:(Class)alertControllerClass;

@property (nonatomic, strong) MZAlertControllerStyle *currentStyle;
@property (nonatomic, assign) BOOL disableCustomStyle;
@end
