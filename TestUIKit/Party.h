//
//  Party.h
//  TestUIKit
//
//  Created by intern on 2/3/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Party : NSObject <NSCoding>

@property (nonatomic, strong) NSDate *partyDate;
@property (nonatomic, strong) NSString *partyName;

@property (nonatomic, strong) NSString *partyStartTime;
@property (nonatomic, strong) NSString *partyEndTime;

@property NSInteger partyLogoNumber;
@property (nonatomic, strong) NSString *partyDescription;

- (instancetype) initWithPartyDate: (NSDate*) partyDate
                         partyName: (NSString*) partyName
                    partyStartTime: (NSString*) partyStartTime
                   partyLogoNumber: (NSInteger) partyLogoNumber;
            
+ (NSMutableArray*) deserializePartyList;
+ (void) serializePartyList :(NSMutableArray*) partyList;

+ (NSArray*) getImageNamesArray;

-(instancetype)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

@end
