//
//  PMRParty.h
//  PartyMaker
//
//  Copyright © 2017 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMRParty : NSObject <NSCoding>

@property (nonatomic, readonly) NSNumber *partyID;
@property (nonatomic, readonly) NSNumber *startDate;
@property (nonatomic, readonly) NSNumber *endDate;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSNumber *logoImageNumber;
@property (nonatomic, readonly) NSString *descriptionText;
@property (nonatomic, readonly) NSNumber *creatorID;
@property (nonatomic, readwrite) NSNumber *latitude;
@property (nonatomic, readwrite) NSNumber *longtitude;

- (instancetype)initWithPartyID:(NSNumber*)partyID
                           name:(NSString*)name
                      startDate:(NSNumber*)startDate
                        endDate:(NSNumber*)endDate
                logoImageNumber:(NSNumber*)logoImageNumber
                descriptionText:(NSString*)descriptionText
                      creatorID:(NSNumber*)creatorID
                       latitude:(NSNumber*)latitude
                     longtitude:(NSNumber*)longtitude;

@end
