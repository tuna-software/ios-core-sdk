//
//  CreditCardsViewController.m
//  SDKExampleObjC
//
//  Created by Guilherme Rambo on 10/05/21.
//

#import "CreditCardsViewController.h"
#import "AddCardViewController.h"
#import "BindCardViewController.h"

@import Tuna;

@interface CreditCardsViewController ()

@property (nonatomic, assign, getter=isLoading) BOOL loading;
@property (nonatomic, strong) NSArray <TunaCard *> *cards;
@property (readonly) TunaCard *selectedCard;

@end

@implementation CreditCardsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadCards];
    
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kReloadCardsNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf loadCards];
    }];
}

- (IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadCards
{
    self.loading = YES;
    
    __weak typeof(self) weakSelf = self;
    [TunaSDK fetchCardsWithCompletionHandler:^(NSArray<TunaCard *> * cards, TunaSDKError *error) {
        weakSelf.loading = NO;
        
        if (error) {
            NSLog(@"%@", error);
            NSAssert(NO, @"Fetch failed");
            return;
        }
        
        [weakSelf setCards:cards];
    }];
}

- (void)setLoading:(BOOL)loading
{
    _loading = loading;
    
    [self.tableView reloadData];
}

- (void)setCards:(NSArray<TunaCard *> *)cards
{
    _cards = cards;
    
    [self.tableView reloadData];
}

- (IBAction)addCard:(id)sender
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isLoading) {
        return 1;
    } else {
        return self.cards.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardCell" forIndexPath:indexPath];
    
    if (self.isLoading) {
        cell.textLabel.textColor = [UIColor secondaryLabelColor];
        cell.textLabel.text = @"Loading...";
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.textLabel.textColor = [UIColor labelColor];
        cell.textLabel.text = self.cards[indexPath.row].maskedNumber;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (TunaCard *)selectedCard
{
    if (self.tableView.indexPathForSelectedRow.row >= 0) {
        return self.cards[self.tableView.indexPathForSelectedRow.row];
    } else {
        return nil;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddCard"]) return;
    
    assert(self.selectedCard);
    
    BindCardViewController *controller = (BindCardViewController *)segue.destinationViewController;
    controller.card = self.selectedCard;
}

@end
