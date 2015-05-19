//
//  Filter.m
//  HomeLess
//
//  Created by Maxi Casal on 11/15/14.
//
//

#import "Filter.h"

@implementation Filter

@dynamic owner;
@dynamic rentOrSale;
@dynamic priceLow;
@dynamic roomsLow;
@dynamic bathroomsLow;
@dynamic squareMetersLow;
@dynamic priceHigh;
@dynamic roomsHigh;
@dynamic bathroomsHigh;
@dynamic squareMetersHigh;
@dynamic dogAllowed;
@dynamic catAllowed;
@dynamic withGarage;


+ (NSString*) parseClassName
{
    return @"Filter";
}

+(void) load
{
    [self registerSubclass];
}
@end