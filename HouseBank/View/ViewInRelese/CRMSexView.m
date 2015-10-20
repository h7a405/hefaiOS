//
//  CRMSexView.m
//  CRMApp
//
//  Created by 123 on 14/11/5.
//  Copyright (c) 2014年 李韦琼. All rights reserved.
//

#import "CRMSexView.h"
#import "CRMBasicFactory.h"
#import "UIViewExt.h"
@interface CRMSexView ()
{
    NSInteger curIndex;
}
@property (copy, nonatomic) GenderBlock mBlock;

@property (weak, nonatomic) UIButton *selectedBtn;

@end
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
@implementation CRMSexView
- (id)initWithFrame:(CGRect)frame withSex:(NSInteger)sex withGenderBlock:(void(^)(int index,NSString *male))block{
    self = [super initWithFrame:frame];
    curIndex = -1;
    if (self) {
        
        curIndex = sex;
        
        self.mBlock = block;
        
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig{
    
    UIButton *leftBtn = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0, 5, 20, 20) image:[UIImage imageNamed:@"radio_cancel.png"] selectedImage:[UIImage imageNamed:@"radio_confrim.png"] target:self action:@selector(btnAction:)];
    leftBtn.tag = 100;
    UILabel *label1 = [CRMBasicFactory createLableWithFrame:CGRectMake(leftBtn.right, leftBtn.top, 40, 20) font:[UIFont systemFontOfSize:16] text:@"求购" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    UIButton *rightBtn = [CRMBasicFactory createButtonWithType:UIButtonTypeCustom frame:CGRectMake(0+kScreenWidth/5, leftBtn.top, 20, 20) image:[UIImage imageNamed:@"radio_cancel.png"] selectedImage:[UIImage imageNamed:@"radio_confrim.png"] target:self action:@selector(btnAction:)];
    rightBtn.tag = 101;
    UILabel *label2 = [CRMBasicFactory createLableWithFrame:CGRectMake(rightBtn.right, rightBtn.top, 40, 20) font:[UIFont systemFontOfSize:16] text:@"求租" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft backgroundColor:[UIColor clearColor]];
    if (curIndex == 0) {
        leftBtn.selected = YES;
        self.selectedBtn = leftBtn;
    }else if (curIndex ==1){
        rightBtn.selected = YES;
        self.selectedBtn = rightBtn;
    }
    
    [self addSubview:leftBtn];
    [self addSubview:label1];
    [self addSubview:rightBtn];
    [self addSubview:label2];
    
}

- (void)btnAction:(UIButton *)sender{
    
    //如果self.selectedBtn存在  则把选中设为NO
    if (self.selectedBtn) {
        self.selectedBtn.selected = NO;
    }
    //不存在设为YES
    sender.selected = YES;
    self.selectedBtn = sender;
    
    switch (sender.tag -100) {
        case 0:
        {
            self.mBlock(1,@"第一个按钮");
        }
            break;
        case 1:
        {
            self.mBlock(2,@"第二个按钮");
        }
            break;
        default:
            break;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
