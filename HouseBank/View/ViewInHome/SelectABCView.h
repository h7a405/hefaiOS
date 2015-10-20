//
//  SelectABCView.h
//  HouseBank
//
//  Created by CSC on 15/1/1.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectABCView;

@protocol SelectABCViewDelegation <NSObject>

-(void) didSelect : (SelectABCView *) view abcStr : (NSString *) abcStr;
-(void) cancel : (SelectABCView *) view;

@end

@interface SelectABCView : UIView

@property (nonatomic,weak) id<SelectABCViewDelegation> delegate;

@end
