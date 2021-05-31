//
//  AddCardViewController.m
//  SDKExampleObjC
//
//  Created by Guilherme Rambo on 10/05/21.
//

#import "AddCardViewController.h"

@import Tuna;

NSString * const kReloadCardsNotification = @"uy.tuna.ReloadCardsNotification";

@interface AddCardViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UITextField *expirationField;
@property (weak, nonatomic) IBOutlet UISwitch *saveSwitch;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneItem;

@end

@implementation AddCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)setFormEnabled:(BOOL)enabled
{
    self.nameField.enabled = enabled;
    self.numberField.enabled = enabled;
    self.expirationField.enabled = enabled;
    self.saveSwitch.enabled = enabled;
    self.doneItem.enabled = enabled;
    self.cancelItem.enabled = enabled;
}

- (IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender
{
    NSArray <NSString *> *expirationComponents = [self.expirationField.text componentsSeparatedByString:@"/"];
    if (expirationComponents.count < 2) return [self showInvalidExpirationAlert];
    
    if (expirationComponents[0].length != 2
        || expirationComponents[1].length != 4
        || !expirationComponents[0].intValue
        || !expirationComponents[1].intValue) return [self showInvalidExpirationAlert];
    
    NSNumber *month = [NSNumber numberWithInt:expirationComponents[0].intValue];
    NSNumber *year = [NSNumber numberWithInt:expirationComponents[1].intValue];
    
    [self setFormEnabled:NO];
    
    __weak typeof(self) weakSelf = self;
    
    [TunaSDK addNewCardWithNumber:self.numberField.text
                   cardHolderName:self.nameField.text
                  expirationMonth:month
                   expirationYear:year
                              cvv:nil
                             save:self.saveSwitch.isOn
                       completion:^(TunaCard *newCard, TunaSDKError *error)
    {
        if (error) {
            NSLog(@"%@", error);
            NSAssert(NO, @"Add card failed");
            return;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadCardsNotification object:nil];
        
        [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)showInvalidExpirationAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Expiration Date" message:@"Please enter a valid expiration date in the format MM/YYYY." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
