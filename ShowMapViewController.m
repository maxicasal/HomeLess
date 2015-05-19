//
//  ShowMapViewController.m
//  HomeLess
//
//  Created by Guillermo Apoj on 11/25/14.
//
//
#import <CoreLocation/CLLocation.h>



#import "ShowMapViewController.h"

@interface ShowMapViewController ()

@end

@implementation ShowMapViewController

- (void)addAnotation:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate;
    point.title = @"Here is the house of your dreams";
    [self.mapView addAnnotation:point];
}

- (void)addHouseAnnotation:(NSString*)address
{
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        CLLocationCoordinate2D coordinate ;
        if(!error){
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                CLLocation *location = placemark.location;
                coordinate = location.coordinate;
                [self addAnotation:coordinate];
                
            }
            
        }else{
            [geocoder geocodeAddressString: @"Paraguay 2141, Montevideo, Uruguay" completionHandler:^(NSArray *placemarks, NSError *error) {
                CLLocationCoordinate2D coordinate ;
                if(!error){
                    if ([placemarks count] > 0) {
                        CLPlacemark *placemark = [placemarks objectAtIndex:0];
                        CLLocation *location = placemark.location;
                        coordinate = location.coordinate;
                        [self addAnotation:coordinate];
                    } }}];
        }
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self addHouseAnnotation:self.house.address];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
