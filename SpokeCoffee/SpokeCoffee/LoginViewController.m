//
//  LoginViewController.m
//  SpokeCoffee
//
//  Created by Nicole Phelps on 4/26/14.
//  Copyright (c) 2014 Nicole Phelps. All rights reserved.
//

#import "LoginViewController.h"
#import "MapViewController.h"
#import "UserClass.h"

#import <FacebookSDK/FacebookSDK.h>






@interface LoginViewController ()

@property UserClass *user;

@end



@implementation LoginViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // delegate
    // need for scrollview shifting to work
    self.nameTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.passwordConfTextField.delegate = self;
    
    
    // text fields
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.passwordTextField.secureTextEntry = YES;
    self.passwordConfTextField.secureTextEntry = YES;
    
    // facebook
    self.facebookLoginButton.readPermissions = @[@"basic_info", @"email", @"user_likes"];
    self.facebookLoginButton.delegate = self;
    
    // user class
    self.user = [UserClass getInstance];
    
    
}


# pragma mark - Login Button

- (IBAction)touchLoginButton:(id)sender {
    
    NSLog(@"Touched Login Button");
    
    /*
    //validations
    if (self.nameTextField.text.length < 1) {
        
        [self showAlertWithMessage:@"Please, enter your first name."];
        
        self.nameTextField.text = @"";
        [self.nameTextField becomeFirstResponder];
    } else if (self.phoneTextField.text.length < 1) {
        
        [self showAlertWithMessage:@"Please, enter your last name."];
        
        self.phoneTextField.text = @"";
        [self.phoneTextField becomeFirstResponder];
        
    } else if (self.emailTextField.text.length < 5) {
        [self showAlertWithMessage:@"Please, enter a valid email."];
        
        self.emailTextField.text = @"";
        [self.emailTextField becomeFirstResponder];
        
    } else if (![self.passwordTextField.text isEqualToString:self.passwordConfTextField.text]) {
        [self showAlertWithMessage:@"Make sure your password is at least 8 characters."];
        
        self.passwordTextField.text = @"";
        [self.passwordTextField becomeFirstResponder];
        
    } else if (self.passwordConfTextField.text.length < 8) {
        [self showAlertWithMessage:@"Your password does not match the confirmation."];
        
    } else {
        
        if (!FBSession.activeSession.isOpen) {
            
            self.user.name = self.nameTextField.text;
            self.user.phone = self.phoneTextField.text;
            self.user.email = self.emailTextField.text;
        }
        
        UIStoryboard *storyboard;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
        } else {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
        }
        
        MapViewController *mapViewController = [storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
        [self presentViewController:mapViewController animated:NO completion:nil];
        
    }
     */
    
    self.user.name = self.nameTextField.text;
    self.user.phone = self.phoneTextField.text;
    self.user.email = self.emailTextField.text;
    
    
    UIStoryboard *storyboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    }
    
    MapViewController *mapViewController = [storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
    [self presentViewController:mapViewController animated:NO completion:nil];
    
    
}

# pragma mark - Facebook Login Button

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    NSLog(@"Fetched user info!!!");
    
}

// User Logged in to facebook
- (void)fbDidLogin {
    NSLog(@"logged in");
}

// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    //self.statusLabel.text = @"You're logged in as";
    
    NSLog(@"LOGGED IN");
    
    
    if (FBSession.activeSession.isOpen) {
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection,id<FBGraphUser> user,NSError *error) {
            if (!error) {
                
                NSLog(@"Logged in with Facebook!!!11");
            }
        }];
    }
    
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
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.passwordConfTextField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.nameTextField) {
        [self.phoneTextField becomeFirstResponder];
    } else if (textField == self.phoneTextField) {
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.passwordConfTextField becomeFirstResponder];
    } else {
        [self.passwordConfTextField resignFirstResponder];
    }
    
    return YES;
    //return NO; // We do not want UITextField to insert line-breaks.
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"begain editing");
    
        if(textField == self.nameTextField ) {
            NSLog(@"textfield is name");
            [self animateTextField: self.nameTextField up: YES];
        } else if (textField == self.phoneTextField) {
            NSLog(@"textfield is phone");
            [self animateTextField: self.phoneTextField up: YES];
        }
        else if (textField == self.emailTextField) {
            NSLog(@"textfield is emailTextField");
            [self animateTextField: self.emailTextField up: YES];
        } else if (textField == self.passwordTextField) {
            NSLog(@"textfield is passwordTextField");
            [self animateTextField: self.passwordTextField up: YES];
        } else {
            NSLog(@"textfield is passwordConfTextField");
            [self animateTextField: self.passwordConfTextField up: YES];
        }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.nameTextField) {
        [self animateTextField: self.nameTextField up: NO];
    } else if (textField == self.phoneTextField) {
        [self animateTextField: self.phoneTextField up: NO];
    } else if (textField == self.emailTextField) {
        [self animateTextField: self.emailTextField up: NO];
    } else if (textField == self.passwordTextField) {
        [self animateTextField: self.passwordTextField up: NO];
    } else {
        [self animateTextField: self.passwordConfTextField up: NO];
    }
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    int movementDistance;
    float movementDuration;

    
    if (screenSize.height > 480.0f) {
        /*Do iPhone 5 stuff here.*/
        
        if (textField == self.nameTextField) {
            movementDistance = 0;
            movementDuration = 0.3f;
        } else if (textField == self.phoneTextField) {
            movementDistance = 0;
            movementDuration = 0.3f;
        } else if (textField == self.emailTextField) {
            movementDistance = 80;
            movementDuration = 0.3f;
        } else if(textField == self.passwordTextField) {
            movementDistance = 130;
            movementDuration = 0.3f;
        } else { //(textField == self.passwordConfTextField) {
            NSLog(@"focusing password conf");
            
            movementDistance = 180;
            movementDuration = 0.3f;
        }
    } else {
        /*Do iPhone Classic stuff here.*/
        
        if (textField == self.nameTextField) {
            movementDistance = 0;
            movementDuration = 0.3f;
        } else if (textField == self.phoneTextField) {
            movementDistance = 60;
            movementDuration = 0.3f;
        } else if (textField == self.emailTextField) {
            movementDistance = 120;
            movementDuration = 0.3f;
        } else if(textField == self.passwordTextField) {
            movementDistance = 180;
            movementDuration = 0.3f;
        } else { //(textField == self.passwordConfTextField) {
            movementDistance = 215;
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






@end
