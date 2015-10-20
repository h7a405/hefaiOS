//
//  XSStarView.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-30.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XSStarView;
@protocol XSStarViewDelegate <NSObject>

-(void)starView:(XSStarView *)view DidChangeLevel:(NSInteger)level;

@end
@interface XSStarView : UIView
@property(nonatomic,weak)id<XSStarViewDelegate>delegate;
@end
