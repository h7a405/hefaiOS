//
//  HomePageFloatView.m
//  HouseBank
//
//  Created by CSC on 14/12/22.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "HomePageFloatView.h"

@interface HomePageFloatView (){
    CGPoint _containerCenter;
}

@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIToolbar *backView;
@property (weak, nonatomic) IBOutlet UIView *signatureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@end

@implementation HomePageFloatView

@synthesize delegation;

-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.frame = [UIScreen mainScreen].bounds;
        _containerCenter = _container.center;
    }
    return self;
}

-(void) showInView :(UIView *) view{
    _backView.alpha = 0.2;
    _signatureImageView.alpha = 0.2;
    _backImageView.alpha = 0.2;
    _container.center = CGPointMake(_containerCenter.x, _containerCenter.y + _container.frame.size.height);
    [view addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        _backView.alpha = 1;
        _signatureImageView.alpha = 1.0;
        _backImageView.alpha = 1.0;
        _container.center = _containerCenter;
    }];
};

-(void) dismiss : (void(^)())complete{
    [UIView animateWithDuration:0.25 animations:^{
        _backView.alpha = 0;
        _signatureImageView.alpha = 0.0;
        _backImageView.alpha = 0.0;
        _container.center = CGPointMake( _container.center.x,  _container.center.y + _container.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        complete();
    }];
};

-(void) dismiss{
    [self dismiss:^{}];
};

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

- (IBAction)close:(id)sender {
    [self dismiss] ;
}

- (IBAction)btnTapped:(id)sender {
    if([self.delegation respondsToSelector:@selector(didSelect:index:)]){
        UIButton *btn = sender;
        [self.delegation didSelect:self index:btn.tag];
    }
}

@end
