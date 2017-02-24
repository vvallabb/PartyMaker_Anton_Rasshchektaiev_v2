//
//  UserListTableViewCell.m
//  Party Maker
//
//  Created by intern on 2/24/17.
//  Copyright © 2017 intern. All rights reserved.
//

#import "UserListTableViewCell.h"

@interface UserListTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *labelUserName;

@end

@implementation UserListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configureWithUserName:(NSString*) userName creatorID:(NSNumber*) creatorID{
    self.labelUserName.text = userName;
    self.creatorID = creatorID;
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [[UIColor alloc] initWithRed:68/255.f green:73/255.f blue:83/255.f alpha:1.f];
    [self setSelectedBackgroundView:bgColorView];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.labelUserName.text = nil;
}

+ (NSString*)reuseIdentifier {
    return @"UserListTableViewCell";
}

-(instancetype)init {
    self = [super init];
    
    // check out twice
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [UIColor redColor];
    [self setSelectedBackgroundView:selectedView];
    
    return self;
}

@end
