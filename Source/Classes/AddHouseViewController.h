//
//  AddHouseViewController.h
//  HomeLess
//
//  Created by Guillermo Apoj on 11/6/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

#import "House.h"
#import "HousePhoto.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "MyCell.h"
@interface AddHouseViewController : UIViewController{
    IBOutlet UIScrollView *scroller;
    
}
@property House* house;
@end
