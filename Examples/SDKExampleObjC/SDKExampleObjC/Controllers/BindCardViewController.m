//
//  BindCardViewController.m
//  SDKExampleObjC
//
//  Created by Guilherme Rambo on 17/05/21.
//

#import "BindCardViewController.h"

@import Tuna;

@interface BindCardViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cvvField;
@property (weak, nonatomic) IBOutlet UIButton *bindButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation BindCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bindButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.card) self.title = self.card.maskedNumber;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.cvvField becomeFirstResponder];
}

- (IBAction)cvvChanged:(UITextField *)sender
{
    self.bindButton.enabled = sender.text.length >= 3;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self performBind:textField];
    return YES;
}

- (IBAction)performBind:(id)sender
{
    [self.spinner startAnimating];
    self.bindButton.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    [TunaSDK bindCard:self.card cvv:self.cvvField.text completion:^(TunaCard *card, TunaSDKError *error) {
        [weakSelf.spinner stopAnimating];
        weakSelf.bindButton.hidden = NO;
        
        if (error) {
            [weakSelf showAlertForError:error];
            return;
        }

        [self.bindButton setTitle:@"Bind Succeeded!" forState:UIControlStateNormal];
        self.bindButton.enabled = NO;
        self.cvvField.enabled = NO;
    }];
}

- (void)showAlertForError:(TunaSDKError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Bind Failed" message:[NSString stringWithFormat:@"Bind failed with error: %@", error] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
