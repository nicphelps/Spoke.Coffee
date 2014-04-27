//
//  OrderViewController.m
//  SpokeCoffee
//
//  Created by Nicole Phelps on 4/26/14.
//  Copyright (c) 2014 Nicole Phelps. All rights reserved.
//

#import "OrderViewController.h"

#import "UserClass.h"

#import "PaymentViewController.h"

@interface OrderViewController () {
}

@property UserClass *user;

@end

@implementation OrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // init
    self.user = [UserClass getInstance];

    if (self.user.name != nil) {
        self.nameTextField.text = self.user.name;
    }
    if (self.user.phone != nil) {
        self.phoneTextField.text = self.user.phone;
    }
    if (self.user.email != nil) {
        self.emailTextField.text = self.user.email;
    }
    
    // navigation
    [self.navigationController setNavigationBarHidden:NO];
    
    // text fields
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    // delegate
    // need for scrollview shifting to work
    self.nameTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.deliveryTextView.delegate = self;
    
    
}


#pragma mark - Alert

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait!"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Okay, cool."
                                          otherButtonTitles:nil];
    [alert show];
}


- (IBAction)touchPaymentButton:(id)sender {
    
    
    
    //validations
    if (self.nameTextField.text.length < 1) {
        
        [self showAlertWithMessage:@"Please, enter your first name."];
        
        self.nameTextField.text = @"";
        [self.nameTextField becomeFirstResponder];
    } else if (self.nameTextField.text.length < 1) {
        
    } else {
        
        self.user.name = self.nameTextField.text;
        self.user.phone = self.phoneTextField.text;
        self.user.email = self.emailTextField.text;
        self.user.delivery_instructions = self.deliveryTextView.text;
        
    
    UIStoryboard *storyboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    }
    
    PaymentViewController *paymentViewController = [storyboard instantiateViewControllerWithIdentifier:@"paymentViewController"];
    [self presentViewController:paymentViewController animated:NO completion:nil];
    
    }
}




#pragma mark - Textfield animation and Keyboard Dismissal


-(void)dismissKeyboard {
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.deliveryTextView resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        [self.phoneTextField becomeFirstResponder];
    } else if (textField == self.phoneTextField) {
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        [self.deliveryTextView becomeFirstResponder];
    } else {
        [self.deliveryTextView resignFirstResponder];
    }
    
    return YES;
    //return NO; // We do not want UITextField to insert line-breaks.
    
}


@end
