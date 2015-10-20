//
//  HistoryTableView.h
//  HouseBank
//
//  Created by CSC on 14/12/19.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HistoryTableView;

@protocol HistoryDelegation <NSObject>

-(void) didSelectInIndex :(HistoryTableView *) tableView index : (NSInteger) index;
-(void) didCancel : (HistoryTableView *) tableView;
-(void) didFooterTapped : (HistoryTableView *) tableView;

@end

// 用于 商业地产等的搜索记录列表
@interface HistoryTableView : UITableView

@property (weak,nonatomic) id<HistoryDelegation> delegation;

-(void) show : (NSArray *) datas;
-(void) refresh : (NSArray *) datas;
-(void) dismiss ;

@end
