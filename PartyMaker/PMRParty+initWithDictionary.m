//
//  PMRParty+initWithDictionary.m
//  PartyMaker
//
//  Copyright © 2017 Softheme. All rights reserved.
//

#import "PMRParty+initWithDictionary.h"

@implementation PMRParty (initWithDictionary)

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {

    return [self initWithPartyID:dictionary[@"id"]
                            name:dictionary[@"name"]
                       startDate:dictionary[@"startDate"]
                         endDate:dictionary[@"endDate"]
                   logoImageNumber:dictionary[@"logo_id"]
                 descriptionText:dictionary[@"comment"]
                       creatorID:dictionary[@"creator_id"]
                        latitude:dictionary[@"latitude"]
                      longtitude:dictionary[@"longtitude"]];
}

@end
