//
//  PartyTableViewCell.h
//  TestUIKit
//
//  Created by intern on 2/3/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Party.h"

@interface PartyTableViewCell : UITableViewCell

+ (NSString*)reuseIdentifier;

- (void)configureWithLogo: (NSInteger) logoNumber
                partyName: (NSString*) partyName
           partyStartTime: (NSString*) partyStartTime
                partyDate: (NSDate*) date;

@end
