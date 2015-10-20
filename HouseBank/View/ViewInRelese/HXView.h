//
//  HXView.h
//  housebank.1
//
//  Created by admin on 14/12/23.
//  Copyright (c) 2014年 Mr.Sui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MutipleBlock)(NSInteger index,NSString *title);

@class HXView;
@protocol HXSelectedViewDelegate <NSObject>

-(void)vwSelectedView:(HXView *)view selectedTitle:(NSString *)title index:(NSInteger)index;

@end



@interface HXView : UIView

@property(nonatomic,weak) id <HXSelectedViewDelegate> selectedDelegate;

@property (nonatomic,strong) NSString *placeholderText;

@property (nonatomic,strong) NSMutableArray *currentItems;

-(id)initWithFrame:(CGRect)frame withItems:(NSArray *)items;
-(id)initWithFrame:(CGRect)frame withItems:(NSArray *)items withBlock:(void(^)(NSInteger index,NSString *title))block;
-(id)initWithFrame:(CGRect)frame withItems:(NSArray *)items withBlock:(void(^)(NSInteger index,NSString *title))block withPlaceholderText:(NSString *)text;

-(void)expandedTableView;
-(void)shrinkTableView;
-(void)reloadItems:(NSArray *)items;


@end
