//
//  EditPartyViewController.h
//  Party Maker
//
//  Created by intern on 2/22/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "BasePartyConfigVC.h"
#import "PMRParty.h"
#import "HTTPManager.h"
#import "PMRCoreDataManager+Party.h"
#import "PMRPartyManagedObject.h"
#import "LocationViewController.h"

@interface EditPartyViewController : BasePartyConfigVC

@property PMRParty *party;



@end
