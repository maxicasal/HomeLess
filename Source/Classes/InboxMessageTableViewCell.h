//
//  MessageTableViewCell.h
//  HomeLess
//
//  Created by Guillermo Apoj on 11/12/14.
//
//

#import <UIKit/UIKit.h>

@interface InboxMessageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UILabel *date;

@end
