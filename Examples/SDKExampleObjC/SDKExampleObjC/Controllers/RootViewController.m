//
//  RootViewController.m
//  SDKExampleObjC
//
//  Created by Guilherme Rambo on 10/05/21.
//

#import "RootViewController.h"

@import Tuna;

@interface RootViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *customerIDField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.emailField.delegate = self;
    
    // Note: do not use UserDefaults to store sensitive data in production apps,
    // this is being done here only for convenience when using the sample app.
    self.customerIDField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"CustomerID"];
    self.emailField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"CustomerEmail"];
}

- (void)startLoading
{
    self.checkoutButton.hidden = YES;
    [self.spinner startAnimating];
}

- (void)finishLoading
{
    self.checkoutButton.hidden = NO;
    [self.spinner stopAnimating];
}

- (IBAction)startCheckout:(UIButton *)sender
{
    if (!self.emailField.text.length || !self.customerIDField.text.length) {
        return [self showAlertWithTitle:@"Missing Data" message:@"Please enter customer ID and email."];
    }
    
    [self startLoading];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.customerIDField.text forKey:@"CustomerID"];
    [[NSUserDefaults standardUserDefaults] setObject:self.emailField.text forKey:@"CustomerEmail"];
    
    /*
     Start a new Tuna session. Keep in mind that the startSession method should only be used in the sandbox environment for
     testing. When running in the production environment, a session ID must be generated in your backend and sent back
     to the app. Please refer to the SDK documentation for more details.
     */
    [TunaSDK startSessionWithCustomerId:self.customerIDField.text customerEmail:self.emailField.text completion:^(TunaSDKError * _Nullable error) {
        [self finishLoading];
        
        if (error) {
            [self showAlertWithTitle:@"Session Failed to Start" message:[NSString stringWithFormat:@"Session couldn't be started. Error: %@", error]];
        } else {
            [self presentCheckoutScreen];
        }
    }];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self startCheckout:self.checkoutButton];
    
    return YES;
}

- (void)presentCheckoutScreen
{
    [self performSegueWithIdentifier:@"Checkout" sender:nil];
}

@end
