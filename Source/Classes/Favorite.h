#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "House.h"
@interface Favorite : PFObject <PFSubclassing>
@property House *house;
@property PFUser *user;
@end
