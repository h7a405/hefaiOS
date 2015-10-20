//
//  AddressBookCellTableViewCell.m
//  HouseBank
//
//  Created by CSC on 14/12/30.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "AddressBookCellTableViewCell.h"

@interface AddressBookCellTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *relation;

@property (weak, nonatomic) IBOutlet UILabel *level;
@end

@implementation AddressBookCellTableViewCell

-(void) refresh : (NSDictionary *) dict{
    //    contactId = 159418;
    //    importantLevel = 1;
    //    mobilephone1 = 13800138222;
    //    name = Gg;
    _name.text = dict[@"name"];
    _relation.text = [TextUtil replaceNull:dict[@"mobilephone1"]];
    
    switch ([dict[@"importantLevel"] integerValue]) {
        case VIP:
            _level.text = VIPSTR;
            _level.textColor = [UIColor redColor];
            break;
        case A:
            _level.text = ASTR;
            _level.textColor = [UIColor grayColor];
            break;
        case B:
            _level.text = BSTR;
            _level.textColor = [UIColor grayColor];
            break;
        case C:
            _level.text = CSTR;
            _level.textColor = [UIColor grayColor];
            break;
            
        default:
            _level.text = VIPSTR;
            _level.textColor = [UIColor redColor];
            break;
    }
};

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
