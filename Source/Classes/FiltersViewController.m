#import "FiltersViewController.h"
#import "UserDetailsViewController.h"
#import "FiltersViewController.h"
#import "HomeViewController.h"
#import "DWBubbleMenuButton.h"
#import "HomeViewController.h"
#import "DraggableViewBackground.h"
#import "UserDetailsViewController.h"
#import "FiltersViewController.h"
#import "DetailsHouseViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "DWBubbleMenuButton.h"
#import "Filter.h"

@interface FiltersViewController ()
@property (weak, nonatomic) IBOutlet UILabel *petLabel;
@property BOOL isDogAllowed;
@property BOOL isCatAllowed;
@property (weak, nonatomic) IBOutlet UITextField *roomLow;
@property (weak, nonatomic) IBOutlet UITextField *roomHigh;
@property (weak, nonatomic) IBOutlet UITextField *sqrLow;
@property (weak, nonatomic) IBOutlet UITextField *sqrHigh;
@property (weak, nonatomic) IBOutlet UITextField *priceHigh;
@property (weak, nonatomic) IBOutlet UITextField *priceLow;
@property (weak, nonatomic) IBOutlet UITextField *bathLow;
@property (weak, nonatomic) IBOutlet UITextField *bathHigh;
@property (weak, nonatomic) IBOutlet UISegmentedControl *garageSegmented;
@property (strong, nonatomic) IBOutlet UISegmentedControl *rentOrSaleSegmented;
@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isCatAllowed = false;
    self.isDogAllowed = false;
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 1150)];
}

- (IBAction)onSaveButtonPressed:(id)sender {
    PFQuery *filterQuery = [Filter query];
    [filterQuery whereKey:@"owner" equalTo:[PFUser currentUser]];
    [filterQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }else
        {
            Filter *newFilter = [Filter object];
            if (objects.count>0)
            {
                newFilter = objects.firstObject;
            }
            
            newFilter.owner = [PFUser currentUser];
            
            if (![self.roomLow.text isEqualToString:@""]) {
                newFilter.roomsLow = [self.roomLow.text integerValue];
            } else {
                newFilter.roomsLow = NSIntegerMin;
            }
            if (![self.roomHigh.text isEqualToString:@""]) {
                newFilter.roomsHigh = [self.roomHigh.text integerValue];
            } else {
                newFilter.roomsHigh = NSIntegerMax;
            }
           
            if (![self.sqrLow.text isEqualToString:@""]) {
                newFilter.squareMetersLow = [self.sqrLow.text integerValue];

            } else {
                newFilter.squareMetersLow = NSIntegerMin;
            }
            if (![self.sqrHigh.text isEqualToString:@""]) {
                newFilter.squareMetersHigh = [self.sqrHigh.text integerValue];
            } else {
                newFilter.squareMetersHigh = NSIntegerMax;
            }
            
            if (![self.priceLow.text isEqualToString:@""]) {
                newFilter.priceLow = [self.priceLow.text integerValue];
                
            } else {
                newFilter.priceLow = NSIntegerMin;
            }
            if (![self.priceHigh.text isEqualToString:@""]) {
                newFilter.priceHigh = [self.priceHigh.text integerValue];
            } else {
                newFilter.priceHigh = NSIntegerMax;
            }
            if (![self.bathLow.text isEqualToString:@""]) {
                newFilter.bathroomsLow = [self.bathLow.text integerValue];
                
            } else {
                newFilter.bathroomsLow= NSIntegerMin;
            }
            if (![self.bathHigh.text isEqualToString:@""]) {
                newFilter.bathroomsHigh = [self.bathHigh.text integerValue];

            } else {
                newFilter.bathroomsHigh = NSIntegerMax;
            }
           
            newFilter.catAllowed = self.isCatAllowed;
            newFilter.dogAllowed =self.isDogAllowed;
            newFilter.withGarage = self.garageSegmented.selectedSegmentIndex == 0;
            if (self.rentOrSaleSegmented.selectedSegmentIndex==0) {
                newFilter.rentOrSale = @"Rent";
            } else {
                 newFilter.rentOrSale = @"Sale";
            }
            [newFilter saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(error){
                    NSLog(@"%@",error);
                }else{
                
                    HomeViewController  * vc=   [[HomeViewController alloc] init];
                   [self showViewController:vc sender:self];
                }
            }];
        }
    }];
}

- (IBAction)onCatPressed:(id)sender {
    self.isCatAllowed = ! self.isCatAllowed;
    [self updatePetAllowedLabel];
}
- (IBAction)onDogPressed:(id)sender {
    self.isDogAllowed = !self.isDogAllowed;
    [self updatePetAllowedLabel];
}

-(void) updatePetAllowedLabel
{
    if (self.isDogAllowed && self.isCatAllowed) {
        self.petLabel.text =@"Cat & Dog";
    }else if (self.isDogAllowed || self.isCatAllowed) {
        self.petLabel.text =@"";
        if (self.isCatAllowed) {
            self.petLabel.text =@"Cat";
        }
        if(self.isDogAllowed){
            self.petLabel.text =@"Dog";
        }
    }else
    {
        self.petLabel.text =@"";
    }
}

- (IBAction)onHomePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}
@end
