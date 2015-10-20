//
//  FullScreenPickerView.h
//  HouseBank
//
//  Created by CSC on 14/12/25.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FullScreenPickerView;

@protocol FullScreenPickerViewDelegation <NSObject>

-(void) didTappenBy : (FullScreenPickerView *) fullPickerView index : (NSInteger) index;

@end

@interface FullScreenPickerView : UIView

@property (weak,nonatomic) id<FullScreenPickerViewDelegation> delegation;

-(void) showWith : (NSArray *) datas inView : (UIView *) view index : (NSInteger) index;
-(void) showWith:(NSArray *)datas index : (NSInteger) index;
-(void) dismiss;

@end
