//
//  PLViewController.m
//  TestUIKit
//
//  Created by intern on 2/3/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "PLViewController.h"

@interface PLViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableViewPartyList;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;

@end

@implementation PLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewPartyList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //[self setUpAddBarButtonItem];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// for UITableViewDelegate protocol
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [Party deserializePartyList].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PartyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PartyTableViewCell reuseIdentifier]];
    
    if (!cell) {
        cell = [[PartyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PartyTableViewCell reuseIdentifier]];
    }
        
    Party *party = [[Party deserializePartyList] objectAtIndex:indexPath.row];
        
    [cell configureWithLogo:party.partyLogoNumber partyName:party.partyName partyStartTime:party.partyStartTime partyDate:party.partyDate];
    
    return cell;
}

// set up the table view cell hight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height / 8;
}

- (IBAction)onAddButtonClicked:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"SegueToCreateParty" sender:self];
}

// temporary
- (IBAction)onDeleteButtonClicked:(UIBarButtonItem *)sender {
    NSMutableArray *emptyArray = [[NSMutableArray alloc] init];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:emptyArray];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"partyList"];
    
    [self loadView];
}
//-----------------

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
