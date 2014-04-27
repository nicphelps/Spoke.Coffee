//
//  MapViewController.m
//  SpokeCoffee
//
//  Created by Nicole Phelps on 4/26/14.
//  Copyright (c) 2014 Nicole Phelps. All rights reserved.
//

#import "MapViewController.h"
#import "UserClass.h"
#import "OrderViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>



#define METERS_PER_MILE 1609.344


@interface MapViewController ()

@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) MKPlacemark *placemark;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@property (strong, nonatomic) UserClass *user;
@property (strong, nonatomic) MKUserLocation *userLocation;


@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // navigation
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
    
    // init
    self.geocoder = [[CLGeocoder alloc] init];
    self.user = [UserClass getInstance];

    // map
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    
    // location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];

    // text fields
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.addressTextField.delegate = self;
    
    

}

- (void) viewDidAppear:(BOOL)animated {
    
    
    //[self.navigationController setNavigationBarHidden:YES];

}




- (void)viewWillAppear:(BOOL)animated {
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 45.5200;
    zoomLocation.longitude= -122.6819;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:viewRegion animated:YES];
}



- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    self.userLocation = userLocation;
    
    // Set map region
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 500, 500);
    [self.mapView setRegion:region animated:YES];
    
	// Center the map the first time we get a real location change.
	static dispatch_once_t centerMapFirstTime;
    
	if ((userLocation.coordinate.latitude != 0.0) && (userLocation.coordinate.longitude != 0.0)) {
		dispatch_once(&centerMapFirstTime, ^{
			[self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
		});
	}
	
	// Lookup the information for the current location of the user.
    [self.geocoder reverseGeocodeLocation:self.mapView.userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
		if ((placemarks != nil) && (placemarks.count > 0)) {
			// If the placemark is not nil then we have at least one placemark. Typically there will only be one.
			self.placemark = [placemarks objectAtIndex:0];
			
            NSLog(@"placemark: ---%@---", self.placemark);
            
            if (self.placemark != nil) {
                
                
                NSLog(@"address dict: %@", self.placemark.addressDictionary);

                
                //(NSString *)[self.placemark.addressDictionary objectForKey:@"FormattedAddressLines"]
                NSString *address = (NSString *)[self.placemark.addressDictionary objectForKey:@"Street"];
                
                address = [address stringByAppendingString:@", "];
                address = [address stringByAppendingString:(NSString *)[self.placemark.addressDictionary objectForKey:@"City"]];
                address = [address stringByAppendingString:@", "];
                address = [address stringByAppendingString:(NSString *)[self.placemark.addressDictionary objectForKey:@"State"]];
                address = [address stringByAppendingString:@" "];
                address = [address stringByAppendingString:(NSString *)[self.placemark.addressDictionary objectForKey:@"ZIP"]];
                

                
                NSLog(@"\n\n\nnew address: %@", address);

                self.addressTextField.text = (NSString *)address;
            } else {
                NSLog(@"placemark is nil");
            }
            
            
            
            if ((userLocation.coordinate.latitude != 0.0) && (userLocation.coordinate.longitude != 0.0)) {
                dispatch_once(&centerMapFirstTime, ^{
                    [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
                });
                
                self.user.latitude = [NSNumber numberWithDouble:userLocation.coordinate.latitude];
                self.user.longitude = [NSNumber numberWithDouble:userLocation.coordinate.longitude];
                
                NSLog(@"got lat: %@ and long: %@", self.user.latitude, self.user.longitude);
            }
		}
		else {
			// Handle the nil case if necessary.
		}
    }];
}

/*
- (IBAction)zoomIn:(id)sender {
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (
                                        userLocation.location.coordinate, 20000, 20000);
    [_mapView setRegion:region animated:NO];
    
}
*/




- (IBAction)touchEditButton:(id)sender {
    

    
    
}





- (IBAction)touchCoffeeButton:(id)sender {
    
    self.user.address = self.addressTextField.text;
    self.user.latitude = [[NSNumber alloc] initWithDouble:self.userLocation.coordinate.latitude];
    self.user.longitude = [[NSNumber alloc] initWithDouble:self.userLocation.coordinate.longitude];
    
        UIStoryboard *storyboard;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
        } else {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
        }
        
        OrderViewController *orderViewController = [storyboard instantiateViewControllerWithIdentifier:@"orderViewController"];
        //[self presentViewController:orderViewController animated:NO completion:nil];
        [self.navigationController pushViewController:orderViewController animated:YES];

    
        
    
}








#pragma mark - textfields / keyboard

-(void)dismissKeyboard {
    [self.addressTextField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [self.addressTextField resignFirstResponder];
    
    
    return YES;
    //return NO; // We do not want UITextField to insert line-breaks.
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"began editing");
    

    [self animateTextField: self.addressTextField up: YES];
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

    [self animateTextField: self.addressTextField up: NO];
    
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    int movementDistance;
    float movementDuration;
    
    
    if (screenSize.height > 480.0f) {
        /*Do iPhone 5 stuff here.*/
        
            movementDistance = 215;
            movementDuration = 0.3f;
        
    } else {
        /*Do iPhone Classic stuff here.*/
        

            movementDistance = 215;
            movementDuration = 0.3f;
        
    }
    
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.scrollview.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}




@end
