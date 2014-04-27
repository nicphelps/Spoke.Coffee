//
//  SuccessViewController.m
//  SpokeCoffee
//
//  Created by Nicole Phelps on 4/27/14.
//  Copyright (c) 2014 Nicole Phelps. All rights reserved.
//

#import "SuccessViewController.h"

#import "MapViewController.h"

@interface SuccessViewController ()

@end

@implementation SuccessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)touchOkayButton:(id)sender {
    
    
    UIStoryboard *storyboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    }
    
    MapViewController *mapViewController = [storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
    //[self presentViewController:mapViewController animated:NO completion:nil];
    
    [self.navigationController pushViewController:mapViewController animated:YES];

}
@end
