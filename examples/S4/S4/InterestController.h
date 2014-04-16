//
//  InterestController.h
//  S4
//
//  Created by Masa Jow on 4/12/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterestController : UIViewController
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *starting;
@property (weak, nonatomic) IBOutlet UITextField *desired;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *years;

- (IBAction)stepperChanged:(id)sender;

@end
