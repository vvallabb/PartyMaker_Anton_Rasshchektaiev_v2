//
//  UserListTableViewCell.h
//  Party Maker
//
//  Created by intern on 2/24/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListTableViewCell : UITableViewCell

@property (nonatomic, strong) NSNumber *creatorID;

- (void)configureWithUserName:(NSString*) userName
                    creatorID:(NSNumber*) creatorID;

+ (NSString*)reuseIdentifier;

@end
