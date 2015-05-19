//
//  House.m
//  HomeLess
//
//  Created by Guillermo Apoj on 11/6/14.
//
//

#import "House.h"

@implementation House
@dynamic title;
@dynamic address;
@dynamic price;
@dynamic  houseDescription;
@dynamic rooms;
@dynamic  bathrooms;
@dynamic squareMeters;
@dynamic isDogAllowed;
@dynamic isCatAllowed;
@dynamic owner;
@dynamic rentOrSale;
@dynamic  withGarage;
+ (NSString*) parseClassName
{
    return @"House";
}

+(void) load
{
    [self registerSubclass];
}
@end