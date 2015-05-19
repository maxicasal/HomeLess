#import "UserDetailsViewController.h"
#import "AddHouseViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "House.h"
#import "HousePhoto.h"
#import "HouseTableViewCell.h"
#import "DetailsHouseViewController.h"

@interface UserDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateBirthLabel;
@property (strong, nonatomic) IBOutlet UILabel *relashionShipLabel;
@property NSArray *houses;
- (IBAction)addHouse:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation UserDetailsViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"User Profile";
    }
    return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshHouses];
}
#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.houses.count;
}

- (void)setPhotoToCell:(House *)house cell:(HouseTableViewCell *)cell {
    if (house) {
        PFQuery *photoQuery = [HousePhoto query];
        [photoQuery whereKey:@"house"equalTo:house];
        [photoQuery whereKey:@"isMain" equalTo:[NSNumber numberWithBool:YES]];
        [photoQuery findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
            if(error){
                NSLog(@"Error: %@",error);
            }else{
                HousePhoto * photo = photos[0];
                PFFile *file =  photo.parsePhoto;
                if (file != nil) {
                    NSError *error;
                    NSData * data = [file getData: &error];
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:data];
                        cell.image.image = image;
                        cell.image.contentMode= UIViewContentModeScaleAspectFit;
                    }else{
                        NSLog(@"%@",error);
                    }
                }
            }
        }];
    }else{
        cell.image.image = [UIImage imageNamed:@"homeImg"];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseCell"];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HouseTableViewCell" bundle:nil] forCellReuseIdentifier:@"HouseCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"HouseCell"];
    }
    House * house = self.houses[indexPath.row];
    cell.label.text = house.title;
    [self setPhotoToCell:house cell:cell];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailsHouseViewController *vc = [[DetailsHouseViewController alloc] init];
    vc.canEdit = YES;
    vc.house = self.houses[indexPath.row];
    [self showViewController:vc sender:self];
    
}
- (void) refreshHouses
{
    PFQuery *housesQuery = [House query];
    [housesQuery whereKey:@"owner" equalTo:[PFUser currentUser]];
    [housesQuery findObjectsInBackgroundWithBlock:^(NSArray *houses, NSError *error) {
        if(error){
            NSLog(@"Error: %@",error);
        }else{
            self.houses = houses;
            [self.tableView reloadData];
        }
    }];
}
- (IBAction)onHomeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Actions

- (void)logoutButtonAction:(id)sender {
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Data

- (void)_loadData {
    if ([PFUser currentUser]) {
        [self _updateProfileData];
    }
    
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            NSString *facebookID = userData[@"id"];
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
            
            if (facebookID) {
                userProfile[@"facebookId"] = facebookID;
            }
            
            NSString *name = userData[@"name"];
            if (name) {
                userProfile[@"name"] = name;
            }
            
            NSString *location = userData[@"location"][@"name"];
            if (location) {
                userProfile[@"location"] = location;
            }
            
            NSString *gender = userData[@"gender"];
            if (gender) {
                userProfile[@"gender"] = gender;
            }
            
            NSString *birthday = userData[@"birthday"];
            if (birthday) {
                userProfile[@"birthday"] = birthday;
            }
            
            NSString *relationshipStatus = userData[@"relationship_status"];
            if (relationshipStatus) {
                userProfile[@"relationship"] = relationshipStatus;
            }
            
            userProfile[@"pictureURL"] = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
            
            [self _updateProfileData];
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) {
            [self logoutButtonAction:nil];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

- (void)_updateProfileData {
    NSString *location = [PFUser currentUser][@"profile"][@"location"];
    if (location) {
        self.locationLabel.text = location;
    }else{
        self.locationLabel.text = @"N/A";
    }
    
    NSString *gender = [PFUser currentUser][@"profile"][@"gender"];
    if (gender) {
        self.genderLabel.text = gender;
    }else{
        self.genderLabel.text = @"N/A";
    }
    
    NSString *birthday = [PFUser currentUser][@"profile"][@"birthday"];
    if (birthday) {
        self.dateBirthLabel.text = birthday;
    }else{
        self.dateBirthLabel.text = @"N/A";
    }
    
    NSString *relationshipStatus = [PFUser currentUser][@"profile"][@"relationship"];
    if (relationshipStatus) {
        self.relashionShipLabel.text = relationshipStatus;
    }else{
        self.relashionShipLabel.text = @"N/A";
    }
    
    NSString *name = [PFUser currentUser][@"profile"][@"name"];
    if (name) {
        self.nameLabel.text = name;
    }
    
    NSString *userProfilePhotoURLString = [PFUser currentUser][@"profile"][@"pictureURL"];
    if (userProfilePhotoURLString) {
        NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (connectionError == nil && data != nil) {
                                       self.userImage.image = [UIImage imageWithData:data];
                                       self.userImage.layer.cornerRadius = 8.0f;
                                       self.userImage.layer.masksToBounds = YES;
                                   } else {
                                       NSLog(@"Failed to load profile photo.");
                                   }
                               }];
    }
}

- (IBAction)addHouse:(id)sender {
    AddHouseViewController *vc = [[AddHouseViewController alloc] init];
    vc.house = nil;
    [self showViewController:vc sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    House *houseToDelete = [House object];
    houseToDelete = [self.houses objectAtIndex:indexPath.row];
    [houseToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
    NSMutableArray *aux = [NSMutableArray arrayWithArray:self.houses];
    [aux removeObjectAtIndex:indexPath.row];
    self.houses = [NSArray arrayWithArray:aux];
    [self.tableView reloadData];
}
@end
