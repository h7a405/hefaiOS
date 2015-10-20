//
//  AppDelegate.h
//  housebank.1
//
//  Created by admin on 14/12/22.
//  Copyright (c) 2014年 Mr.Sui. All rights reserved.
//

#import "MySegment.h"
#import "UIViewExt.h"
@implementation MySegment

//自定义初始化方法
- (id)initWithItems:(NSArray *)items frame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self != nil) {
        
        //将传递进来的items给全局的_items
        //_items = [items retain];
        
        //初始化子视图
        _items = [[NSMutableArray alloc] initWithCapacity:100];
        _items = items;
        //self.backgroundColor = [UIColor yellowColor];
        [self _initViews];
    }
    
    return self;
}

//初始化子视图
- (void)_initViews {
    
    imageViewWidth = (self.width-4)/ _items.count;
    
    _imageViews = [[NSMutableArray alloc] init];
    
    for (int i=0; i<_items.count; i++) {
        
        /*-------------图片视图--------------------------*/
        
        UIImage *normalImage = [UIImage imageNamed:@"录入出租房源，写字楼5_03.png"];
        UIImage *hightedImage = [UIImage imageNamed:@"录入出租房源，写字楼5_05.png"];
        //设置图片拉伸
       normalImage = [normalImage stretchableImageWithLeftCapWidth:6 topCapHeight:18.25];
       hightedImage = [hightedImage stretchableImageWithLeftCapWidth:6 topCapHeight:18.25];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:normalImage highlightedImage:hightedImage];
        if (i==0) {
          imageView.frame = CGRectMake(i*imageViewWidth, 0, imageViewWidth, self.frame.size.height);
        }else if(i==1)
        {
            imageView.frame = CGRectMake(i*imageViewWidth+2, 0, imageViewWidth, self.frame.size.height);
        }else if (i==2){
            imageView.frame = CGRectMake(i*imageViewWidth+4, 0, imageViewWidth, self.frame.size.height);
        }
//        imageView.frame = CGRectMake(i*imageViewWidth, 0, imageViewWidth, self.frame.size.height);
        if (i == 0) {
            imageView.highlighted = YES;
        }
        
        [_imageViews addObject:imageView];
        
        [self addSubview:imageView];
        
        /*--------------内容------------------------*/
        
        UILabel *label = [[UILabel alloc] initWithFrame:imageView.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.text = _items[i];
        [imageView addSubview:label];
        
//        [label release];
//        [imageView release];
        
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //获取点击对象
   UITouch *touch = [touches anyObject];
    //获取当前点击的位置
   CGPoint point = [touch locationInView:self];
    
    //计算当前点击的索引
   int index = point.x / imageViewWidth;
    
    //获取当前点击的视图
    UIImageView *currentImageView = _imageViews[index];
    //获取上一次点击的视图
    UIImageView *lastImageView = _imageViews[_lastSelectIndex];
    if (_lastSelectIndex != index) {
        
        lastImageView.highlighted = NO;
        currentImageView.highlighted = YES;
        
    }
    
    //用于记录当前点击的索引
    self.lastSelectIndex = index;
    
    //手动分发事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    
}


@end
