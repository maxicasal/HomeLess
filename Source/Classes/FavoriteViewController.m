#import "FavoriteViewController.h"
#import "HouseTableViewCell.h"
#import "House.h"
#import "Favorite.h"
#import "HousePhoto.h"
#import "DetailsHouseViewController.h"

@interface FavoriteViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.favorites = [NSArray array];
    [self loadFavorites];
}

-(void) loadFavorites
{
    PFQuery *favoritesQuery = [Favorite query];
    [favoritesQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [favoritesQuery includeKey:@"house"];
    [favoritesQuery findObjectsInBackgroundWithBlock:^(NSArray *favorites, NSError *error) {
        if(error){
            NSLog(@"Error: %@",error);
        }else{
            self.favorites = favorites;
            if (self.favorites.count > 0) {
             [self.tableView reloadData];
            }
        }
    }];
}

- (IBAction)onHomeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favorites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseCell"];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HouseTableViewCell" bundle:nil] forCellReuseIdentifier:@"HouseCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"HouseCell"];
    }
    Favorite * favorite = [self.favorites objectAtIndex:indexPath.row];
    cell.label.text = favorite.house.title;
    [self setPhotoToCell:favorite.house cell:cell];
    return cell;
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Favorite *favoriteToDelete = [Favorite object];
    favoriteToDelete = [self.favorites objectAtIndex:indexPath.row];
    [favoriteToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
    NSMutableArray *aux = [NSMutableArray arrayWithArray:self.favorites];
    [aux removeObjectAtIndex:indexPath.row];
    self.favorites = [NSArray arrayWithArray:aux];
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailsHouseViewController *vc = [[DetailsHouseViewController alloc] init];
    vc.canEdit = NO;
    Favorite * fav =self.favorites[indexPath.row];
    vc.house =fav.house;
    [self showViewController:vc sender:self];
    
}
@end
