//
//  EvenOddController.m
//  S4
//
//  Created by Masa Jow on 4/11/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

#import "EvenOddController.h"

#import <ReactiveCocoa.h>

@interface EvenOddController ()

- (void)setOutput:(int64_t)num;


@end

@implementation EvenOddController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.outputLabel.text = @"No valid number";
    // Do any additional setup after loading the view from its nib.
    [[self.inputField.rac_textSignal
      filter:^BOOL(NSString *text) {
          return [text longLongValue] == 0 ? NO : YES;
      }]
      subscribeNext:^(NSString *text) {
          [self setOutput:[text longLongValue]];
    }];

}

- (void)setOutput:(int64_t)num
{
    self.outputLabel.text = (num % 2 == 0) ? @"Even" : @"Odd";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

///////////////////////////////


// we're a view controller, so we get all the touches.  If the touch
// is not the textField, then dismiss the keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.inputField isFirstResponder] && [touch view] != self.inputField) {
        [self.inputField resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
}


@end
