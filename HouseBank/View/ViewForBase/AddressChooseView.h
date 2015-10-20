//
//  AddressChooseView.h
//  HouseBank
//
//  Created by CSC on 14/12/30.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressChooseView;

@protocol AddressDelegation <NSObject>

@required
-(void) didChoose : (AddressChooseView *) addressView cityId : (NSString *) cityId cityName : (NSString *) cityName regionId : (NSString *)regionId regionName : (NSString *) regionName blockId : (NSString *) blockId blockName : (NSString *) blockName ;

@end

@interface AddressChooseView : UIView

@property (weak,nonatomic) id<AddressDelegation> delegation ;

-(void) dismiss;
-(void) show ;

@end
