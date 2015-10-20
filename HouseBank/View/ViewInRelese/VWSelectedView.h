//
//  VWSelectedView.h
//  KKKKKK
//
//  Created by rokect on 14-8-13.
//  Copyright (c) 2014年 rokect. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CRMConstant.h"

typedef void(^MutipleBlock)(NSInteger index,NSString *title);

@class VWSelectedView;
@protocol VWSelectedViewDelegate <NSObject>

-(void)vwSelectedView:(VWSelectedView *)view selectedTitle:(NSString *)title index:(NSInteger)index;

@end



@interface VWSelectedView : UIView

@property(nonatomic,weak) id <VWSelectedViewDelegate> selectedDelegate;

@property (nonatomic,strong) NSString *placeholderText;

@property (nonatomic,strong) NSMutableArray *currentItems;

-(id)initWithFrame:(CGRect)frame withItems:(NSArray *)items;
-(id)initWithFrame:(CGRect)frame withItems:(NSArray *)items withBlock:(void(^)(NSInteger index,NSString *title))block;
-(id)initWithFrame:(CGRect)frame withItems:(NSArray *)items withBlock:(void(^)(NSInteger index,NSString *title))block withPlaceholderText:(NSString *)text;

-(void)expandedTableView;
-(void)shrinkTableView;
-(void)reloadItems:(NSArray *)items;

@end
