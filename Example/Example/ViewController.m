//
//  ViewController.m
//  customAlert
//
//  Created by Michal Zaborowski on 15.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

#import "ViewController.h"
#import "UIAlertController+MZStyle.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *actionSheetSwitch;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)button:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Lorem ipsum" message:@"Lorem ipsum dolor sit amet, no vix nemore fierent, malis ridens virtute mea ad. Dolorem antiopam hendrerit ei vel, has audire discere expetendis." preferredStyle:self.actionSheetSwitch.on ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert];
    
    if (sender == self.button1) {
        // default
    } else if (sender == self.button2) {
        alert.currentStyle.blurEffectStyle = UIBlurEffectStyleLight;
        alert.currentStyle.backgroundColor = [[UIColor colorWithHue:0.57 saturation:0.78 brightness:0.73 alpha:1]colorWithAlphaComponent:0.8];
        alert.currentStyle.messageLabelFont = [UIFont fontWithName:@"Avenir" size:17.0];

    } else if (sender == self.button3) {
        alert.currentStyle.blurEffectStyle = UIBlurEffectStyleDark;
        alert.currentStyle.backgroundColor = [[UIColor colorWithHue:0.4 saturation:0.77 brightness:1.0 alpha:1] colorWithAlphaComponent:0.9];

    } else if (sender == self.button4) {
        alert.currentStyle.shouldApplyBlur = NO;
        alert.currentStyle.backgroundColor = [[UIColor colorWithHue:0.57 saturation:0.77 brightness:0.86 alpha:1]colorWithAlphaComponent:1.0];
        alert.currentStyle.destructiveButtonColor = [UIColor colorWithHue:0.13 saturation:0.94 brightness:0.95 alpha:1];

    } else {
        alert.currentStyle.shouldApplyBlur = YES;
        alert.currentStyle.backgroundColor = [UIColor colorWithHue:0.78 saturation:0.61 brightness:0.68 alpha:1];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"DELETE" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    if (alert.preferredStyle == UIAlertControllerStyleActionSheet) {
        [alert addAction:[UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            alert.modalPresentationStyle = UIModalPresentationPopover;
            alert.popoverPresentationController.sourceView = self.view;
            alert.popoverPresentationController.sourceRect = sender.frame;
        }
    }


    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
