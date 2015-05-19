//
//  HistoricalOutBoxTableViewCell.h
//  HomeLess
//
//  Created by Guillermo Apoj on 11/13/14.
//
//

#import <UIKit/UIKit.h>

@interface HistoricalOutBoxTableViewCell : UITableViewCell<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *message;
@property (strong, nonatomic) IBOutlet UILabel *date;

@end
