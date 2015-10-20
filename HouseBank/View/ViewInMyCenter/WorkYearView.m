//
//  WorkYearView.m
//  HouseBank
//
//  Created by CSC on 14-9-17.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "WorkYearView.h"
#import "AppDelegate.h"

@interface WorkYearView ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    __weak UIPickerView *_pickerView;
    __weak UIView *_backView;
    __weak UIView *_btnBar;
}
-(void) loadSubview;
-(void) dismiss;
-(void) onCancel;
-(void) onSave;

@end

@implementation WorkYearView

@synthesize delegation;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubview];
    }
    return self;
}

-(void) loadSubview{
    
    CGRect rect = self.bounds;
    
    float width = rect.size.width;
    float height = 216.0f;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:rect];
    toolBar.translucent = YES;
    toolBar.barStyle = UIBarStyleBlack;
    [self addSubview:toolBar];
    
    _backView = toolBar;
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, rect.size.height , width, height )];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [self addSubview:pickerView];
    
    _pickerView = pickerView;
    
    UIView *btnBar = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height, rect.size.width, 50)];
    btnBar.backgroundColor = [UIColor colorWithRed:(62/255.0) green:(160/255.0) blue:(77/255.0) alpha:1];
    [self addSubview:btnBar];
    
    _btnBar = btnBar;
    
    UIButton *canelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    [canelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [canelBtn setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateHighlighted];
    [canelBtn setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    [canelBtn addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    [btnBar addSubview:canelBtn];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(rect.size.width - 80, 0, 80, 50)];
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateHighlighted];
    [saveBtn setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(onSave) forControlEvents:UIControlEventTouchUpInside];
    [btnBar addSubview:saveBtn];
}

-(void) onCancel{
    [self dismiss];
}

-(void) onSave{
    if ([self.delegation respondsToSelector:@selector(onYearCheck:)]) {
        NSInteger year = [_pickerView selectedRowInComponent:0];
        [self.delegation onYearCheck:year];
    }
    [self dismiss];
}

-(void) dismiss{
    CGRect rect = self.bounds;
    float width = rect.size.width;
    float height = 216.0f;
    
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha = 0;
        _pickerView.frame = CGRectMake(0, rect.size.height, width, height );
        _btnBar.frame = CGRectMake(0, rect.size.height , rect.size.width, 50);
    } completion:^(BOOL isFinish){
        [self removeFromSuperview];
    }];
}

-(void) show{
    CGRect rect = self.bounds;
    float width = rect.size.width;
    float height = 216.0f;
    
    _backView.alpha = 0.0f;
    [[AppDelegate shareApp].window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha = 1.0f;
        _pickerView.frame = CGRectMake(0, rect.size.height - 216, width, height );
        _btnBar.frame = CGRectMake(0, rect.size.height - 266, rect.size.width, 50);
    }];
}

-(void) showWithYear : (NSNumber *) year{
    if ([year intValue]>0&& [year intValue] <= 20) {
        [_pickerView selectRow:[year intValue]-1 inComponent:0 animated:NO];
    }
    
    [self show];
};

#pragma mark picker delegation
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
};

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 20;
};

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%d年",row+1];
};


@end
