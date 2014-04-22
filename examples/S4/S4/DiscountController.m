//
//  DiscountController.m
//  S4
//
//  Created by Masa Jow on 4/11/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

#import "DiscountController.h"

#import <ReactiveCocoa.h>

@interface DiscountController ()

@property (nonatomic, strong) NSNumber *fullPrice;
@end

@implementation DiscountController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Funky interface, but it fits with what we have.
- (void)setSalePriceFromFullPrice:(NSNumber *)fullPrice
                      andDiscount:(float)discount
{
    float sale = [fullPrice floatValue]*discount;
    self.priceOutput.text = [NSString stringWithFormat:@"%.2f", sale];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // set the slider value at 100%
    self.discountSlider.value = 1.0;
    [self setDiscountPercentageFromSlider];
    
    self.priceInput.delegate = self;
    
    [[[self.priceInput.rac_textSignal
       filter:^BOOL(NSString *text) {
           return [text longLongValue] == 0 ? NO : YES;
       }]
      map:^NSNumber*(NSString *text) {
          return @([text longLongValue]);
      }]
     subscribeNext:^void(NSNumber *inputPrice) {
         self.fullPrice = inputPrice;
         [self setSalePriceFromFullPrice:inputPrice
                             andDiscount:self.discountSlider.value];
     }];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDiscountPercentageFromSlider
{
    float realVal = self.discountSlider.value;
    self.discountLabel.text =
    [NSString stringWithFormat:@"%f ", realVal*100.0];
}

- (IBAction)discountChanged:(id)sender
{
    // This is continuous stream of events.
    float realVal = self.discountSlider.value;
    [self setSalePriceFromFullPrice:self.fullPrice andDiscount:realVal];
    [self setDiscountPercentageFromSlider];
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
    if ([self.priceInput isFirstResponder] && [touch view] != self.priceInput) {
        [self.priceInput resignFirstResponder];
    }

    [super touchesBegan:touches withEvent:event];
}


@end
