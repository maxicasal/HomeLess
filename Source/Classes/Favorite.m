#import "Favorite.h"

@implementation Favorite
@dynamic user;
@dynamic house;

+ (NSString*) parseClassName
{
    return @"Favorite";
}

+(void) load
{
    [self registerSubclass];
}
@end