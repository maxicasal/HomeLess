
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "House.h"
@interface HousePhoto : PFObject <PFSubclassing>
@property NSString* title;
@property House *house;
@property UIImageView *myPhoto;
@property PFFile *parsePhoto;
@property BOOL isMain;
@end
