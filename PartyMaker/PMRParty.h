//
//  PMRParty.h
//  PartyMaker
//
//  Copyright © 2017 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMRParty : NSObject <NSCoding>

@property (nonatomic, readwrite) NSString *partyID;
@property (nonatomic, readwrite) NSDate *startDate;
@property (nonatomic, readwrite) NSDate *endDate;
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSString *logoImageName;
@property (nonatomic, readwrite) NSString *descriptionText;
@property (nonatomic, readwrite) NSDate *creationDate;
@property (nonatomic, readwrite) NSDate *modificationDate;
@property (nonatomic, readwrite) NSString *creatorID;
@property (nonatomic, readwrite) NSString *latitude;
@property (nonatomic, readwrite) NSString *longtitude;

- (instancetype)initWithPartyID:(NSString*)partyID
                           name:(NSString*)name
                      startDate:(NSDate*)startDate
                        endDate:(NSDate*)endDate
                  logoImageName:(NSString*)logoImageName
                descriptionText:(NSString*)descriptionText
                   creationDate:(NSDate*)creationDate
               modificationDate:(NSDate*)modificationDate
                      creatorID:(NSString*)creatorID
                       latitude:(NSString*)latitude
                     longtitude:(NSString*)longtitude;

@end
