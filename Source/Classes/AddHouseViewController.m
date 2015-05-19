#import "AddHouseViewController.h"

@interface AddHouseViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *addOrEditLabel;

@property (weak, nonatomic) IBOutlet UIImageView *mainPhoto;
@property (weak, nonatomic) IBOutlet UITextField *PriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *rentOrSaleSegmentControl;
@property (strong, nonatomic) IBOutlet UISlider *roomsSlider;
@property (strong, nonatomic) IBOutlet UISlider *squareMetersSlider;
@property (strong, nonatomic) IBOutlet UISlider *bathroomsSlider;
@property (strong, nonatomic) IBOutlet UILabel *roomsLabel;
@property (strong, nonatomic) IBOutlet UILabel *squareMetersLabel;
@property (strong, nonatomic) IBOutlet UILabel *bathroomsLabel;
@property (weak, nonatomic) IBOutlet UITextView *desc;
@property (weak, nonatomic) IBOutlet UILabel *petLabel;
@property BOOL isDogAllowed;
@property BOOL isCatAllowed;
@property (weak, nonatomic) IBOutlet UISegmentedControl *garageSegmentControl;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollection;
@property NSMutableArray *photos;
@end
@implementation AddHouseViewController

- (void)viewWithHouse {
    self.titleTextField.text= self.house.title;
    self.addressTextField.text=self.house.address;
    self.PriceTextField.text =[NSString stringWithFormat:@"%lu",  self.house.price];
    self.desc.text = self.house.houseDescription;
    self.bathroomsLabel.text =[NSString stringWithFormat:@"%lu",  self.house.bathrooms];
    self.roomsLabel.text =[NSString stringWithFormat:@"%lu",  self.house.rooms];
    self.squareMetersLabel.text =[NSString stringWithFormat:@"%lu",  self.house.squareMeters];
    self.isCatAllowed=self.house.isCatAllowed;
    self.isDogAllowed=  self.house.isDogAllowed ;
    [self updatePetAllowedLabel];
    self.addOrEditLabel.text = @"Edit House";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photos = [NSMutableArray array];
    [self.myCollection registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"] ;
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 1350)];
    self.desc.delegate = self;
    if (self.house) {
      
        [self viewWithHouse];
    }
}

- (IBAction)onAddPhotos:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count
    ;
}

- (MyCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    if (self.photos.count > 0) {
        cell.image.image = [self.photos objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (self.mainPhoto.image) {
        [self.photos addObject:image];
        [self.myCollection reloadData];
    }else{
        self.mainPhoto.image = image;
        self.mainPhoto.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)roomsValueChanged:(id)sender {
    int sliderVal =0;
    sliderVal = self.roomsSlider.value;
    self.roomsLabel.text= [NSString stringWithFormat:@"%d", sliderVal];
}
- (IBAction)squareMetersChanged:(id)sender {
    int sliderVal =0;
    sliderVal = self.squareMetersSlider.value*25;
    self.squareMetersLabel.text= [NSString stringWithFormat:@"%d", sliderVal];
}
- (IBAction)bathroomsChanged:(id)sender {
    int sliderVal =0;
    sliderVal = self.bathroomsSlider.value;
    self.bathroomsLabel.text= [NSString stringWithFormat:@"%d", sliderVal];
}
- (IBAction)onHomeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSave:(id)sender {
    House *newHouse;
    if (self.house) {
        newHouse=self.house;
    } else {
        newHouse= [House object];

    }
    newHouse.owner = [PFUser currentUser];
    newHouse.title = self.titleTextField.text;
    newHouse.address = self.addressTextField.text;
    newHouse.price = [self.PriceTextField.text integerValue];
    newHouse.houseDescription = self.desc.text;
    newHouse.bathrooms = [self.bathroomsLabel.text integerValue];
    newHouse.rooms = [self.roomsLabel.text integerValue];
    newHouse.squareMeters =[self.squareMetersLabel.text integerValue];
    newHouse.isCatAllowed = self.isCatAllowed;
    newHouse.isDogAllowed = self.isDogAllowed;
    if (self.rentOrSaleSegmentControl.selectedSegmentIndex ==0) {
        newHouse.rentOrSale = @"Rent";
    } else {
        newHouse.rentOrSale = @"Sale";
    }
    if (self.garageSegmentControl.selectedSegmentIndex == 0) {
        
        newHouse.withGarage = YES;
    } else {
        newHouse.withGarage = NO;
    }
    
    [newHouse saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }else{
            
            [self savePhotos:newHouse];
        }
    }];
    
}

-(void) savePhotos: (House *) house
{
    NSData* data;
    HousePhoto *housePhoto = [HousePhoto object];
    housePhoto.house = house;
    if (self.mainPhoto.image) {
        data = UIImageJPEGRepresentation(self.mainPhoto.image, 0.5f);
    }else{
        data = UIImageJPEGRepresentation([UIImage imageNamed:@"homeImg"], 0.5f);
    }
    PFFile *imageFile = [PFFile fileWithData:data];
    housePhoto.parsePhoto = imageFile;
    housePhoto.isMain = YES;
    [housePhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }else{
            if (self.photos.count > 0) {
                [self addAdditionalPhotos:house];
            }else{
                [self dismissViewControllerAnimated:YES completion:^{
                    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Succes" message:@"The house was saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [myAlertView show];
                }];
            }
        }
    }];
}

-(void) addAdditionalPhotos: (House *) house
{
    for (UIImage *image in self.photos) {
        HousePhoto *housePhoto = [HousePhoto object];
       housePhoto.house = house;
        NSData* data = UIImageJPEGRepresentation(image, 0.5f);
        PFFile *imageFile = [PFFile fileWithData:data];
        housePhoto.parsePhoto = imageFile;
        housePhoto.isMain = NO;
        [housePhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error){
                NSLog(@"%@",error);
            }else{
                if ([self.photos indexOfObject:image] == self.photos.count-1) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Succes" message:@"The house was saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [myAlertView show];
                    }];
                }
            }
        }];
    }
}

- (IBAction)onCatPressed:(id)sender {
    self.isCatAllowed = !self.isCatAllowed;
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

#pragma mark textview
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"textViewShouldBeginEditing:");
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
       textView.backgroundColor = [UIColor colorWithRed:.93 green:.87 blue:.93 alpha:.5];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
  
    textView.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"textViewDidEndEditing:");
    [self.view endEditing:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 140){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}
@end
