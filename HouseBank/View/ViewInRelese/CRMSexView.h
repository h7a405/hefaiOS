//
//  CRMSexView.h
//  CRMApp
//
//  Created by 123 on 14/11/5.
//  Copyright (c) 2014年 李韦琼. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef void(^GenderBlock)(int index,NSString *male);

@interface CRMSexView : UIView
- (id)initWithFrame:(CGRect)frame withSex:(NSInteger)sex withGenderBlock:(void(^)(int index,NSString *male))block;
@end
