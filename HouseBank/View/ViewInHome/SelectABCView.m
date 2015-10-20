//
//  SelectABCView.m
//  HouseBank
//
//  Created by CSC on 15/1/1.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "SelectABCView.h"
#import "Constants.h"

@interface SelectABCView (){
    NSArray *_abc;
    float _height;
    float _currentIndex ;
}

@end

@implementation SelectABCView

@synthesize delegate;

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        
        _abc = ABC;
        _currentIndex = -1;
        _height = self.frame.size.height / _abc.count;
        float width = self.frame.size.width;
        for (int i = 0; i<_abc.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:rect(0, _height*i, width, _height)];
            label.text = _abc[i];
            label.font = [UIFont systemFontOfSize:10];
            label.textAlignment = NSTextAlignmentCenter ;
            [self addSubview:label];
        }
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self didABCSelect:touches];
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.backgroundColor = [UIColor clearColor];
    _currentIndex = -1;
    
    if ([self.delegate respondsToSelector:@selector(cancel:)]) {
        [self.delegate cancel:self];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.backgroundColor = [UIColor clearColor];
    _currentIndex = -1;
    
    if ([self.delegate respondsToSelector:@selector(cancel:)]) {
        [self.delegate cancel:self];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self didABCSelect:touches];
}

-(void) didABCSelect : (NSSet *) touches{
    UITouch *touch = [touches anyObject] ;
    CGPoint point = [touch locationInView:self];
    NSInteger index = 0;
    
    if (point.y < 0) {
        index = 0;
    }else if(point.y > self.frame.size.height){
        index = _abc.count - 1;
    }else{
        index = point.y / _height;
        if (index >= _abc.count) {
            index = _abc.count - 1;
        }
    }
    
    if (_currentIndex != index) {
        _currentIndex = index;
        
        if ([self.delegate respondsToSelector:@selector(didSelect:abcStr:)]) {
            [self.delegate didSelect:self abcStr:_abc[index]];
        }
    }
}

@end
