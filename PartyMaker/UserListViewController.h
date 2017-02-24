//
//  UserListViewController.h
//  Party Maker
//
//  Created by intern on 2/24/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPManager.h"
#import "UserListTableViewCell.h"

@interface UserListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray* usersArray;
@property (weak, nonatomic) IBOutlet UITableView *tableViewUsersList;

@end
