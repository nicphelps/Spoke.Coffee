//
//  PaymentViewController.m
//  SpokeCoffee
//
//  Created by Nicole Phelps on 4/26/14.
//  Copyright (c) 2014 Nicole Phelps. All rights reserved.
//

#import "PaymentViewController.h"
#define EXAMPLE_STRIPE_PUBLISHABLE_KEY @"pk_test_6pRNASCoBOKtIshFeQd4XMUh"


@interface PaymentViewController ()


@end

@implementation PaymentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(15,20,290,55)
                                              andKey:@"pk_test_6pRNASCoBOKtIshFeQd4XMUh"];
    self.stripeView.delegate = self;
    [self.view addSubview:self.stripeView];
    
}



- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    // Enable save button if the Checkout is valid
    self.navigationItem.rightBarButtonItem.enabled = valid;
}

- (IBAction)save:(id)sender
{
    // show spinner
    
    [self.stripeView createToken:^(STPToken *token, NSError *error) {
        //hide spinner
        if (error) {
            [self hasError:error];
        } else {
            [self hasToken:token];
        }
    }];
}

- (void)hasError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (void)hasToken:(STPToken *)token
{
    NSLog(@"Received token %@", token.tokenId);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://example.com"]];
    request.HTTPMethod = @"POST";
    NSString *body     = [NSString stringWithFormat:@"stripeToken=%@", token.tokenId];
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    // show spinner
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               // hide spinner
                               //                               if (error) {
                               //                                   [self hasError:error];
                               //                               } else {
                               [self.navigationController popViewControllerAnimated:YES];
                               //                               }
                           }];
}



@end
