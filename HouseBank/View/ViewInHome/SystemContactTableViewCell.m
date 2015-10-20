//
//  SystemContactTableViewCell.m
//  HouseBank
//
//  Created by CSC on 15/1/3.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "SystemContactTableViewCell.h"

@interface SystemContactTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;

@end

@implementation SystemContactTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) refresh : (NSDictionary *) dict {
    NSArray *phones = dict[@"phones"];
    if (phones && phones.count) {
        _phone.text = phones[0];
    }else{
        _phone.text = @"";
    }
    
    _name.text = dict[@"name"];
};

@end
