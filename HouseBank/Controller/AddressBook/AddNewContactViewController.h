//
//  AddNewContactViewController.h
//  HouseBank
//
//  Created by CSC on 14/12/31.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseViewController.h"

@protocol AddContactDelegate <NSObject>

-(void) finishUpdate ;

@end

@interface AddNewContactViewController : BaseViewController

@property (nonatomic) id<AddContactDelegate> delegation ;

@property (copy,atomic) NSString *contactId ;
@property (atomic) NSDictionary *contact ;
@property (atomic) BOOL isUpdate;

@end
