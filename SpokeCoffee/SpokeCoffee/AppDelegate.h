//
//  AppDelegate.h
//  SpokeCoffee
//
//  Created by Nicole Phelps on 4/25/14.
//  Copyright (c) 2014 Nicole Phelps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "MapViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MapViewController *mapViewController;
@property (nonatomic, retain) CLLocationManager *locationManager;

@end
