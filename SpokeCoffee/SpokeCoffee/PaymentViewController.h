//
//  PaymentViewController.h
//  SpokeCoffee
//
//  Created by Nicole Phelps on 4/26/14.
//  Copyright (c) 2014 Nicole Phelps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPView.h"

@interface PaymentViewController : UIViewController <STPViewDelegate>



@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *expMonthTextField;
@property (weak, nonatomic) IBOutlet UITextField *expYearTextField;
@property (weak, nonatomic) IBOutlet UITextField *cvcTextField;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

- (IBAction)touchSubmitButton:(id)sender;

@end
