//
//  XSSelectPriceForNeed.h
//  HouseBank
//
//  Created by 鹰眼 on 14-10-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XSSelectPriceForNeed;
@protocol XSSelectPriceForNeedDelegate <NSObject>
/**
 *  选择价格代理
 *
 *  @param view
 *  @param type 房子类型
 *  @param form 最低
 *  @param to   最高
 */
-(void)selectPrictForNeedView:(XSSelectPriceForNeed *)view didSelectHouseType:(HouseUseType)type prictForm:(NSString *)form andPriceTo:(NSString *)to;

@end

@interface XSSelectPriceForNeed : UIView
+(instancetype)selectPrictForNeedWithData:(NSArray *)data;
@property(nonatomic,weak)id<XSSelectPriceForNeedDelegate>delegate;
@property(nonatomic,strong)NSArray *data;
-(void)show;
@end
