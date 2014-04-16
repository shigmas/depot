//
//  DiscountController.h
//  S4
//
//  Created by Masa Jow on 4/11/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DiscountController : UIViewController
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *priceInput;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceOutput;
@property (weak, nonatomic) IBOutlet UISlider *discountSlider;

- (IBAction)discountChanged:(id)sender;

@end
