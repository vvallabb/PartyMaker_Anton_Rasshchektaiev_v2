//
//  PMRParty.m
//  PartyMaker
//
//  Copyright © 2017 Softheme. All rights reserved.
//

#import "PMRParty.h"
#import <objc/runtime.h>

@interface PMRParty()

@property (nonatomic, readwrite) NSNumber *partyID;
@property (nonatomic, readwrite) NSNumber *startDate;
@property (nonatomic, readwrite) NSNumber *endDate;
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSNumber *logoImageNumber;
@property (nonatomic, readwrite) NSString *descriptionText;
@property (nonatomic, readwrite) NSNumber *creatorID;

@end

@implementation PMRParty

- (instancetype)initWithPartyID:(NSNumber*)partyID
                           name:(NSString*)name
                      startDate:(NSNumber*)startDate
                        endDate:(NSNumber*)endDate
                logoImageNumber:(NSNumber*)logoImageNumber
                descriptionText:(NSString*)descriptionText
                      creatorID:(NSNumber*)creatorID
                       latitude:(NSNumber*)latitude
                     longtitude:(NSNumber*)longtitude
{
    self = [super init];
    if (self) {
        _partyID = [partyID copy];
        _name = [name copy];
        _startDate = [startDate copy];
        _endDate = [endDate copy];
        _logoImageNumber = [logoImageNumber copy];
        _descriptionText = [descriptionText copy];
        _creatorID = [creatorID copy];
        _latitude = [latitude copy];
        _longtitude = [longtitude copy];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _partyID = [aDecoder decodeObjectForKey:@"partyID"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _startDate = [aDecoder decodeObjectForKey:@"startDate"];
        _endDate = [aDecoder decodeObjectForKey:@"endDate"];
        _logoImageNumber = [aDecoder decodeObjectForKey:@"logoImageNumber"];
        _descriptionText = [aDecoder decodeObjectForKey:@"descriptionText"];
        _creatorID = [aDecoder decodeObjectForKey:@"creatorID"];
        _latitude = [aDecoder decodeObjectForKey:@"latitude"];
        _longtitude = [aDecoder decodeObjectForKey:@"longtitude"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.partyID forKey:@"partyID"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.startDate forKey:@"startDate"];
    [aCoder encodeObject:self.endDate forKey:@"endDate"];
    [aCoder encodeObject:self.logoImageNumber forKey:@"logoImageNumber"];
    [aCoder encodeObject:self.descriptionText forKey:@"descriptionText"];
    [aCoder encodeObject:self.creatorID forKey:@"creatorID"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.longtitude forKey:@"longtitude"];
}

- (NSArray *)describablePropertyNames
{
    // Loop through our superclasses until we hit NSObject
    NSMutableArray *array = [NSMutableArray array];
    Class subclass = [self class];
    while (subclass != [NSObject class])
    {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(subclass,&propertyCount);
        for (int i = 0; i < propertyCount; i++)
        {
            // Add property name to array
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            [array addObject:@(propertyName)];
        }
        free(properties);
        subclass = [subclass superclass];
    }
    
    // Return array of property names
    return array;
}

- (NSString *)description
{
    NSMutableString *propertyDescriptions = [NSMutableString string];
    for (NSString *key in [self describablePropertyNames])
    {
        id value = [self valueForKey:key];
        [propertyDescriptions appendFormat:@";\n %@ : %@ = %@", NSStringFromClass([key class]), key, value];
    }
    return [NSString stringWithFormat:@"\n<%@: 0x%lx%@>\n ", [self class],
            (unsigned long)self, propertyDescriptions];
}



@end
