//
//  PaymentViewController.m
//  SpokeCoffee
//
//  Created by Nicole Phelps on 4/26/14.
//  Copyright (c) 2014 Nicole Phelps. All rights reserved.
//

#import "PaymentViewController.h"
#import "Stripe.h"
#import "UserClass.h"

#import "AFNetworking.h"
#import "AFURLSessionManager.h"
#import <AFNetworking/AFURLConnectionOperation.h>

#import "SuccessViewController.h"



#define STRIPE_TEST_KEY @"pk_test_xxxxxxxxxxxxxxxxxxxx"
#define STRIPE_PUBLISHABLE_KEY @"pk_live_xxxxxxxxxxxxxxxxxxxx" 

#define API_URL @"http://yoururl.com"



@interface PaymentViewController () {
    int statusCode;
}

@property (strong, nonatomic) STPCard* stripeCard;
@property (nonatomic, strong) NSMutableData *receivedData;

@property UserClass *user;



@end

@implementation PaymentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // init
    self.user = [UserClass getInstance];
    self.stripeCard = [[STPCard alloc] init];

    
    /*
    self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(15,20,290,55)
                                              andKey:@"pk_test_6pRNASCoBOKtIshFeQd4XMUh"];
    self.stripeView.delegate = self;
    [self.view addSubview:self.stripeView];
    */
    
    
    // text fields
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.cardNumberTextField.delegate = self;
    self.expMonthTextField.delegate = self;
    self.expYearTextField.delegate = self;
    self.cvcTextField.delegate = self;
    
}



/*
 spoke.coffee/charge post
 order[customer_name]
 order[customer_phone]
 order[delivery_instructions]
 stripeToken
 stripeEmail
 
 should return 200 status and webpage in body
 */



# pragma mark - Post request


- (void)postRequest {
    
    //if (self.user.card_number != nil) {
        
        
        NSString *coordinates = [self.user.latitude stringValue];
        coordinates = [coordinates stringByAppendingString:@", "];
        coordinates = [coordinates stringByAppendingString:[self.user.longitude stringValue]];
        
        
    
         NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
         @"ios",@"true",
         self.user.name, @"order[customer_name]",
         self.user.phone, @"order[customer_phone]",
         self.user.address, @"order[delivery_address]",
         self.user.delivery_instructions, @"order[delivery_instructions]",
         coordinates, @"order[delivery_coordinates]",
         STRIPE_PUBLISHABLE_KEY, @"stripeToken",
         self.user.email, @"stripeEmail",
         self.user.email, @"order[customer_email]",
         nil];
    /*
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"true",@"ios",
                                @"Nicole Phelps", @"order[customer_name]",
                                @"5035040156", @"order[customer_phone]",
                                @"123 23rd ave, portland", @"order[delivery_address]",
                                @"asap plz", @"order[delivery_instructions]",
                                @"42.00 , 120.00", @"order[delivery_coordinates]",
                                STRIPE_PUBLISHABLE_KEY, @"stripeToken",
                                @"nicole.marie.phelps@gmail.com", @"stripeEmail",
                                @"nicole.marie.phelps@gmail.com", @"customer_email",
                                nil];
    
*/
        
    
    NSString *jsonString;
    NSError *error;
    NSData *jsonParams = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    
    if (! jsonParams) {
        NSLog(@"Got an error dict to json: %@", error);
    } else {
       // jsonString = [[NSString alloc] initWithData:testString encoding:NSUTF8StringEncoding];
    }
    
    NSLog(@"\n\n\njson params: %@\n\n\n", jsonString);

    
    
    NSLog(@"params blah: %@", params);
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:API_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            NSLog(@"Success");
            
            
            // insert comment
            
            NSMutableArray *responseArray = [[NSMutableArray alloc] init];
            
            
            NSLog(@"response: %@", responseArray);
            
            
            

            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            NSLog(@"Response Error: %@", error);

            
        }];
        
        
 
}


# pragma mark - Stripe


- (void)performStripeOperation {
    
    /*
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    */
    
    [Stripe createTokenWithCard:self.stripeCard
                 publishableKey:STRIPE_PUBLISHABLE_KEY
                     completion:^(STPToken* token, NSError* error) {
                         if(error)
                             [self handleStripeError:error];
                         else
                             [self postRequest];
                     }];

    
    UIStoryboard *storyboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    }
    
    SuccessViewController *successViewController = [storyboard instantiateViewControllerWithIdentifier:@"successViewController"];
    //[self presentViewController:successViewController animated:NO completion:nil];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self.navigationController pushViewController:successViewController animated:YES];
    });
    
    
}


