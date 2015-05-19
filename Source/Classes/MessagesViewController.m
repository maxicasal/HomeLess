
#import "MessagesViewController.h"
#import "InboxMessageTableViewCell.h"
#import "OutBoxTableViewCell.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "Message.h"
#import "HomeViewController.h"
#import "MessageDetailsViewController.h"
@interface MessagesViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *messages;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
//@property (strong, nonatomic) IBOutlet UILabel *folderLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *messageButton;
@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.inbox) {
        [self.messageButton setTitle:@"Go to sent"];
    } else {
        [self.messageButton setTitle:@"Go to inbox"];
    }
}

- (IBAction)changeFolder:(id)sender {
    if (self.inbox) {
        MessagesViewController *vc = [[MessagesViewController alloc] init];
        vc.inbox = NO;
        [self showViewController:vc sender:self];
        
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}
- (void)loadMessages {
    PFQuery *messagesQuery = [Message query];
    if (self.inbox) {
        [messagesQuery whereKey:@"receiver" equalTo:[PFUser currentUser]];
    } else {
        [messagesQuery whereKey:@"sender" equalTo:[PFUser currentUser]];
    }
    [messagesQuery includeKey:@"sender"];
    [messagesQuery includeKey:@"receiver"];
    [messagesQuery includeKey:@"houseRelated"];
    [messagesQuery findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error) {
        if(error){
            NSLog(@"Error: %@",error);
        }else{
            self.messages= messages;
            [self.tableView reloadData];
        }
    }];
}

- (IBAction)onHomePressed:(id)sender {
    if (!self.inbox) {
        HomeViewController *detailsViewController = [[HomeViewController alloc]init];
        [self showViewController:detailsViewController sender:self];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadMessages];
    if (self.inbox) {
        [self.messageButton setTitle:@"Go to sent"];
//        self.navigationItem.title = @"Received messages";
    } else {
        [self.messageButton setTitle:@"Go to inbox"];
//        self.navigationItem.title = @"Sent messages";
    }
}
#pragma mark - Table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}
-(Message*)mensajePrueba{
    Message * msg =  [Message object];
    msg.subject = @"prueba de asunto";
    msg.date=[[NSDate alloc] init];
    msg.readed = NO;
    return msg;
}
- (InboxMessageTableViewCell *)createInboxCell:(UITableView *)tableView message:(Message *)message
{
    InboxMessageTableViewCell *cell = (InboxMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"InboxMessageCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"InboxMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"InboxMessageCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"InboxMessageCell"];
    }
    
    cell.message.text =message.subject;
    
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
    } else
    {
        cell.date.font = [UIFont systemFontOfSize:10.0];
        cell.message.font = [UIFont systemFontOfSize:13.0];
    }
    return cell;
}
- (OutBoxTableViewCell *)createOutboxCell:(UITableView *)tableView message:(Message *)message
{
    OutBoxTableViewCell *cell = (OutBoxTableViewCell *)[tableView dequeueReusableCellWithIdentifier: @"OutBoxMessageCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"OutBoxTableViewCell" bundle:nil] forCellReuseIdentifier:@"OutBoxMessageCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"OutBoxMessageCell"];
    }
    
    cell.message.text =message.subject;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message * message = self.messages[indexPath.row];//
    UITableViewCell *cell;
    if (self.inbox) {
        cell = [self createInboxCell:tableView message:message];
    } else {
        cell = [self createOutboxCell:tableView message:message];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDetailsViewController *vc = [[MessageDetailsViewController alloc] init];
    vc.message = self.messages[indexPath.row];
    [self showViewController:vc sender:self];
}
@end
