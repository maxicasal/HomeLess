//
//  SendMessageViewController.m
//  HomeLess
//
//  Created by Guillermo Apoj on 11/11/14.
//
//
#import "HomeViewController.h"
#import "SendMessageViewController.h"

@interface SendMessageViewController ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *subjectTextField;
@property (strong, nonatomic) IBOutlet UILabel *houseTitleLabel;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
- (IBAction)onCancel:(id)sender;
- (IBAction)onSend:(id)sender;

@end

@implementation SendMessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.houseTitleLabel.text = self.relatedHouse.title;
    if (self.previousMessage) {
        self.subjectTextField.text = [NSString stringWithFormat:@"RE: %@",self.previousMessage.subject];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark textview
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    textView.backgroundColor = [UIColor colorWithRed:.93 green:.87 blue:.93 alpha:.5];
    textView.text = @"";
    
    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    textView.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
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



- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}

- (IBAction)onSend:(id)sender {
    Message *newMessagge = [Message object];
       if([self.messageTextView.text length]==0 ){
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"You have to write a message"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }else{
        newMessagge.message = self.messageTextView.text;
        if (![self.subjectTextField.text isEqualToString:@""]) {
            newMessagge.subject= self.subjectTextField.text;
        } else {
            newMessagge.subject = @"No subject";
        }
        
        newMessagge.readed = NO;
        newMessagge.date = [[NSDate alloc] init];
        [newMessagge setDateToGlobalTime];
        newMessagge.sender = [PFUser currentUser];
       
        newMessagge.houseRelated = self.relatedHouse;
        if (self.previousMessage) {
            newMessagge.conversationID = self.previousMessage.conversationID;
            newMessagge.numberInConversation = self.previousMessage.numberInConversation + 1;
            newMessagge.receiver = self.previousMessage.sender;

        } else {
            newMessagge.conversationID =[NSString stringWithFormat:@"%@ %@" ,self.relatedHouse.objectId, newMessagge.date];
            newMessagge.numberInConversation = 1;
             newMessagge.receiver= self.relatedHouse.owner;
        }
        
        [newMessagge saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error){
                NSLog(@"%@",error);
            }else{
                
                [self dismissViewControllerAnimated:YES completion:^{
                    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Succes"
                                                                          message:@"The message was sent"
                                                                         delegate:nil
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles: nil];
                    [myAlertView show];
                }];
            }
        }];
    }
}
@end
