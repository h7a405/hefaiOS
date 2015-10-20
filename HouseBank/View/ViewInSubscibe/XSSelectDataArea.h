//
//  XSSelectAreaForSubscibe.h
//  HouseBank
//
//  Created by 鹰眼 on 14-10-13.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XSSelectDataArea;
@protocol XSSelectDataAreaDelegate <NSObject>

@optional
-(void)selectDataArea:(XSSelectDataArea *)view didSelectRoomAreaWithBegin:(NSString *)begin andEnd:(NSString *)end;
-(void)selectDataArea:(XSSelectDataArea *)view didSelectRoomAreaWithBegin:(NSString *)begin andEnd:(NSString *)end name:(NSString *)name;

@end

@interface XSSelectDataArea : UIView
-(void)show;
@property(nonatomic,weak)id<XSSelectDataAreaDelegate>delegate;
- (id)initWithFrame:(CGRect)frame andData:(NSArray *)data;
@end
