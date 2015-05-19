//
//  MessageDetailsViewController.m
//  HomeLess
//
//  Created by Guillermo Apoj on 11/12/14.
//
//
#import "DetailsHouseViewController.h"
#import "HomeViewController.h"
#import "MessageDetailsViewController.h"
#import "SendMessageViewController.h"

@interface MessageDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *responseButton;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UILabel *otherUserLabel;
@property (strong, nonatomic) IBOutlet UILabel *HouseLabel;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UILabel *sentToOrSentByLabel;
@property NSArray *history;
@property NSString * currentUserID;
@end

@implementation MessageDetailsViewController
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onRelatedHouse:(id)sender {
    DetailsHouseViewController *vc = [[DetailsHouseViewController alloc] init];
    vc.house = self.message.houseRelated;
    self.currentUserID =[PFUser currentUser].objectId;
    if ([self.message.sender.objectId isEqualToString:self.currentUserID]) {
        vc.canEdit = YES;
    }else{
    
        vc.canEdit = NO;
    }
    [self showViewController:vc sender:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMessages];
    self.HouseLabel.text = self.message.houseRelated.title;
    self.currentUserID =[PFUser currentUser].objectId;
    if ([self.message.sender.objectId isEqualToString:self.currentUserID]) {
        self.responseButton.hidden = YES;
        self.sentToOrSentByLabel.text =@"Sent to:";
        
        self.otherUserLabel.text= self.message.receiver[@"profile"][@"name"];
    } else {
        self.responseButton.hidden = NO;
        self.sentToOrSentByLabel.text =@"Sent by:";
        self.otherUserLabel.text= self.message.sender[@"profile"][@"name"];
        if(!self.message.readed){
            self.message.readed = YES;
            [self.message saveInBackground];
        }
    }
    
    self.messageTextView.text = self.message.message;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    self.tableview.estimatedRowHeight = 60;
    
}
- (void)loadOtherUserName {
    
}
- (void)loadMessages {
    PFQuery *messagesQuery = [Message query];
    [messagesQuery whereKey:@"conversationID" equalTo:self.message.conversationID];
    
    [messagesQuery whereKey:@"objectId" notEqualTo: self.message.objectId];
    [messagesQuery includeKey:@"sender"];
    [messagesQuery includeKey:@"receiver"];
    [messagesQuery includeKey:@"houseRelated"];
    [messagesQuery findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error) {
        if(error){
            NSLog(@"Error: %@",error);
        }else{
            self.history= messages;
            [self.tableview reloadData];
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onResponse:(id)sender {
    SendMessageViewController *vc =[[SendMessageViewController alloc]init];
    vc.relatedHouse = self.message.houseRelated;
    vc.previousMessage = self.message;
    [self showViewController:vc sender:self];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.history.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message * message = self.history[indexPath.row];//
    
    UITableViewCell *cell;
    if ([self.message.sender.objectId isEqualToString:self.currentUserID]) {
        cell = [self createInboxCell:tableView message:message];
        
    } else {
        cell = [self createOutboxCell:tableView message:message];
        
    }
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Message History:";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}
- (HistoricalInboxTableViewCell *)createInboxCell:(UITableView *)tableView message:(Message *)message
{
    HistoricalInboxTableViewCell *cell = (HistoricalInboxTableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"HistoricalInboxCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"HistoricalInboxTableViewCell" bundle:nil] forCellReuseIdentifier:@"HistoricalInboxCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"HistoricalInboxCell"];
    }
    
    cell.message.text =message.message;
    
    [cell.message sizeToFit];
    
    NSDate *theDate =[message getLocalTimeDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeString = [formatter stringFromDate:theDate];
    cell.date.text = timeString;
    
    
    if(!message.readed){
        cell.date.font = [UIFont boldSystemFontOfSize:10.0];
        cell.message.font = [UIFont boldSystemFontOfSize:13.0];
    }
    else
    {
        cell.date.font = [UIFont systemFontOfSize:10.0];
        cell.message.font = [UIFont systemFontOfSize:13.0];
        
    }
    return cell;
}
- (HistoricalOutBoxTableViewCell *)createOutboxCell:(UITableView *)tableView message:(Message *)message
{
    HistoricalOutBoxTableViewCell *cell = (HistoricalOutBoxTableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"HistoricalOutBoxCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"HistoricalOutBoxTableViewCell" bundle:nil] forCellReuseIdentifier:@"HistoricalOutBoxCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"HistoricalOutBoxCell"];
    }
    
    cell.message.text =message.message;
    
     [cell.message sizeToFit];
    
    NSDate *theDate =[message getLocalTimeDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"HH:mm a"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeString = [formatter stringFromDate:theDate];
    cell.date.text = timeString;
    
    
    if(!message.readed){
        cell.date.font = [UIFont boldSystemFontOfSize:10.0];
        cell.message.font = [UIFont boldSystemFontOfSize:13.0];
    }
    else
    {
        cell.date.font = [UIFont systemFontOfSize:10.0];
        cell.message.font = [UIFont systemFontOfSize:13.0];
        
    }
    return cell;
}
@end
