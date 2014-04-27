//
//  OrderViewController.h
//  SpokeCoffee
//
//  Created by Nicole Phelps on 4/26/14.
//  Copyright (c) 2014 Nicole Phelps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

@property (weak, nonatomic) IBOutlet UITextView *deliveryTextView;
- (IBAction)touchPaymentButton:(id)sender;

@end
