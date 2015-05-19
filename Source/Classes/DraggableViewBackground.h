
#import <UIKit/UIKit.h>
#import "DraggableView.h"
// Protocol definition starts here
@protocol DraggableViewBackgoundDelegate <NSObject>
@required
- (void) housesCharged;
-(void)housesFinished:(NSString*)string ;
@end
// Protocol Definition ends here
@interface DraggableViewBackground : UIView <DraggableViewDelegate>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;
- (void)loadData;
@property (retain,nonatomic)NSArray* houseCards;
@property (retain,nonatomic)NSMutableArray* allCards; 
@property (weak) id <DraggableViewBackgoundDelegate> delegate;
@property NSInteger houseIndex;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
