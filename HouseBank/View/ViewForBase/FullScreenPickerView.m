//
//  FullScreenPickerView.m
//  HouseBank
//
//  Created by CSC on 14/12/25.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FullScreenPickerView.h"

@interface FullScreenPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    UIView *_containerView;
    UIWindow *_defaultContainerView;
    
    UIView *_backView;
    
    UIPickerView *_pickerView;
    NSArray *_datas;
    
    CGPoint _defaultCenter ;
    
    NSInteger _currentRow;
    
    UIButton *_btn;
}

-(void) initialize ;
-(void) okTapped ;

@end

@implementation FullScreenPickerView

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
    backView.alpha = 0.0f;
    
    [self addSubview:backView];
    
    _backView = backView;
    
    float width = self.bounds.size.width;
    float height = 162;
    
    UIPickerView *pickerview = [[UIPickerView alloc] initWithFrame:rect(0, 0, width, height)];
    pickerview.delegate = self ;
    pickerview.dataSource = self ;
    
    
    [self addSubview:pickerview];
    
    pickerview.center = self.center;
    _pickerView = pickerview;
    
    _defaultCenter = pickerview.center;
    _pickerView.center = CGPointMake(-_defaultCenter.x, _defaultCenter.y);
    
    UIButton *button = [[UIButton alloc] initWithFrame:rect(10, self.frame.size.height - 55, self.frame.size.width - 20, 40)];
    [button setTitle:@"确 定" forState:UIControlStateNormal];
    [button setBackgroundImage:[ViewUtil imageWithColor:KNavBGColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(okTapped) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [self addSubview:button];
    
    _btn = button;
};

-(void) showWith:(NSArray *)datas index : (NSInteger) index{
    UIWindow *window = [[UIWindow alloc] initWithFrame:self.bounds];
    window.windowLevel = 2000;
    [window makeKeyAndVisible];
    
    _defaultContainerView = window;
    
    [self showWith:datas inView:window index:index];
}

-(void) okTapped{
    if ([self.delegation respondsToSelector:@selector(didTappenBy:index:)]) {
        [self.delegation didTappenBy:self index:_currentRow];
    }
}

-(void) showWith : (NSArray *) datas inView : (UIView *) view index : (NSInteger) index{
    _containerView = view;
    _datas = datas;
    [_pickerView reloadAllComponents];
    [_pickerView selectRow:index inComponent:0 animated:NO];
    _currentRow = index;
    _btn.alpha = 0;
    
    [view addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        _backView.alpha = 1;
        _btn.alpha = 1;
        _pickerView.center = _defaultCenter;
    }];
};

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

-(void) dismiss{
    [UIView animateWithDuration:0.25 animations:^{
        _backView.alpha = 0.0;
        _btn.alpha = 0;
        _pickerView.center = CGPointMake(-_defaultCenter.x, _defaultCenter.y);
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
    
    _pickerView = nil;
    _datas = nil;
    _btn = nil;
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
};

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _datas.count;
};

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _datas[row];
};

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _currentRow = row;
};

@end
