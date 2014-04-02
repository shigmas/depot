//
//  ViewController.h
//  BinarySearch
//
//  Created by Masa Jow on 4/1/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *numField;
@property (weak, nonatomic) IBOutlet UITextField *arrayField;
@property (weak, nonatomic) IBOutlet UILabel *indexField;

@property (weak, nonatomic) IBOutlet UITextView *output;
@property (weak, nonatomic) IBOutlet UITextView *instructions;

- (IBAction)addNumber:(id)sender;
- (IBAction)searchNumber:(id)sender;
- (IBAction)sortArray:(id)sender;

- (IBAction)clearNumbers:(id)sender;
@end
