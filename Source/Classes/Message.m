//
//  Message.m
//  HomeLess
//
//  Created by Guillermo Apoj on 11/11/14.
//
//

#import "Message.h"

@implementation Message
@dynamic  subject;
@dynamic  message;
@dynamic  sender;
@dynamic  receiver;
@dynamic  houseRelated;
@dynamic  readed;
@dynamic  conversationID;
@dynamic  date;
@dynamic  numberInConversation;
+ (NSString*) parseClassName
{
    return @"Message";
}

+(void) load
{
    [self registerSubclass];
}
-(NSDate *) getLocalTimeDate{
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: self.date];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self.date];
}



-(void) setDateToGlobalTime{
     self.date = [[NSDate alloc] init];
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: self.date];
    self.date=[NSDate dateWithTimeInterval: seconds sinceDate: self.date];
}

@end
