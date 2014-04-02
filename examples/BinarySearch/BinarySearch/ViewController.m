//
//  ViewController.m
//  BinarySearch
//
//  Created by Masa Jow on 4/1/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

#import "ViewController.h"

#define INSTRUCTIONS @"Remember: the index starts at 0.  Put in the number, and press \"Add\".  When you have added your numbers, press \"Sort\", then \"Search\".  To start over, press \"Clear\""

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) NSInteger(^comp)(id, id);

- (NSNumber *)getIntegerFromString:(NSString *)str;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.searchArray = [[NSMutableArray alloc] init];
    self.output.text = INSTRUCTIONS;
    self.indexField.text = @"";
    self.numField.delegate = self;
    
    // This is the block that we use to sort and search.  Since we need to
    // pass it to both sort and search, we create and save it here.
    self.comp = ^NSInteger(id num1, id num2) {
        int v1 = [num1 intValue];
        int v2 = [num2 intValue];
        if (v1 < v2)
            return NSOrderedAscending;
        else if (v1 > v2)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    };


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSNumber *)getIntegerFromString:(NSString *)str
{
    // This is strange, and application specific.  But, NSString's
    // integerValue returns 0 on error.  So, we don't allow you
    // to enter 0 in the text box.
    NSInteger i = [str integerValue];
    if (i == 0) {
        self.output.text =
        [NSString stringWithFormat:@"%@ does not parse as an integer", str];
        return nil;
    } else {
        return [NSNumber numberWithInteger:i];
    }
}

- (void)printArray
{
    NSMutableString *str = [[NSMutableString alloc] init];
    bool first = true;
    for (NSNumber *n in self.searchArray) {
        NSInteger i = [n integerValue];
        if (first) {
            first = false;
            [str appendFormat:@"%d", i];
        } else {
            [str appendFormat:@", %d", i];
        }
    }
    
    self.arrayField.text = str;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


- (IBAction)addNumber:(id)sender
{
    NSString *dirty = self.numField.text;
    NSNumber *num = [self getIntegerFromString:dirty];
    if (num) {
        [self.searchArray addObject:num];
        [self printArray];
    }

    self.numField.text = @"";
}

- (IBAction)searchNumber:(id)sender
{
    NSString *dirty = self.numField.text;
    NSNumber *num = [self getIntegerFromString:dirty];
    if (num) {
        NSRange searchRange = NSMakeRange(0, [self.searchArray count]);
        NSInteger index =
            [self.searchArray indexOfObject:num
                              inSortedRange:searchRange
                                    options:NSBinarySearchingFirstEqual
                            usingComparator:self.comp];
        if ((index < 0) || (index > [self.searchArray count])) {
            self.output.text =
            [NSString stringWithFormat:@"%d was not found", [num integerValue]];
        } else {
            self.indexField.text = [NSString stringWithFormat:@"%d", index];
        }
    }
}
- (IBAction)sortArray:(id)sender
{
    [self.searchArray sortUsingComparator:self.comp];
    [self printArray];
}

- (IBAction)clearNumbers:(id)sender
{
    [self.searchArray removeAllObjects];
    self.output.text = INSTRUCTIONS;

    [self printArray];
}
@end
