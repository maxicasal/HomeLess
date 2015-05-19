//
//  ShowMapViewController.h
//  HomeLess
//
//  Created by Guillermo Apoj on 11/25/14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "House.h"

@interface ShowMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property House * house;

@end
