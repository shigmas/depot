//
//  EvenOddController.m
//  S4
//
//  Created by Masa Jow on 4/11/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

#import "EvenOddController.h"

#import <ReactiveCocoa.h>

typedef enum
{
    EvenOddModuloMethod,
    EvenOddBitOperatorMethod,
} EvenOddMethod;

@interface EvenOddController ()

- (EvenOddMethod)getSelectedMethod;
- (void)setOutput:(int64_t)num;
- (BOOL)isEvenModuloMethod:(uint64_t)num;
- (BOOL)isEvenBitOperatorMethod:(uint64_t)num;

@property (nonatomic) EvenOddMethod method;

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

- (EvenOddMethod)getSelectedMethod
{
    if (self.calcControl.selectedSegmentIndex == 0)
        return EvenOddModuloMethod;
    else
        return EvenOddBitOperatorMethod;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.method = [self getSelectedMethod];
    
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

- (BOOL)isEvenModuloMethod:(uint64_t)num
{
    return (num % 2 == 0);
}

- (BOOL)isEvenBitOperatorMethod:(uint64_t)num
{
    // Do a bitwise AND operation with 1.  If it is
    // odd, it will be 1.  If it is even, it will be 0.
    // For example:
    // 1 in binary is 0001.
    // 3 in binary is 0011, 4 is 0100.  For even numbers,
    // the last bit is 0, for odd, the last bit is 1.
    return !(num & 1);
}

- (void)setOutput:(int64_t)num
{
    bool isEven;
    
    if (self.method == EvenOddModuloMethod) {
        isEven = [self isEvenModuloMethod:num];
    } else {
        isEven = [self isEvenBitOperatorMethod:num];
    }
    
    self.outputLabel.text = isEven ? @"Even" : @"Odd";
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


- (IBAction)calcMethodChanged:(id)sender
{
    self.method = [self getSelectedMethod];

}
@end
