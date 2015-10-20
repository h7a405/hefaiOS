//
//  HistoryTableView.m
//  HouseBank
//
//  Created by CSC on 14/12/19.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "HistoryTableView.h"

#define DismissDelay 0.3

@interface HistoryTableView ()<UITableViewDelegate,UITableViewDataSource>{
    CGPoint _center;
    NSArray *_datas ;
}

-(void) setupTitle;
-(void) setupFooter;
-(void) invalidateFooter;
-(void) footerTapped : (id) sender;

-(void)keyboardWasShown: (NSNotification *) notify;
-(void)keyboardWillBeHidden: (NSNotification *) notify;

-(void) removeItem : (NSInteger) count;

@end

@implementation HistoryTableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        [self setupTitle];
        [self registerForKeyboardNotifications];
        
        _center = self.center;
    }
    return self;
}

-(void) setupTitle{
    UILabel *label = [[UILabel alloc] initWithFrame:rect(0, 0, self.frame.size.width, 35)];
    label.text = @"  搜索历史";
    label.font=[UIFont systemFontOfSize:14.0];
    label.backgroundColor=Color(220 , 220 , 220);
    
    self.tableHeaderView = label;
}

- (void)registerForKeyboardNotifications{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) refresh : (NSArray *) datas{
    int lastCount = _datas.count;
    
    _datas = datas;
    
    if (_datas && _datas.count) {
        [self setupFooter];
        [self reloadData];
    }else{
        [self invalidateFooter];
        
        [self removeItem:lastCount];
    }
};

-(void) removeItem:(NSInteger)count{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count ; i++ ) {
        [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationMiddle];
}

-(void) show : (NSArray *) datas{
    //    self.alpha = 0.0;
    self.hidden = NO;
    
    [UIView animateWithDuration:DismissDelay animations:^{
        self.alpha = 1.0;
        self.center = _center;
    } completion:^(BOOL finished) {
        
    }];
    
    [self refresh:datas];
};

-(void) dismiss {
    self.alpha = 1.0;
    
    [UIView animateWithDuration:DismissDelay animations:^{
        self.alpha = 0.0;
        self.center = CGPointMake(_center.x, _center.y + self.frame.size.height/2);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
};

-(void) setupFooter{
    UIButton *btn = [[UIButton alloc] initWithFrame:rect(0, 0, self.frame.size.width, 35)];
    [btn addTarget:self action:@selector(footerTapped:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[ViewUtil imageWithColor:Color(220 , 220 , 220)] forState:UIControlStateNormal];
    [btn setTitle:@"清空历史" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.tableFooterView = btn;
};

-(void) invalidateFooter{
    self.tableFooterView = nil;
};

-(void) footerTapped:(id)sender{
    if ([self.delegation respondsToSelector:@selector(didFooterTapped:)]) {
        [self.delegation didFooterTapped:self];
    }
}

-(void)keyboardWasShown: (NSNotification *) notify{
    CGSize kbSize = [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
};

-(void)keyboardWillBeHidden: (NSNotification *) notify{
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
};

#pragma mark tableview delegation
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_datas) {
        return _datas.count;
    }
    return 0;
};

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _datas[indexPath.row];
    return cell;
};

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegation respondsToSelector:@selector(didSelectInIndex:index:)]) {
        [self.delegation didSelectInIndex:self index:indexPath.row];
    }
};

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
