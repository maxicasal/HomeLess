//
//  SendMessageViewController.h
//  HomeLess
//
//  Created by Guillermo Apoj on 11/11/14.
//
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import "House.h"


@interface SendMessageViewController : UIViewController
@property House *relatedHouse;
@property Message * previousMessage;
@end
