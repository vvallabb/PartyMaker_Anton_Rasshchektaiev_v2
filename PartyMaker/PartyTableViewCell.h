//
//  PartyTableViewCell.h
//  TestUIKit
//
//  Created by intern on 2/3/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMRParty.h"
#import "PMRCoreDataManager.h"
#import "PMRCoreDataManager+Party.h"

@interface PartyTableViewCell : UITableViewCell

+ (NSString*)reuseIdentifier;

- (void)configureWithParty: (PMRParty*) party;

@end
