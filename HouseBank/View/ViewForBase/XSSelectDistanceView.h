//
//  XSSelectDistanceView.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-22.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//  距离选择器

#import <UIKit/UIKit.h>
@class XSSelectDistanceView;
@protocol XSSelectDistanceViewDelegate <NSObject>

-(void)selectDistanceView:(XSSelectDistanceView *)view didSelectDistance:(NSString *)distance;

@end
@interface XSSelectDistanceView : UIView
@property(nonatomic,weak)id<XSSelectDistanceViewDelegate>delegate;
-(void)show;
@end
