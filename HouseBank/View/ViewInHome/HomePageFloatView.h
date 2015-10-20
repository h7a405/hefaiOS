//
//  HomePageFloatView.h
//  HouseBank
//
//  Created by CSC on 14/12/22.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomePageFloatView;

@protocol FloatViewDelegation <NSObject>

-(void) didSelect : (HomePageFloatView *) floatView index : (NSInteger) index ;

@end

@interface HomePageFloatView : UIView

@property (weak,nonatomic) id<FloatViewDelegation> delegation;

-(void) showInView :(UIView *) view ;
-(void) dismiss ; //dismiss with do nothing
-(void) dismiss : (void(^)())complete;//dismiss with do complete block

@end
