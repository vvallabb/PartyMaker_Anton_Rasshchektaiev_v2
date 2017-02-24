//
//  UserListTableViewCell.h
//  Party Maker
//
//  Created by intern on 2/24/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListTableViewCell : UITableViewCell

- (void)configureWithUserName:(NSString*) userName;

+ (NSString*)reuseIdentifier;

@end
