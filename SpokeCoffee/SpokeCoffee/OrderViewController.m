//
//  OrderViewController.m
//  SpokeCoffee
//
//  Created by Nicole Phelps on 4/26/14.
//  Copyright (c) 2014 Nicole Phelps. All rights reserved.
//

#import "OrderViewController.h"

#import "UserClass.h"

@interface OrderViewController () {
}

@property UserClass *user;

@end

@implementation OrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.user = [UserClass getInstance];
}


@end
