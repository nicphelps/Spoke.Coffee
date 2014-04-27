//
//  MapViewController.h
//  SpokeCoffee
//
//  Created by Nicole Phelps on 4/26/14.
//  Copyright (c) 2014 Nicole Phelps. All rights reserved.
//

#import "ViewController.h"

#import <MapKit/MapKit.h>


@interface MapViewController : UIViewController
<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)touchEditButton:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
- (IBAction)touchCoffeeButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@end
