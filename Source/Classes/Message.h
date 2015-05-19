//
//  Message.h
//  HomeLess
//
//  Created by Guillermo Apoj on 11/11/14.
//
//
#import "House.h"
#import <Parse/Parse.h>

@interface Message : PFObject<PFSubclassing>
@property NSString *subject;
@property NSString *message;
@property PFUser *sender;
@property PFUser *receiver;
@property House * houseRelated;
@property bool readed;
@property NSString * conversationID;
@property NSDate * date;
@property NSInteger numberInConversation;

-(NSDate *) getLocalTimeDate;


-(void) setDateToGlobalTime;

@end
