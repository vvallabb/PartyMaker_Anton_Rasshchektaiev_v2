//
//  Party.m
//  TestUIKit
//
//  Created by intern on 2/3/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "Party.h"

@implementation Party

- (instancetype) initWithPartyDate:(NSDate*)partyDate
                         partyName:(NSString *)partyName
                    partyStartTime:(NSString *)partyStartTime
                   partyLogoNumber:(NSInteger)partyLogoNumber {
    
    self = [super init];
    
    self.partyDate = partyDate;
    self.partyName = partyName;
    self.partyStartTime = partyStartTime;
    self.partyLogoNumber = partyLogoNumber;
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.partyDate forKey:@"partyDate"];
    [aCoder encodeObject:self.partyName forKey:@"partyName"];
    [aCoder encodeObject:self.partyStartTime forKey:@"partyStartTime"];
    [aCoder encodeInteger:self.partyLogoNumber forKey:@"partyLogoNumber"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.partyDate = [aDecoder decodeObjectForKey:@"partyDate"];
    self.partyName = [aDecoder decodeObjectForKey:@"partyName"];
    self.partyStartTime = [aDecoder decodeObjectForKey:@"partyStartTime"];
    self.partyLogoNumber = [aDecoder decodeIntegerForKey:@"partyLogoNumber"];
    
    return self;
}

// get an array from NSUserDefaults
+ (NSMutableArray *)deserializePartyList {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"partyList"];
    NSMutableArray *partyList;
    
    if (!data) {
        partyList = [[NSMutableArray alloc] init];
    } else {
        partyList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return partyList;
}

// put an array to NSUserDefaults
+ (void)serializePartyList:(NSMutableArray *)partyList {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:partyList];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"partyList"];
}

+ (NSArray *)getImageNamesArray {
    NSArray *imageNamesArray = @[@"No Alcohol-100.png", @"Coconut Cocktail-100.png", @"Christmas Tree-100.png", @"Champagne-100.png", @"Birthday Cake-100.png", @"Beer-100.png"];
    
    return imageNamesArray;
}

@end
