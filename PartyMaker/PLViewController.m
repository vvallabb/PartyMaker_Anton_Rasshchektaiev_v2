//
//  PLViewController.m
//  TestUIKit
//
//  Created by intern on 2/3/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "PLViewController.h"

@interface PLViewController () <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewPartyList;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@property (strong, nonatomic) TableViewDataSource *dataSource;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation PLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewPartyList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableViewPartyList setSeparatorColor:[UIColor colorWithRed:68/255.f green:73/255.f blue:83/255.f alpha:1.f]];
    self.tableViewPartyList.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //[self setUpAddBarButtonItem];
    [self.navigationItem setHidesBackButton:YES];
    
    self.dataSource = [[PartyTableViewDataSource alloc] initWithTableView:self.tableViewPartyList context:[[PMRCoreDataManager sharedStore] mainThreadContext] reuseIdentifier:[PartyTableViewCell reuseIdentifier] cellConfigurationBlock:^(UITableViewCell *cell, NSManagedObject *item) {
        PMRParty *party = [[PMRParty alloc] initWithManagedObject:(PMRPartyManagedObject *)item];
        PartyTableViewCell *partyCell = (PartyTableViewCell *)cell;
        [partyCell configureWithParty:party];
    }];
    
    self.tableViewPartyList.dataSource = self.dataSource;
    //self.tableViewPartyList.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refreshControlAction:)
                  forControlEvents:UIControlEventValueChanged];
    self.tableViewPartyList.refreshControl = self.refreshControl;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.dataSource.paused = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.dataSource.paused = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate protocol
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *parties = [[PMRCoreDataManager sharedStore] getParties];
    return parties.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - Other settings for cells
// set up the table view cell hight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height / 8;
}

- (IBAction)onAddButtonClicked:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"SegueToCreateParty" sender:self];
}

// set up the row selection
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PartyInfoViewController *partyInfoVC = segue.destinationViewController;
    
    NSIndexPath *selectedPath = [self.tableViewPartyList indexPathForSelectedRow];
    PartyTableViewCell *cell = [self.tableViewPartyList cellForRowAtIndexPath:selectedPath];
    
    [partyInfoVC setParty:[cell party]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"SegueFromPartyListToPartyInfo" sender:nil];
}

#pragma mark - Control actions

- (void)refreshControlAction:(UIRefreshControl *)refreshControl {
    [[PMRCoreDataManager sharedStore] performWriteOperation:^(NSManagedObjectContext * _Nonnull context) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"PMRPartyManagedObject" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            NSLog(@"error %@", error);
        }
        
    } completion:^{
        [refreshControl endRefreshing];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
