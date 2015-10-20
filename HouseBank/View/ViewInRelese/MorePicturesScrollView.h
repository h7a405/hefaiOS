//
//  MorePicturesScrollView.h
//  HouseBank
//
//  Created by CSC on 15/1/22.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MorePicturesScrollView;
@protocol MorePictureDelegation <NSObject>

-(void) onAddBtnTapped : (MorePicturesScrollView *) moreView;

@end

@interface MorePicturesScrollView : UIScrollView

@property (nonatomic,weak) id<MorePictureDelegation> delegation;

-(void) addImage : (UIImage *) image;
-(NSArray *) images ;

@end
