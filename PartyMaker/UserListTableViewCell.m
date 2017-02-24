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

- (void)configureWithUserName:(NSString*) userName {
    self.labelUserName.text = userName;
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
