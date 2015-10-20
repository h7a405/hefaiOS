//
//  SearchHouseTableView.m
//  HouseBank
//
//  Created by CSC on 14/12/31.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "SearchHouseTableView.h"

@interface SearchHouseTableView ()<UITableViewDataSource,UITableViewDelegate>{
    UIView *_noDataView;
    NSArray *_datas;
    NSString *_searchText;
}

@end

@implementation SearchHouseTableView

@synthesize delegation;

-(id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

-(void) refresh : (NSArray *) datas searchText : (NSString *) searchText{
    _searchText = searchText;
    _datas = datas;
    [self reloadData];
    
    if (datas && datas.count) {
        if (_noDataView) {
            [_noDataView removeFromSuperview];
            _noDataView = nil;
        }
    }else{
        if (!_noDataView) {
            _noDataView = [ViewUtil xibView:@"NoDataView"];
            [self addSubview:_noDataView];
        }
    }
};

-(void) dismiss {
    self.hidden = YES;
    _datas = nil;
    [self reloadData];
};

- (void)dealloc{
    _datas = nil;
    _noDataView = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count + 1;
};

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
    }
    
    if (indexPath.row < _datas.count) {
        NSDictionary *dict = _datas[indexPath.row];
        
        cell.textLabel.attributedText=[ViewUtil content:dict[@"communityName"] colorString:_searchText];
        cell.detailTextLabel.attributedText=[ViewUtil content:dict[@"address"] colorString:_searchText];
    }
    
    return cell;
};

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegation respondsToSelector:@selector(didSelect:index:)]) {
        [self.delegation didSelect:self index:indexPath.row];
    }
}

@end
