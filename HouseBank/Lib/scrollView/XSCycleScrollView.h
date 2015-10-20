//
//  CycleScrollView.h
//  CycleScrollDemo
//
//  Created by Weever Lu on 12-6-14.
//  Copyright (c) 2012年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CycleDirectionPortait,          // 垂直滚动
    CycleDirectionLandscape         // 水平滚动
}CycleDirection;

@protocol CycleScrollViewDelegate;





@interface XSCycleScrollView : UIView <UIScrollViewDelegate> {
    UIScrollView *scrollView;
    UIImageView *curImageView;
    
    int totalPage;
    int curPage;
    CGRect scrollFrame;
    
    CycleDirection scrollDirection;     // scrollView滚动的方向
    NSArray *imagesArray;               // 存放所有需要滚动的图片 UIImage
    NSMutableArray *curImages;          // 存放当前滚动的三张图片
    
    id delegate;
    
    NSTimer *autoScrollTimer;
    NSMutableDictionary *mutlDict;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) UIImage   *defaultImg;

- (int)validPageValue:(NSInteger)value;
- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction pictures:(NSArray *)pictureArray defaultImg:(UIImage *)defaultImg;
- (NSArray *)getDisplayImagesWithCurpage:(int)page;
- (void)refreshScrollView;

- (void)startTimer;

- (void)cleanUpTimerAndCache;

@end

@protocol CycleScrollViewDelegate <NSObject>

@optional
- (void)cycleScrollViewDelegate:(XSCycleScrollView *)cycleScrollView didSelectImageView:(int)index;
- (void)cycleScrollViewDelegate:(XSCycleScrollView *)cycleScrollView didScrollImageView:(int)index;

@end