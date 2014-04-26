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

@property STPView* stripeView;

@end
