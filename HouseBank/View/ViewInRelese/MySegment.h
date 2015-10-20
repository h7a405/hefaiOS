//
//  AppDelegate.h
//  housebank.1
//
//  Created by admin on 14/12/22.
//  Copyright (c) 2014年 Mr.Sui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySegment : UIControl {
    
    NSArray *_items;
    
    float imageViewWidth;   //每项的宽度
    
    NSMutableArray *_imageViews;   //用于存储图片视图
}

@property(nonatomic,assign)int lastSelectIndex;   //上一次选中的索引

//自定义初始化方法
- (id)initWithItems:(NSArray *)items frame:(CGRect)frame;


@end
