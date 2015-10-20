//
//  AddressChooseView.m
//  HouseBank
//
//  Created by CSC on 14/12/30.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "AddressChooseView.h"
#import "Address.h"
#import "FYAddressDao.h"

typedef NS_ENUM(NSInteger, Level){
    City,
    Region,
    Block
};

@interface AddressChooseView ()<UITableViewDataSource,UITableViewDelegate>{
    UIView *_containerView;
    UIWindow *_defaultContainerView;
    
    UIView *_backView;
    
    CGPoint _defaultCenter ;
    UITableView *_tableView;
    
    NSArray *_datas ;
    Level level;
    
    NSString *_cityName;
    NSString *_cityId;
    NSString *_regionName;
    NSString *_regionId;
    NSString *_blockName;
    NSString *_blockId;
}

-(void) initialize ;

@end

@implementation AddressChooseView

-(id) init{
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

-(id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self initialize];
    }
    
    return self;
}

-(void) initialize{
    UIToolbar *backView = [[UIToolbar alloc]initWithFrame:self.bounds];
    backView.barStyle = UIBarStyleBlack;
    [self addSubview:backView];
    
    _backView = backView;
    
    float width = 260;
    float height = 396;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect((self.frame.size.width - width)/2, (self.frame.size.height - height)/2, width, height)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    _tableView = tableView;
};

-(void) show {
    FYAddressDao *dao = [FYAddressDao new];
    _datas = [dao allCity];
    [_tableView reloadData];
    
    level = City;
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:self.bounds];
    window.windowLevel = 2000;
    [window makeKeyAndVisible];
    
    _defaultContainerView = window;
    
    self.alpha = 0;
    [window addSubview:self];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
};


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

-(void) dismiss{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (_containerView == _defaultContainerView) {
            [_defaultContainerView resignKeyWindow];
            _defaultContainerView = nil;
        }
    }];
}

- (void)dealloc{
    _containerView = nil;
    _defaultContainerView = nil;
    
    _backView = nil;
    _tableView = nil;
    
    _datas = nil;
}


#pragma mark tableview delegation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count ;
};

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    Address *address = _datas[indexPath.row];
    cell.textLabel.text = address.name ;
    
    return cell;
};

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FYAddressDao *dao = [FYAddressDao new];
    Address *address = _datas[indexPath.row];
    
    if (level != Block) {
        _datas = [dao areasWithCity:address];
        [tableView reloadData];
    }
    
    if (level == City) {
        level = Region;
        _cityName = address.name;
        _cityId = [NSString stringWithFormat:@"%@",address.tid];
    }else if(level == Region){
        level = Block;
        _regionName = address.name;
        _regionId = [NSString stringWithFormat:@"%@",address.tid];
    } else if (level == Block) {
        _blockName = address.name;
        _blockId = [NSString stringWithFormat:@"%@",address.tid];
        
        if ([_delegation respondsToSelector:@selector(didChoose:cityId:cityName:regionId:regionName:blockId:blockName:)]) {
            [_delegation didChoose:self cityId:_cityId cityName:_cityName regionId:_regionId regionName:_regionName blockId:_blockId blockName:_blockName];
        }
        
        [self dismiss];
    }
    
};

@end
