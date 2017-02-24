//
//  UserListViewController.m
//  Party Maker
//
//  Created by intern on 2/24/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "UserListViewController.h"

@interface UserListViewController ()



@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableViewUsersList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableViewUsersList setSeparatorColor:[UIColor colorWithRed:88/255.f green:93/255.f blue:103/255.f alpha:1.f]];
    self.tableViewUsersList.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [[HTTPManager sharedInstance] setUserListViewController:self];
    [[HTTPManager sharedInstance] sendGetAllUsersRequest];
    
    self.tableViewUsersList.dataSource = self;
    self.tableViewUsersList.delegate = self;
    
    [self setUpBarButtonItems];
    self.partiesArray = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  [self usersArray].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITableViewDataSourceDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UserListTableViewCell reuseIdentifier]];
    
    if (!cell) {
        cell = [[UserListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UserListTableViewCell reuseIdentifier]];
    }
    
    NSDictionary *currentUser = [self.usersArray objectAtIndex:indexPath.row];
    NSString *currentUserName = [currentUser objectForKey:@"name"];
    NSNumber *currentUserCreatorID = [currentUser objectForKey:@"id"];
    
    [cell configureWithUserName:currentUserName creatorID:currentUserCreatorID];
    
    return cell;
}

// set up the table view cell hight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height / 15;
}

#pragma mark - Set up BarButtonItems
- (void)setUpBarButtonItems {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButtonClicked:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onDoneButtonClicked:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
}

- (void)onCancelButtonClicked:(UIBarButtonItem*) sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onDoneButtonClicked:(UIBarButtonItem*) sender {
    NSArray *selectedIndexPaths = [self.tableViewUsersList indexPathsForSelectedRows];
    
    for (int i = 0; i < selectedIndexPaths.count; i++) {
        UserListTableViewCell *cell = [self.tableViewUsersList cellForRowAtIndexPath:selectedIndexPaths[i]];
        
        [[HTTPManager sharedInstance] getSendGetAllPartiesWithCreatorIDRequest:cell.creatorID];
        }
    
    // need to be remade urgently!
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"SegueFromUserListToMap" sender:self];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LocationsShowViewController *locationShowVC = (LocationsShowViewController*) segue.destinationViewController;
    locationShowVC.partiesArray = self.partiesArray;
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
