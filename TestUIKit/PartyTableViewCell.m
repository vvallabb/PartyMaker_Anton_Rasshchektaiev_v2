//
//  PartyTableViewCell.m
//  TestUIKit
//
//  Created by intern on 2/3/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "PartyTableViewCell.h"

@interface PartyTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *imageViewPartyLogo;
@property (weak, nonatomic) IBOutlet UILabel *labelPartyName;
@property (weak, nonatomic) IBOutlet UILabel *labelPartyStartTime;

@end

@implementation PartyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithLogo: (NSInteger) logoNumber
                partyName: (NSString*) partyName
           partyStartTime: (NSString*) partyStartTime
                partyDate: (NSDate*) date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    self.labelPartyName.text = partyName;
    self.labelPartyStartTime.text = [NSString stringWithFormat:@"%@ %@", stringFromDate, partyStartTime];
    self.imageViewPartyLogo.image = [UIImage imageNamed:[[Party getImageNamesArray] objectAtIndex:logoNumber]];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [[UIColor alloc] initWithRed:68/255.f green:73/255.f blue:83/255.f alpha:1.f];
    [self setSelectedBackgroundView:bgColorView];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.labelPartyName.text = nil;
    self.labelPartyStartTime.text = nil;
    self.imageViewPartyLogo.image = nil;
}

+ (NSString*)reuseIdentifier {
    return @"PartyTableViewCell";
}

-(instancetype)init {
    self = [super init];
    
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [UIColor redColor];
    [self setSelectedBackgroundView:selectedView];
    
    return self;
}


@end
