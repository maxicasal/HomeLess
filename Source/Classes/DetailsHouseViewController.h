#import <UIKit/UIKit.h>
#import "House.h"
#import "HousePhoto.h"
#import "ShowMapViewController.h"

@interface DetailsHouseViewController : UIViewController
{
   
  
    IBOutlet UIScrollView *scroller;
  //  __weak IBOutlet UIBarButtonItem *editButton;
}
@property House * house;
@property (strong, nonatomic) IBOutlet UILabel *housetitle;
@property (strong, nonatomic) IBOutlet UITextView *desc;
@property (strong, nonatomic) IBOutlet UITextField *rooms;
@property (strong, nonatomic) IBOutlet UITextField *squareMeters;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UITextField *price;
@property (strong, nonatomic) IBOutlet UITextField *baths;
@property (strong, nonatomic) IBOutlet UIImageView *garage;
@property (strong, nonatomic) IBOutlet UIImageView *cat;

@property (strong, nonatomic) IBOutlet UIImageView *dog;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UITextField *address;

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property bool canEdit;
//@property (strong, nonatomic) IBOutlet UIButton *editButton;
@end
