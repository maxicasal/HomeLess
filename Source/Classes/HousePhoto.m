
#import "HousePhoto.h"

@implementation HousePhoto
@dynamic title;
@dynamic house;
@dynamic myPhoto;
@dynamic isMain;

+ (NSString*) parseClassName
{
    return @"HousePhoto";
}

+(void) load
{
    [self registerSubclass];
}
@end