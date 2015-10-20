//
//  SearchHouseTableView.h
//  HouseBank
//
//  Created by CSC on 14/12/31.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchHouseTableView;

@protocol SearchHouseTableViewDelegation <NSObject>

-(void) didSelect :(SearchHouseTableView *) tableView index : (NSInteger) index;

@end

@interface SearchHouseTableView : UITableView

@property (nonatomic,weak) id<SearchHouseTableViewDelegation> delegation;

-(void) refresh : (NSArray *) datas searchText : (NSString *) searchText;
-(void) dismiss ;

@end
