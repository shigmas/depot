//
//  InterestController.m
//  S4
//
//  Created by Masa Jow on 4/12/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

#import "InterestController.h"

#import <ReactiveCocoa.h>

@interface InterestController ()

- (NSNumber *)findYearsToInterestWithStart:(NSNumber *)start
                                    andEnd:(NSNumber *)end;

@end

@implementation InterestController

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
    // Do any additional setup after loading the view from its nib.
    self.stepper.value = 1.0;
    
    self.starting.delegate = self;
    self.desired.delegate = self;
    
    RACSignal *startBalanceSignal =
    [[self.starting.rac_textSignal
     filter:^BOOL(NSString *text) {
         return [text floatValue] == 0 ? NO : YES;
     }]
     map:^NSNumber*(NSString *text) {
         return @([text floatValue]);
     }];
    
    RACSignal *endBalanceSignal =
    [[self.desired.rac_textSignal
      filter:^BOOL(NSString *text) {
          return [text floatValue] == 0 ? NO : YES;
      }]
     map:^NSNumber*(NSString *text) {
         return @([text floatValue]);
     }];
    
    RACSignal *needCalcSignal =
    //can also split
    [RACSignal combineLatest:@[startBalanceSignal, endBalanceSignal]
                      reduce:^id(NSNumber *start, NSNumber *desired) {
                          return [self findYearsToInterestWithStart:start
                                                               andEnd:desired];
                      }];
    
    [needCalcSignal subscribeNext:^(NSNumber *years) {
        [self updateYears:years];
    }];
}

- (void)updateYears:(NSNumber *)years
{
    self.years.text = [NSString stringWithFormat:@"%d",
                       [years intValue]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stepperChanged:(id)sender
{
    self.rate.text = [NSString stringWithFormat:@"%.2f", self.stepper.value];
    NSNumber *s = [NSNumber numberWithFloat:[self.starting.text floatValue]];
    NSNumber *d = [NSNumber numberWithFloat:[self.desired.text floatValue]];
    [self updateYears:[self findYearsToInterestWithStart:s andEnd:d]];
}

- (NSNumber *)findYearsToInterestWithStart:(NSNumber *)start
                                    andEnd:(NSNumber *)end
{
    float accumulated = 0.0;
    float startBalance = [start floatValue];
    float endBalance = [end floatValue];
    float interestRate = self.stepper.value*0.01;
    int years = 0;

    // very minor error checking - just make sure end is greater than start;
    if (startBalance >= endBalance)
        return [NSNumber numberWithInt:years];
    // If 0 interest, it'll take too long!
    if (interestRate == 0)
        return @0;
    
    while ((startBalance + accumulated) < endBalance) {
        years++;
        float yearInterest = (startBalance + accumulated) * interestRate;
        accumulated += yearInterest;
    }
    
    return [NSNumber numberWithInt:years];
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
    if ([self.starting isFirstResponder] && [touch view] != self.starting) {
        [self.starting resignFirstResponder];
    }
    if ([self.desired isFirstResponder] && [touch view] != self.desired) {
        [self.desired resignFirstResponder];
    }

    [super touchesBegan:touches withEvent:event];
}

@end
