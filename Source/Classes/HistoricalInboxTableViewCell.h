//
//  HistoricalInboxTableViewCell.h
//  HomeLess
//
//  Created by Guillermo Apoj on 11/13/14.
//
//

#import <UIKit/UIKit.h>

@interface HistoricalInboxTableViewCell : UITableViewCell <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UITextView *message;

@end
