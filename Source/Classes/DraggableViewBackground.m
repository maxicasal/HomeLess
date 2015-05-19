
#import "DraggableViewBackground.h"
#import "DetailsHouseViewController.h"
#import "House.h"
#import "HousePhoto.h"
#import "Favorite.h"
#import "Filter.h"

@implementation DraggableViewBackground{
    NSInteger cardsLoadedIndex;
    NSMutableArray *loadedCards;
    UIButton* checkButton;
    UIButton* xButton;
}
static const int MAX_BUFFER_SIZE = 2;
static const float CARD_HEIGHT = 300;
static const float CARD_WIDTH = 260;

@synthesize houseCards;
@synthesize allCards;

- (void)loadData
{
    [self.delegate housesFinished:@"Loading data"];
    [self.activityIndicator startAnimating];
    
    PFQuery *filters = [Filter query];
    [filters whereKey:@"owner" equalTo:[PFUser currentUser]];
    [filters findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                [self loadHousesFromFilter: objects.firstObject];
            }else{
                [self loadAllHouses];
            }
        }else{
            [self.activityIndicator stopAnimating];
            [self.delegate housesFinished:@"Connection error"];
        }
    }];
    loadedCards = [[NSMutableArray alloc] init];
    allCards = [[NSMutableArray alloc] init];
    cardsLoadedIndex = 0;
    self.houseIndex = 0;
}

-(void) loadHousesFromFilter: (Filter*) filter{
    PFQuery *housesQuery = [House query];
    [housesQuery whereKey:@"owner" notEqualTo:[PFUser currentUser]];
    [housesQuery includeKey:@"owner"];
    [housesQuery whereKey:@"bathrooms" lessThanOrEqualTo:[NSNumber numberWithLong:filter.bathroomsHigh]];
    [housesQuery whereKey:@"rooms" lessThanOrEqualTo:[NSNumber numberWithLong:filter.roomsHigh]];
    [housesQuery whereKey:@"squareMeters" lessThanOrEqualTo:[NSNumber numberWithLong:filter.squareMetersHigh]];
    [housesQuery whereKey:@"bathrooms" greaterThanOrEqualTo:[NSNumber numberWithLong:filter.bathroomsLow]];
    [housesQuery whereKey:@"rooms" greaterThanOrEqualTo:[NSNumber numberWithLong:filter.roomsLow]];
    [housesQuery whereKey:@"squareMeters" greaterThanOrEqualTo:[NSNumber numberWithLong:filter.squareMetersLow]];
    [housesQuery whereKey:@"rentOrSale" equalTo:filter.rentOrSale];
    [housesQuery whereKey:@"withGarage" equalTo:[NSNumber numberWithBool:filter.withGarage]];
    [housesQuery findObjectsInBackgroundWithBlock:^(NSArray *houses, NSError *error) {
        if(error){
            [self.activityIndicator stopAnimating];
            [self.delegate housesFinished:@"Connection error"];
            NSLog(@"Error: %@",error);
        }else{
            houseCards  = houses;
            [self loadPhotos];
        }
    }];
}

- (void)loadAllHouses
{
    PFQuery *housesQuery = [House query];
    [housesQuery whereKey:@"owner" notEqualTo:[PFUser currentUser]];
    [housesQuery includeKey:@"owner"];
    [housesQuery findObjectsInBackgroundWithBlock:^(NSArray *houses, NSError *error) {
        if(error){
            [self.activityIndicator stopAnimating];
            [self.delegate housesFinished:@"Connection error"];
            NSLog(@"Error: %@",error);
        }else{
            houseCards  = houses;
            [self loadPhotos];
        }
    }];
}

-(void)loadPhotos{
    PFQuery *photoQuery = [HousePhoto query];
    [photoQuery whereKey:@"house"containedIn: houseCards];
    [photoQuery whereKey:@"isMain" equalTo:[NSNumber numberWithBool:YES]];
    [photoQuery includeKey:@"house"];
    [photoQuery findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
        if(error){
            [self.activityIndicator stopAnimating];
            [self.delegate housesFinished:@"Connection error"];
            NSLog(@"Error: %@",error);
        }else{
            houseCards  = photos;
            [self loadCards];
            [self.activityIndicator stopAnimating];
        }
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
        [self setupView];
    }
    return self;
}
-(void)setupView
{
    xButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 415, 75, 75)];
    [xButton setImage:[UIImage imageNamed:@"xButton"] forState:UIControlStateNormal];
    [xButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
    checkButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 415, 75, 75)];
    [checkButton setImage:[UIImage imageNamed:@"checkButton"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(80, 150, 150, 150)];
    self.activityIndicator.backgroundColor = [UIColor colorWithRed:0.75 green:0.92 blue:0.83 alpha:1];
    self.activityIndicator.transform = CGAffineTransformMakeScale(1.75, 1.75);
    [self addSubview:self.activityIndicator];
    [self bringSubviewToFront:self.activityIndicator];
    [self addSubview:xButton];
    [self addSubview:checkButton];
}

-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
    DraggableView *draggableView = [[DraggableView alloc]initWithFrame:CGRectMake(30, 100, CARD_WIDTH, CARD_HEIGHT)];
    HousePhoto *photo = [houseCards objectAtIndex:index];
    PFFile *file =  photo.parsePhoto;
    if (file != nil) {
        NSError *error;
        NSData * data = [file getData: &error];
        if (!error) {
            draggableView.imageHouse.image = [UIImage imageWithData:data];
            draggableView.imageHouse.contentMode = UIViewContentModeScaleAspectFit;
        }
    }
    draggableView.delegate = self;
    draggableView.information.text =photo.house.title;
    return draggableView;
}

-(void)loadCards
{
    if([houseCards count] > 0) {
        NSInteger numLoadedCardsCap =(([houseCards count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[houseCards count]);
        for (int i = 0; i<[houseCards count]; i++) {
            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [allCards addObject:newCard];
            if (i<numLoadedCardsCap) {
                [loadedCards addObject:newCard];
            }
        }
        for (int i = 0; i<[loadedCards count]; i++) {
            if (i>0) {
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex++;
        }
        [self.delegate housesCharged];
    }else{
        [self.activityIndicator stopAnimating];
        [self.delegate housesFinished:@"there are no houses that pass the filter"];
    }
}

-(void)cardSwipedLeft:(UIView *)card;
{
    [loadedCards removeObjectAtIndex:0];
    if (cardsLoadedIndex < [allCards count]) {
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    self.houseIndex++;
    if (self.houseIndex == [self.houseCards count]) {
        [self.delegate housesFinished:@"No more houses to show"];
    }
}

-(void)cardSwipedRight:(UIView *)card
{
    [self addFavorite];
    [loadedCards removeObjectAtIndex:0];
    if (cardsLoadedIndex < [allCards count]) {
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    self.houseIndex++;
    if (self.houseIndex == [self.houseCards count]) {
        [self.delegate housesFinished:@"No more houses to show"];
    }
}
-(void)addFavorite{
    Favorite *  favorite=[Favorite object];
    favorite.user = [PFUser currentUser];
    HousePhoto *photo = [houseCards objectAtIndex:self.houseIndex];
    favorite.house = photo.house;
    [favorite saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(error){
            NSLog(@"%@",error);
        }
    }];
}
-(void)swipeRight
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView rightClickAction];
}

-(void)swipeLeft
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView leftClickAction];
}
@end
