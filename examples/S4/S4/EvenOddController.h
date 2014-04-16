//
//  EvenOddController.h
//  S4
//
//  Created by Masa Jow on 4/11/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

#import <UIKit/UIKit.h>

// This uses some reactive cocoa.  As you type the number, the
// number is displayed as odd or even.
@interface EvenOddController : UIViewController
<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UILabel *outputLabel;

@end
