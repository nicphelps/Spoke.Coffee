//
//  LoginViewController.h
//  SpokeCoffee
//
//  Created by Nicole Phelps on 4/26/14.
//  Copyright (c) 2014 Nicole Phelps. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : ViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

- (IBAction)touchLoginButton:(id)sender;
@property (weak, nonatomic) IBOutlet FBLoginView *facebookLoginButton;


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfTextField;




@end
