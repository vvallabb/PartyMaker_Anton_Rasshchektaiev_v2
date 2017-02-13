//
//  PMRParty.h
//  PartyMaker
//
//  Copyright © 2017 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMRParty : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *partyID;
@property (nonatomic, readonly) NSDate *startDate;
@property (nonatomic, readonly) NSDate *endDate;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *logoImageName;
@property (nonatomic, readonly) NSString *descriptionText;
@property (nonatomic, readonly) NSDate *creationDate;
@property (nonatomic, readonly) NSDate *modificationDate;
@property (nonatomic, readonly) NSString *creatorID;
@property (nonatomic, readonly) NSString *latitude;
@property (nonatomic, readonly) NSString *longtitude;

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
