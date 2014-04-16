//
//  OlympicController.m
//  S4
//
//  Created by Masa Jow on 4/13/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

#import "OlympicController.h"

#define OLYMPICS_START_YEAR 1896
#define WINTER_OLYMPICS_START_YEAR 1924
#define SPLIT_WINTER_OLYMPICS_START_YEAR 1994

// No olympics these years
#define WORLD_WAR_I    1916
#define WORLD_WAR_II_0 1940
#define WORLD_WAR_II_1 1944

#define WINTER_KEY @"Winter"
#define SUMMER_KEY @"Summer"
#define BOTH_KEY   @"BOTH"
#define NONE_KEY   @"None"

#define or ||
#define and &&


@interface OlympicController ()

@property (nonatomic, strong) NSDictionary *yearTextMap;

- (NSString *)getStringForYear:(NSInteger)year;
@end

@implementation OlympicController

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
    self.yearTextMap = @{WINTER_KEY : @"Winter Olympics Year",
                         SUMMER_KEY : @"Summer Olympics Year",
                         BOTH_KEY   : @"Summer and Winter Olympics Year",
                         NONE_KEY   : @"No olympics this year"};
    self.yearInput.delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkYear:(id)sender
{
    NSInteger year = [self.yearInput.text integerValue];
    self.yearOutput.text = [self getStringForYear:year];
}

- (NSString *)getStringForYear:(NSInteger)year
{
    NSString *key = NONE_KEY;
    // Check for a summer year
    if ((year >= OLYMPICS_START_YEAR)
        and (year != WORLD_WAR_I)
        and (year != WORLD_WAR_II_0)
        and (year != WORLD_WAR_II_1)) {
        // It's after the Olympics started, and not a year that it was
        // canceled.
        NSInteger yearDiff = year - OLYMPICS_START_YEAR;
        if (yearDiff % 4 == 0) {
            // summer olympics year.  Is it also winter?  Meaning, the
            // joint years are after they started the winter olympics,
            // and before it split into different years.
            if ((year >= WINTER_OLYMPICS_START_YEAR)
                and (year <= SPLIT_WINTER_OLYMPICS_START_YEAR)) {
                key = BOTH_KEY;
            } else {
                key = SUMMER_KEY;
            }
        } else if (year >= SPLIT_WINTER_OLYMPICS_START_YEAR) {
            yearDiff = year - SPLIT_WINTER_OLYMPICS_START_YEAR;
            // Or, is it after the split, then it's a cycle from the
            // split year.
            if (yearDiff % 4 == 0) {
                key = WINTER_KEY;
            }
        }
    }
    return [self.yearTextMap objectForKey:key];
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
    if ([self.yearInput isFirstResponder] && [touch view] != self.yearInput) {
        [self.yearInput resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
}




@end
