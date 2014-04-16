//
//  OlympicController.h
//  S4
//
//  Created by Masa Jow on 4/13/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OlympicController : UIViewController
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *yearInput;
@property (weak, nonatomic) IBOutlet UILabel *yearOutput;

- (IBAction)checkYear:(id)sender;
@end