- (void)handleStripeError:(NSError *) error {
    
    //1
    if ([error.domain isEqualToString:@"StripeDomain"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    //2
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please try again"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
}


    



- (BOOL)validateCustomerInfo {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Please try again"
                                                     message:@"Please enter all required information"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    
    //1. Validate name & email
    if (self.user.name == nil ||
        self.user.email == nil) {
        
        [alert show];
        return NO;
    }
    
    //2. Validate card number, CVC, expMonth, expYear
    NSError* error = nil;
    [self.stripeCard validateCardReturningError:&error];
    
    //3
    if (error) {
        alert.message = [error localizedDescription];
        [alert show];
        return NO;
    }
    
    return YES;
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

#pragma mark - Textfield animation and Keyboard Dismissal


-(void)dismissKeyboard {
    [self.cardNumberTextField resignFirstResponder];
    [self.cvcTextField resignFirstResponder];
    [self.expYearTextField resignFirstResponder];
    [self.expMonthTextField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.cardNumberTextField) {
        [self.expMonthTextField becomeFirstResponder];
    } else if (textField == self.expMonthTextField) {
        [self.expYearTextField becomeFirstResponder];
    } else if (textField == self.expYearTextField) {
        [self.cvcTextField becomeFirstResponder];
    } else {
        [self.cvcTextField resignFirstResponder];
    }
    
    return YES;
    //return NO; // We do not want UITextField to insert line-breaks.
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"begain editing");
    
    if (textField == self.cardNumberTextField) {
        NSLog(@"textfield is passwordTextField");
        [self animateTextField: self.cardNumberTextField up: YES];
    } else if (textField == self.expMonthTextField) {
        NSLog(@"textfield is passwordTextField");
        [self animateTextField: self.expMonthTextField up: YES];
    } else if (textField == self.expYearTextField) {
        NSLog(@"textfield is passwordTextField");
        [self animateTextField: self.expYearTextField up: YES];
    } else {
        NSLog(@"textfield is passwordConfTextField");
        [self animateTextField: self.cvcTextField up: YES];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.cardNumberTextField) {
        [self animateTextField: self.cardNumberTextField up: NO];
    } else if (textField == self.expMonthTextField) {
        [self animateTextField: self.expMonthTextField up: NO];
    } else if (textField == self.expYearTextField) {
        [self animateTextField: self.expYearTextField up: NO];
    } else {
        [self animateTextField: self.cvcTextField up: NO];
    }
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    int movementDistance;
    float movementDuration;
    
    
    if (screenSize.height > 480.0f) {
        /*Do iPhone 5 stuff here.*/
        
        if (textField == self.cardNumberTextField) {
            movementDistance = 0;
            movementDuration = 0.3f;
        } else if (textField == self.expMonthTextField) {
            movementDistance = 0;
            movementDuration = 0.3f;
        } else if (textField == self.expYearTextField) {
            movementDistance = 80;
            movementDuration = 0.3f;
        } else { //(textField == self.cvc) {
            NSLog(@"focusing cvc conf");
            
            movementDistance = 180;
            movementDuration = 0.3f;
        }
    } else {
        /*Do iPhone Classic stuff here.*/
        
        if (textField == self.cardNumberTextField) {
            movementDistance = 0;
            movementDuration = 0.3f;
        } else if(textField == self.expMonthTextField) {
            movementDistance = 60;
            movementDuration = 0.3f;
        } else if(textField == self.expYearTextField) {
            movementDistance = 80;
            movementDuration = 0.3f;
        } else { //(textField == cvc) {
            movementDistance = 200;
            movementDuration = 0.3f;
        }
    }
    
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.scrollview.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}



 
    /*


    */
    

- (IBAction)touchSubmitButton:(id)sender {
    
    NSLog(@"clicked");
    
    //1
    self.stripeCard = [[STPCard alloc] init];
    self.stripeCard.name = self.user.name;
    self.stripeCard.number = self.cardNumberTextField.text;
    self.stripeCard.cvc = self.cvcTextField.text;
    
    self.stripeCard.expMonth = [self.expMonthTextField.text integerValue];
    self.stripeCard.expYear = [self.expYearTextField.text integerValue];
    
    //2
    
    /*
    //validations
    if (self.cardNumberTextField.text.length < 16) {
        [self showAlertWithMessage:@"Your card number is incorrect."];
        
        self.cardNumberTextField.text = @"";
        [self.cardNumberTextField becomeFirstResponder];
        
    } else if ([self.expMonthTextField.text intValue] < 1 || [self.expMonthTextField.text intValue] > 12) {
        [self showAlertWithMessage:@"Your expiration month is not valid"];
        
    } else if ([self.expYearTextField.text intValue] < 2014) {
        [self showAlertWithMessage:@"Your card has expired."];
        
    } else {
        */
        // if passes all validations
        //2
        if ([self validateCustomerInfo]) {
            
            NSLog(@"validated customer info!!!");
            [self postRequest];
            [self performStripeOperation];

            
            
        } else {
            NSLog(@"info not validated");
        }
    //}
    
}
@end
